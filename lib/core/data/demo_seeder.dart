import 'dart:math';

import 'package:drift/drift.dart';

import '../../features/transactions/domain/bank_transaction.dart';
import '../../features/transfers/data/mock_directory.dart';
import '../../features/transfers/domain/bank.dart';
import '../../features/mortgage/domain/amortization.dart';
import '../../features/mortgage/domain/mortgage.dart';
import '../money/money.dart';
import 'database.dart';

/// Fills a fresh install with a believable month of activity.
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
  static const openingBalanceKobo = 1378956423; // ₦12,789,564.23

  /// Bump after changing any seed data above to reset installed apps to it
  /// on next launch. Transfers made in the app are wiped when this changes.
  static const seedVersion = 7;
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

    final last = mortgage.schedule[paid - 1];
    await _db
        .into(_db.transactions)
        .insert(
          TransactionsCompanion.insert(
            id: 'seed_mortgage_$paid',
            accountId: accountId,
            reference: 'CMB-MTG-${last.number.toString().padLeft(3, '0')}',
            direction: TxnDirection.debit,
            category: TxnCategory.mortgage,
            status: TxnStatus.successful,
            amountKobo: last.payment.kobo,
            narration: Value('Payment ${last.number} of 240'),
            counterpartyName: 'Mortgage repayment',
            counterpartyAccount: Value(mortgage.propertyName),
            counterpartyBank: Value(mortgage.product.name),
            createdAt: last.dueDate.add(const Duration(hours: 9)),
          ),
        );
  }

  List<TransactionsCompanion> _history() {
    // Fixed seed: every reviewer sees the same account.
    final random = Random(7);
    final now = _clock();
    final entries = <TransactionsCompanion>[];
    var n = 0;

    TransactionsCompanion entry({
      required int daysAgo,
      required TxnDirection direction,
      required TxnCategory category,
      required int amountKobo,
      required String counterparty,
      int feeKobo = 0,
      TxnStatus status = TxnStatus.successful,
      String narration = '',
      String? account,
      String? bank,
      Duration? ago,
    }) {
      n++;
      final at = ago != null
          ? now.subtract(ago)
          : now.subtract(
              Duration(
                days: daysAgo,
                hours: daysAgo == 0 ? 0 : random.nextInt(12),
                minutes: 5 + random.nextInt(50),
              ),
            );
      return TransactionsCompanion.insert(
        id: 'seed_$n',
        accountId: accountId,
        reference: 'TALLY-SEED-${n.toString().padLeft(4, '0')}',
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

    String person() =>
        '${lastNames[random.nextInt(lastNames.length)]} '
                '${firstNames[random.nextInt(firstNames.length)]}'
            .toUpperCase();

    String accountNo() => List.generate(10, (_) => random.nextInt(10)).join();

    Bank bank() => Bank.all[1 + random.nextInt(Bank.all.length - 1)];

    entries.add(
      entry(
        daysAgo: 27,
        direction: TxnDirection.credit,
        category: TxnCategory.transfer,
        amountKobo: 45000000,
        counterparty: 'BRIGHTPATH TECHNOLOGIES LTD',
        narration: 'Salary',
        bank: 'Zenith Bank',
      ),
    );

    for (var day = 26; day >= 1; day--) {
      final roll = random.nextInt(10);
      if (roll < 4) {
        final b = bank();
        entries.add(
          entry(
            daysAgo: day,
            direction: TxnDirection.debit,
            category: TxnCategory.transfer,
            amountKobo: (2 + random.nextInt(40)) * 100000,
            feeKobo: 2688,
            counterparty: person(),
            account: accountNo(),
            bank: b.name,
          ),
        );
      } else if (roll < 6) {
        final network = ['MTN', 'Airtel', 'Glo', '9mobile'][random.nextInt(4)];
        final isData = random.nextBool();
        entries.add(
          entry(
            daysAgo: day,
            direction: TxnDirection.debit,
            category: isData ? TxnCategory.data : TxnCategory.airtime,
            amountKobo: isData ? 350000 : 100000 * (1 + random.nextInt(5)),
            counterparty: '$network ${isData ? 'Data' : 'Airtime'}',
            account: '0803${1000000 + random.nextInt(8999999)}',
          ),
        );
      } else if (roll < 8) {
        entries.add(
          entry(
            daysAgo: day,
            direction: TxnDirection.credit,
            category: TxnCategory.transfer,
            amountKobo: (5 + random.nextInt(60)) * 100000,
            counterparty: person(),
            account: accountNo(),
            bank: bank().name,
          ),
        );
      }
    }

    entries.addAll([
      entry(
        daysAgo: 12,
        direction: TxnDirection.debit,
        category: TxnCategory.cable,
        amountKobo: 1570000,
        counterparty: 'DStv Compact',
        account: '7023418890',
      ),
      entry(
        daysAgo: 6,
        direction: TxnDirection.debit,
        category: TxnCategory.electricity,
        amountKobo: 2000000,
        counterparty: 'Ikeja Electric (Prepaid)',
        account: '45071239981',
      ),
      entry(
        daysAgo: 3,
        direction: TxnDirection.credit,
        category: TxnCategory.interest,
        amountKobo: 41250,
        counterparty: 'Interest: Rent goal',
      ),
      // A transfer that failed and was refunded.
      entry(
        daysAgo: 2,
        ago: const Duration(days: 2, hours: 3),
        direction: TxnDirection.debit,
        category: TxnCategory.transfer,
        status: TxnStatus.reversed,
        amountKobo: 5000000,
        feeKobo: 2688,
        counterparty: 'ADEBAYO FOLAKE',
        account: '0123456789',
        bank: 'Guaranty Trust Bank',
      ),
      entry(
        daysAgo: 2,
        ago: const Duration(days: 2, hours: 2, minutes: 48),
        direction: TxnDirection.credit,
        category: TxnCategory.reversal,
        amountKobo: 5002688,
        counterparty: 'Reversal: ADEBAYO FOLAKE',
        narration: 'Refund for failed transfer',
      ),
    ]);

    return entries;
  }
}
