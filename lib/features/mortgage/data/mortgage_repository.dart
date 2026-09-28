import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/data/database.dart';
import '../../../core/data/mappers.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/money/money.dart';
import '../../../core/network/mock_network.dart';
import '../../transactions/domain/bank_transaction.dart';
import '../domain/mortgage.dart';

abstract interface class MortgageRepository {
  /// The customer's active mortgage, or null if they have none.
  Stream<Mortgage?> watchMortgage();

  /// Pays the next installment from the current account. Idempotent on
  /// [reference], like transfers.
  Future<BankTransaction> repayNextInstallment({
    required String mortgageId,
    required String reference,
  });

  Stream<List<MortgageApplication>> watchApplications();

  Stream<MortgageApplication> watchApplication(String id);

  Future<MortgageApplication> submitApplication({
    required MortgageProduct product,
    required Money amount,
    required int tenorMonths,
    required String property,
    required Money monthlyIncome,
  });
}

class MockMortgageRepository implements MortgageRepository {
  MockMortgageRepository(
    this._db,
    this._network, {
    this._uuid = const Uuid(),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final MockNetwork _network;
  final Uuid _uuid;
  final DateTime Function() _clock;

  @override
  Stream<Mortgage?> watchMortgage() => (_db.select(
    _db.mortgages,
  )..limit(1)).watchSingleOrNull().map((row) => row?.toDomain());

  @override
  Future<BankTransaction> repayNextInstallment({
    required String mortgageId,
    required String reference,
  }) async {
    final existing = await (_db.select(
      _db.transactions,
    )..where((t) => t.reference.equals(reference))).getSingleOrNull();
    if (existing != null) return existing.toDomain();

    await _network.roundTrip();

    final id = _uuid.v4();
    await _db.transaction(() async {
      final mortgage = (await (_db.select(
        _db.mortgages,
      )..where((m) => m.id.equals(mortgageId))).getSingle()).toDomain();
      final installment = mortgage.nextInstallment;
      if (installment == null) {
        throw const ValidationException('This mortgage is fully repaid.');
      }

      final account = await _db.select(_db.accounts).getSingle();
      if (account.balanceKobo < installment.payment.kobo) {
        throw const InsufficientFundsException(
          "You don't have enough money for this repayment.",
        );
      }

      await _db
          .into(_db.transactions)
          .insert(
            TransactionsCompanion.insert(
              id: id,
              accountId: account.id,
              reference: reference,
              direction: TxnDirection.debit,
              category: TxnCategory.mortgage,
              status: TxnStatus.successful,
              amountKobo: installment.payment.kobo,
              narration: Value(
                'Payment ${installment.number} of ${mortgage.tenorMonths}',
              ),
              counterpartyName: 'Mortgage repayment',
              counterpartyAccount: Value(mortgage.propertyName),
              counterpartyBank: Value(mortgage.product.name),
              createdAt: _clock(),
            ),
          );
      await (_db.update(
        _db.accounts,
      )..where((a) => a.id.equals(account.id))).write(
        AccountsCompanion.custom(
          balanceKobo:
              _db.accounts.balanceKobo - Variable(installment.payment.kobo),
        ),
      );
      await (_db.update(
        _db.mortgages,
      )..where((m) => m.id.equals(mortgageId))).write(
        MortgagesCompanion.custom(
          installmentsPaid: _db.mortgages.installmentsPaid + const Variable(1),
        ),
      );
    });

    return (await (_db.select(
      _db.transactions,
    )..where((t) => t.id.equals(id))).getSingle()).toDomain();
  }

  @override
  Stream<List<MortgageApplication>> watchApplications() =>
      (_db.select(_db.mortgageApplications)
            ..orderBy([(a) => OrderingTerm.desc(a.submittedAt)]))
          .watch()
          .map((rows) => [for (final r in rows) r.toDomain()]);

  @override
  Stream<MortgageApplication> watchApplication(String id) => (_db.select(
    _db.mortgageApplications,
  )..where((a) => a.id.equals(id))).watchSingle().map((row) => row.toDomain());

  @override
  Future<MortgageApplication> submitApplication({
    required MortgageProduct product,
    required Money amount,
    required int tenorMonths,
    required String property,
    required Money monthlyIncome,
  }) async {
    await _network.roundTrip();
    final application = MortgageApplication(
      id: 'APP-${_uuid.v4().substring(0, 8).toUpperCase()}',
      product: product,
      amount: amount,
      tenorMonths: tenorMonths,
      property: property,
      monthlyIncome: monthlyIncome,
      submittedAt: _clock(),
    );
    await _db
        .into(_db.mortgageApplications)
        .insert(
          MortgageApplicationsCompanion.insert(
            id: application.id,
            product: product,
            amountKobo: amount.kobo,
            tenorMonths: tenorMonths,
            property: property,
            monthlyIncomeKobo: monthlyIncome.kobo,
            submittedAt: application.submittedAt,
          ),
        );
    return application;
  }
}

final mortgageRepositoryProvider = Provider<MortgageRepository>(
  (ref) => MockMortgageRepository(
    ref.watch(databaseProvider),
    ref.watch(mockNetworkProvider),
  ),
);

final mortgageProvider = StreamProvider<Mortgage?>(
  (ref) => ref.watch(mortgageRepositoryProvider).watchMortgage(),
);

final mortgageApplicationsProvider = StreamProvider<List<MortgageApplication>>(
  (ref) => ref.watch(mortgageRepositoryProvider).watchApplications(),
);

final mortgageApplicationProvider = StreamProvider.autoDispose
    .family<MortgageApplication, String>(
      (ref, id) => ref.watch(mortgageRepositoryProvider).watchApplication(id),
    );

/// Ticks so application stages advance on screen without a refresh.
final clockProvider = StreamProvider.autoDispose<DateTime>(
  (ref) => Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
);
