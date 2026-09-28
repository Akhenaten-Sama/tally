import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../features/account/domain/account.dart';
import '../../features/transactions/domain/bank_transaction.dart';
import '../errors/app_exception.dart';
import '../money/money.dart';
import '../network/mock_network.dart';
import 'database.dart';
import 'mappers.dart';

/// Money leaving the account for an outside party (a bank, a biller).
class LedgerDebit {
  const LedgerDebit({
    required this.reference,
    required this.category,
    required this.amount,
    required this.counterpartyName,
    this.fee = const Money.zero(),
    this.narration = '',
    this.counterpartyAccount,
    this.counterpartyBank,
  });

  /// Idempotency key: the same reference never debits twice.
  final String reference;
  final TxnCategory category;
  final Money amount;
  final Money fee;
  final String narration;
  final String counterpartyName;
  final String? counterpartyAccount;
  final String? counterpartyBank;

  Money get total => amount + fee;
}

/// Behaves like a bank core: debit first, then settle with the provider,
/// reversing the debit if the provider fails. Every balance change happens
/// inside a database transaction together with the entry that explains it.
/// Shared by transfers and bill payments.
class MockLedger {
  MockLedger(
    this._db,
    this._network, {
    this._uuid = const Uuid(),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final MockNetwork _network;
  final Uuid _uuid;
  final DateTime Function() _clock;
  final _timers = <Timer>{};

  /// Pending payments older than this are settled by [reconcilePending].
  static const staleAfter = Duration(minutes: 1);

  /// Chance a pending payment eventually succeeds rather than reverses.
  static const pendingSuccessRate = 0.8;

  /// Debits the account, then settles with the (mock) provider.
  /// [beforeSettle] runs once the money is held, e.g. to save a beneficiary.
  Future<BankTransaction> pay(
    LedgerDebit debit, {
    Future<void> Function()? beforeSettle,
  }) async {
    final existing = await _findByReference(debit.reference);
    if (existing != null) return existing.toDomain();

    await _network.roundTrip();
    final id = await _debit(debit);
    await beforeSettle?.call();

    switch (_network.settle()) {
      case MockOutcome.success:
        await _complete(id);
      case MockOutcome.failure:
        await _reverse(id);
      case MockOutcome.pending:
        _settleLater(id);
    }
    return (await _findById(id)).toDomain();
  }

  /// Settles payments left pending, e.g. when the app was killed mid-flight.
  Future<void> reconcilePending() async {
    final cutoff = _clock().subtract(staleAfter);
    final stale =
        await (_db.select(_db.transactions)..where(
              (t) =>
                  t.status.equalsValue(TxnStatus.pending) &
                  t.createdAt.isSmallerThanValue(cutoff),
            ))
            .get();
    for (final txn in stale) {
      await _settlePending(txn.id);
    }
  }

  void dispose() {
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();
  }

  Future<String> _debit(LedgerDebit debit) async {
    final id = _uuid.v4();
    await _db.transaction(() async {
      final account = await _db.select(_db.accounts).getSingle();
      if (account.balanceKobo < debit.total.kobo) {
        throw const InsufficientFundsException(
          "You don't have enough money for this payment.",
        );
      }
      final limit = KycTier.fromLevel(account.kycTier).dailyLimit;
      final spent = await _spentToday(account.id);
      if (spent + debit.total > limit) {
        throw LimitExceededException(limit - spent);
      }

      await _db
          .into(_db.transactions)
          .insert(
            TransactionsCompanion.insert(
              id: id,
              accountId: account.id,
              reference: debit.reference,
              direction: TxnDirection.debit,
              category: debit.category,
              status: TxnStatus.pending,
              amountKobo: debit.amount.kobo,
              feeKobo: Value(debit.fee.kobo),
              narration: Value(debit.narration),
              counterpartyName: debit.counterpartyName,
              counterpartyAccount: Value(debit.counterpartyAccount),
              counterpartyBank: Value(debit.counterpartyBank),
              createdAt: _clock(),
            ),
          );
      await _adjustBalance(account.id, -debit.total.kobo);
    });
    return id;
  }

  void _settleLater(String id) {
    late final Timer timer;
    timer = Timer(_network.pendingDelay(), () {
      _timers.remove(timer);
      unawaited(_settlePending(id));
    });
    _timers.add(timer);
  }

  Future<void> _settlePending(String id) =>
      _network.chance(pendingSuccessRate) ? _complete(id) : _reverse(id);

  Future<void> _complete(String id) => _db.transaction(() async {
    final txn = await _findById(id);
    if (txn.status != TxnStatus.pending) return;
    await _setStatus(id, TxnStatus.successful);
  });

  /// Refunds a debit as a separate credit entry, so history shows what
  /// happened rather than silently rewriting it. Safe to call twice.
  Future<void> _reverse(String id) => _db.transaction(() async {
    final txn = await _findById(id);
    if (txn.status != TxnStatus.pending) return;
    final refund = txn.amountKobo + txn.feeKobo;
    final what = txn.category == TxnCategory.transfer ? 'transfer' : 'payment';

    await _setStatus(id, TxnStatus.reversed);
    await _db
        .into(_db.transactions)
        .insert(
          TransactionsCompanion.insert(
            id: _uuid.v4(),
            accountId: txn.accountId,
            reference: '${txn.reference}-rev',
            direction: TxnDirection.credit,
            category: TxnCategory.reversal,
            status: TxnStatus.successful,
            amountKobo: refund,
            narration: Value('Refund for failed $what'),
            counterpartyName: 'Reversal: ${txn.counterpartyName}',
            counterpartyAccount: Value(txn.counterpartyAccount),
            counterpartyBank: Value(txn.counterpartyBank),
            createdAt: _clock(),
          ),
        );
    await _adjustBalance(txn.accountId, refund);
  });

  Future<Money> _spentToday(String accountId) async {
    final now = _clock();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final rows =
        await (_db.select(_db.transactions)..where(
              (t) =>
                  t.accountId.equals(accountId) &
                  t.createdAt.isBiggerOrEqualValue(startOfDay),
            ))
            .get();
    return rows
        .where(
          (r) =>
              r.direction == TxnDirection.debit &&
              (r.status == TxnStatus.pending ||
                  r.status == TxnStatus.successful),
        )
        .fold<Money>(
          const Money.zero(),
          (sum, r) => sum + Money(r.amountKobo + r.feeKobo),
        );
  }

  Future<void> _adjustBalance(String accountId, int deltaKobo) async {
    await (_db.update(
      _db.accounts,
    )..where((a) => a.id.equals(accountId))).write(
      AccountsCompanion.custom(
        balanceKobo: _db.accounts.balanceKobo + Variable(deltaKobo),
      ),
    );
  }

  Future<void> _setStatus(String id, TxnStatus status) async {
    await (_db.update(_db.transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(status: Value(status)),
    );
  }

  Future<TransactionRow> _findById(String id) =>
      (_db.select(_db.transactions)..where((t) => t.id.equals(id))).getSingle();

  Future<TransactionRow?> _findByReference(String reference) => (_db.select(
    _db.transactions,
  )..where((t) => t.reference.equals(reference))).getSingleOrNull();
}

final mockLedgerProvider = Provider<MockLedger>((ref) {
  final ledger = MockLedger(
    ref.watch(databaseProvider),
    ref.watch(mockNetworkProvider),
  );
  ref.onDispose(ledger.dispose);
  return ledger;
});
