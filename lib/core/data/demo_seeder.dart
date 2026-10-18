import 'dart:math';

import 'package:drift/drift.dart';

import '../../features/transactions/domain/bank_transaction.dart';
import '../../features/transfers/data/mock_directory.dart';
import '../../features/transfers/domain/bank.dart';
import '../../features/mortgage/domain/amortization.dart';
import '../../features/mortgage/domain/mortgage.dart';
import '../../features/transfers/domain/transfer.dart';
import '../money/money.dart';
import '../utils/references.dart';
import 'database.dart';

/// Fills a fresh install with two believable months of activity.
class DemoSeeder {
  DemoSeeder(this._db, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;

  static const accountId = 'acct_main';
  static const holderName = 'Olalekan Israel Efunkunle';
  static const accountNumber = '4020207330';

  // Personal details shown under Profile → Personal details.
  static const phone = '08130005574';
  static const email = 'olalekanefunkunle@gmail.com';
  static const address = '12 Admiralty Way, Lekki Phase 1, Lagos';
  static final dateOfBirth = DateTime(1996, 3, 07);
  static const bvnLast4 = '4821';

  /// In kobo (₦1 = 100 kobo), never a decimal.
  static const openingBalanceKobo = 1878956423; // ₦18,789,564.23

  /// Bump after changing any seed data above to reset installed apps to it
  /// on next launch. Transfers made in the app are wiped when this changes.
  static const seedVersion = 9;
  static const _seedVersionKey = 'seed_version';

  Future<void> ensureSeeded() async {
    final stored = await (_db.select(
      _db.demoMeta,
    )..where((m) => m.key.equals(_seedVersionKey))).getSingleOrNull();
    if (stored?.value != '$seedVersion') await reset();
  }

  Future<void> reset() async {
    await _db.clear();
    await _seed();
  }

  Future<void> _seed() => _db.transaction(() async {
    await _db
        .into(_db.demoMeta)
        .insertOnConflictUpdate(
          DemoMetaCompanion.insert(key: _seedVersionKey, value: '$seedVersion'),
        );
    await _db
        .into(_db.accounts)
        .insert(
          AccountsCompanion.insert(
            id: accountId,
            holderName: holderName,
            accountNumber: accountNumber,
            balanceKobo: openingBalanceKobo,
            kycTier: const Value(3),
          ),
        );
    await _db.batch((b) => b.insertAll(_db.transactions, _history()));
    await _db
        .into(_db.customerProfiles)
        .insert(
          CustomerProfilesCompanion.insert(
            accountId: accountId,
            phone: phone,
            email: const Value(email),
            dateOfBirth: Value(dateOfBirth),
            address: const Value(address),
            bvnLast4: const Value(bvnLast4),
            memberSince: DateTime(_clock().year - 5, 3, 12),
          ),
        );
    // Only the last couple of days' notifications start out unread.
    await _db
        .into(_db.demoMeta)
        .insertOnConflictUpdate(
          DemoMetaCompanion.insert(
            key: 'notifications_seen_at',
            value: _clock().subtract(const Duration(days: 2)).toIso8601String(),
          ),
        );
    await _seedMortgage();
  });

  /// ₦15m NHF mortgage, 20 years, 24 payments made; the next is due on the
  /// coming 25th so the demo always has an upcoming repayment.
  Future<void> _seedMortgage() async {
    const paid = 24;
    final now = _clock();
    final nextDue = now.day < 25
        ? DateTime(now.year, now.month, 25)
        : DateTime(now.year, now.month + 1, 25);
    final mortgage = Mortgage(
      id: 'mtg_main',
      product: MortgageProduct.nhf,
      propertyName: '3-bedroom terrace duplex',
      propertyLocation: 'CMB Cooperative Estate, Ikorodu, Lagos',
      principal: const Money(1500000000),
      tenorMonths: 240,
      firstDueDate: addMonths(nextDue, -paid),
      installmentsPaid: paid,
    );
    await _db
        .into(_db.mortgages)
        .insert(
          MortgagesCompanion.insert(
            id: mortgage.id,
            product: mortgage.product,
            propertyName: mortgage.propertyName,
            propertyLocation: mortgage.propertyLocation,
            principalKobo: mortgage.principal.kobo,
            tenorMonths: mortgage.tenorMonths,
            firstDueDate: mortgage.firstDueDate,
            installmentsPaid: paid,
          ),
        );

    // The last two monthly repayments fall inside the demo history.
    final random = Random(91);
    for (final installment in mortgage.schedule.sublist(paid - 2, paid)) {
      await _db
          .into(_db.transactions)
          .insert(
            TransactionsCompanion.insert(
              id: 'seed_mortgage_${installment.number}',
              accountId: accountId,
              reference: newReference(random: random),
              direction: TxnDirection.debit,
              category: TxnCategory.mortgage,
              status: TxnStatus.successful,
              amountKobo: installment.payment.kobo,
              narration: Value('Payment ${installment.number} of 240'),
              counterpartyName: 'Mortgage repayment',
              counterpartyAccount: Value(mortgage.propertyName),
              counterpartyBank: Value(mortgage.product.name),
              createdAt: installment.dueDate.add(const Duration(hours: 9)),
            ),
          );
    }
  }

  /// About 60 days of everyday activity, newest last.
  List<TransactionsCompanion> _history() {
    // Fixed seed: every install sees the same account.
    final random = Random(9);
    final now = _clock();
    final entries = <TransactionsCompanion>[];
    var n = 0;

    TransactionsCompanion entry({
      required DateTime at,
      required TxnDirection direction,
      required TxnCategory category,
      required int amountKobo,
      required String counterparty,
      int feeKobo = 0,
      TxnStatus status = TxnStatus.successful,
      String narration = '',
      String? account,
      String? bank,
      String? reference,
    }) {
      n++;
      return TransactionsCompanion.insert(
        id: 'seed_$n',
        accountId: accountId,
        reference: reference ?? newReference(random: random),
        direction: direction,
        category: category,
        status: status,
        amountKobo: amountKobo,
        feeKobo: Value(feeKobo),
        narration: Value(narration),
        counterpartyName: counterparty,
        counterpartyAccount: Value(account),
        counterpartyBank: Value(bank),
        createdAt: at,
      );
    }

    DateTime dayAt(int daysAgo) {
      final day = now.subtract(Duration(days: daysAgo));
      return DateTime(
        day.year,
        day.month,
        day.day,
        8 + random.nextInt(12),
        random.nextInt(60),
      );
    }

    String person() =>
        '${lastNames[random.nextInt(lastNames.length)]} '
                '${firstNames[random.nextInt(firstNames.length)]} '
                '${firstNames[random.nextInt(firstNames.length)]}'
            .toUpperCase();

    String accountNo() => List.generate(10, (_) => random.nextInt(10)).join();

    Bank otherBank() => Bank.all[1 + random.nextInt(Bank.all.length - 1)];

    const window = 60;

    // Salary on the 28th of each month in the window.
    for (var daysAgo = window; daysAgo >= 1; daysAgo--) {
      final day = now.subtract(Duration(days: daysAgo));
      if (day.day == 28) {
        entries.add(
          entry(
            at: DateTime(day.year, day.month, day.day, 10, 12),
            direction: TxnDirection.credit,
            category: TxnCategory.transfer,
            amountKobo: 45000000,
            counterparty: 'BRIGHTPATH TECHNOLOGIES LTD',
            narration: 'Salary Transfer Payment',
            account: '1012345678',
            bank: 'Zenith Bank',
          ),
        );
      }
    }

    // Everyday activity.
    for (var daysAgo = window; daysAgo >= 1; daysAgo--) {
      final roll = random.nextInt(10);
      if (roll < 4) {
        final bank = otherBank();
        final amount = Money((2 + random.nextInt(60)) * 250000);
        entries.add(
          entry(
            at: dayAt(daysAgo),
            direction: TxnDirection.debit,
            category: TxnCategory.transfer,
            amountKobo: amount.kobo,
            feeKobo: transferFee(amount, bank: bank).kobo,
            counterparty: person(),
            account: accountNo(),
            bank: bank.name,
          ),
        );
      } else if (roll < 6) {
        entries.add(
          entry(
            at: dayAt(daysAgo),
            direction: TxnDirection.credit,
            category: TxnCategory.transfer,
            amountKobo: (5 + random.nextInt(60)) * 100000,
            counterparty: person(),
            account: accountNo(),
            bank: otherBank().name,
          ),
        );
      } else if (roll < 8) {
        final network = ['MTN', 'Airtel', 'Glo', '9mobile'][random.nextInt(4)];
        final isData = random.nextBool();
        entries.add(
          entry(
            at: dayAt(daysAgo),
            direction: TxnDirection.debit,
            category: isData ? TxnCategory.data : TxnCategory.airtime,
            amountKobo: isData ? 300000 : 100000 * (1 + random.nextInt(5)),
            counterparty: '$network ${isData ? 'Data' : 'Airtime'}',
            narration: isData ? '3.5GB · 30 days' : '',
            account: '0803${1000000 + random.nextInt(8999999)}',
          ),
        );
      }
    }

    // Monthly bills and interest, roughly a month apart.
    for (final daysAgo in [44, 14]) {
      entries.addAll([
        entry(
          at: dayAt(daysAgo),
          direction: TxnDirection.debit,
          category: TxnCategory.cable,
          amountKobo: 1900000,
          counterparty: 'DStv Compact',
          narration: 'Compact · 1 month',
          account: '7023418890',
        ),
        entry(
          at: dayAt(daysAgo - 8),
          direction: TxnDirection.debit,
          category: TxnCategory.electricity,
          amountKobo: 2000000,
          counterparty: 'Ikeja Electric (Prepaid)',
          narration: '4821-0937-5512-6640-1873 · 95.5 kWh',
          account: '45071239981',
        ),
        entry(
          at: dayAt(daysAgo - 11),
          direction: TxnDirection.credit,
          category: TxnCategory.interest,
          amountKobo: 41250,
          counterparty: 'Interest: Savings',
        ),
      ]);
    }

    // A transfer that failed and was refunded a few minutes later.
    final failedAt = now.subtract(const Duration(days: 2, hours: 3));
    final failedRef = newReference(random: random);
    entries.addAll([
      entry(
        at: failedAt,
        direction: TxnDirection.debit,
        category: TxnCategory.transfer,
        status: TxnStatus.reversed,
        amountKobo: 5000000,
        feeKobo: 2688,
        counterparty: 'ADEBAYO FOLAKE',
        account: '0123456789',
        bank: 'Guaranty Trust Bank',
        reference: failedRef,
      ),
      entry(
        at: failedAt.add(const Duration(minutes: 12)),
        direction: TxnDirection.credit,
        category: TxnCategory.reversal,
        amountKobo: 5002688,
        counterparty: 'Reversal: ADEBAYO FOLAKE',
        narration: 'Refund for failed transfer',
        account: '0123456789',
        bank: 'Guaranty Trust Bank',
        reference: reversalReference(failedRef),
      ),
    ]);

    return entries;
  }
}
