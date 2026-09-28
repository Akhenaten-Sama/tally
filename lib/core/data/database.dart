import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/mortgage/domain/mortgage.dart';
import '../../features/transactions/domain/bank_transaction.dart';

part 'database.g.dart';

@DataClassName('AccountRow')
class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get holderName => text()();
  TextColumn get accountNumber => text().withLength(min: 10, max: 10)();
  IntColumn get balanceKobo => integer()();
  IntColumn get kycTier => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TransactionRow')
class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().references(Accounts, #id)();
  TextColumn get reference => text().unique()();
  TextColumn get direction => textEnum<TxnDirection>()();
  TextColumn get category => textEnum<TxnCategory>()();
  TextColumn get status => textEnum<TxnStatus>()();
  IntColumn get amountKobo => integer()();
  IntColumn get feeKobo => integer().withDefault(const Constant(0))();
  TextColumn get narration => text().withDefault(const Constant(''))();
  TextColumn get counterpartyName => text()();
  TextColumn get counterpartyAccount => text().nullable()();
  TextColumn get counterpartyBank => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('BeneficiaryRow')
class Beneficiaries extends Table {
  TextColumn get bankCode => text()();
  TextColumn get accountNumber => text()();
  TextColumn get name => text()();
  DateTimeColumn get lastUsedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {bankCode, accountNumber};
}

@DataClassName('MortgageRow')
class Mortgages extends Table {
  TextColumn get id => text()();
  TextColumn get product => textEnum<MortgageProduct>()();
  TextColumn get propertyName => text()();
  TextColumn get propertyLocation => text()();
  IntColumn get principalKobo => integer()();
  IntColumn get tenorMonths => integer()();
  DateTimeColumn get firstDueDate => dateTime()();
  IntColumn get installmentsPaid => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MortgageApplicationRow')
class MortgageApplications extends Table {
  TextColumn get id => text()();
  TextColumn get product => textEnum<MortgageProduct>()();
  IntColumn get amountKobo => integer()();
  IntColumn get tenorMonths => integer()();
  TextColumn get property => text()();
  IntColumn get monthlyIncomeKobo => integer()();
  DateTimeColumn get submittedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CustomerProfileRow')
class CustomerProfiles extends Table {
  TextColumn get accountId => text().references(Accounts, #id)();
  TextColumn get phone => text()();
  TextColumn get email => text().nullable()();
  DateTimeColumn get dateOfBirth => dateTime().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get bvnLast4 => text().nullable()();
  TextColumn get ninLast4 => text().nullable()();
  DateTimeColumn get memberSince => dateTime()();

  @override
  Set<Column> get primaryKey => {accountId};
}

/// Key-value bookkeeping for the demo, e.g. which seed version is loaded.
@DataClassName('DemoMetaRow')
class DemoMeta extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// Local store standing in for the bank's backend. Balances and history
/// survive restarts so the demo feels like a real account.
@DriftDatabase(
  tables: [
    Accounts,
    Transactions,
    Beneficiaries,
    DemoMeta,
    Mortgages,
    MortgageApplications,
    CustomerProfiles,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'tally'));

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.createTable(demoMeta);
      if (from < 3) {
        await m.createTable(mortgages);
        await m.createTable(mortgageApplications);
      }
      if (from < 4) await m.createTable(customerProfiles);
    },
  );

  Future<void> clear() => transaction(() async {
    for (final table in allTables) {
      await delete(table).go();
    }
  });
}

final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('Overridden in main()'),
);
