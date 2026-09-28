import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kora/core/data/database.dart';
import 'package:kora/core/data/demo_seeder.dart';
import 'package:kora/core/errors/app_exception.dart';
import 'package:kora/core/money/money.dart';
import 'package:kora/core/network/mock_network.dart';
import 'package:kora/features/mortgage/data/mortgage_repository.dart';
import 'package:kora/features/mortgage/domain/mortgage.dart';
import 'package:kora/features/transactions/domain/bank_transaction.dart';

void main() {
  late AppDatabase db;
  late MockMortgageRepository repository;
  final now = DateTime(2026, 9, 28, 12);

  Future<int> balance() async =>
      (await db.select(db.accounts).getSingle()).balanceKobo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await DemoSeeder(db, clock: () => now).ensureSeeded();
    repository = MockMortgageRepository(
      db,
      MockNetwork(MockNetworkConfig.instant),
      clock: () => now,
    );
  });

  tearDown(() => db.close());

  test('the demo mortgage is 24 payments in, next due on the 25th', () async {
    final mortgage = (await repository.watchMortgage().first)!;
    expect(mortgage.installmentsPaid, 24);
    expect(mortgage.nextInstallment!.dueDate, DateTime(2026, 10, 25));
  });

  test('repaying debits the account and advances the loan', () async {
    final before = await balance();
    final mortgage = (await repository.watchMortgage().first)!;
    final due = mortgage.nextInstallment!;

    final txn = await repository.repayNextInstallment(
      mortgageId: mortgage.id,
      reference: 'ref-1',
    );
    final after = (await repository.watchMortgage().first)!;

    expect(txn.category, TxnCategory.mortgage);
    expect(txn.amount, due.payment);
    expect(await balance(), before - due.payment.kobo);
    expect(after.installmentsPaid, 25);
    expect(after.outstanding, due.balanceAfter);
  });

  test('retrying with the same reference pays only once', () async {
    final mortgage = (await repository.watchMortgage().first)!;
    final first = await repository.repayNextInstallment(
      mortgageId: mortgage.id,
      reference: 'ref-1',
    );
    final retry = await repository.repayNextInstallment(
      mortgageId: mortgage.id,
      reference: 'ref-1',
    );
    expect(retry.id, first.id);
    expect((await repository.watchMortgage().first)!.installmentsPaid, 25);
  });

  test('refuses when the balance is too low, changing nothing', () async {
    await db
        .update(db.accounts)
        .write(const AccountsCompanion(balanceKobo: Value(100)));
    final mortgage = (await repository.watchMortgage().first)!;
    await expectLater(
      repository.repayNextInstallment(
        mortgageId: mortgage.id,
        reference: 'ref-1',
      ),
      throwsA(isA<InsufficientFundsException>()),
    );
    expect((await repository.watchMortgage().first)!.installmentsPaid, 24);
    expect(await balance(), 100);
  });

  test('applications move through stages over time', () async {
    final application = await repository.submitApplication(
      product: MortgageProduct.individual,
      amount: const Money(2000000000),
      tenorMonths: 180,
      property: '2-bedroom flat, Yaba',
      monthlyIncome: const Money(150000000),
    );
    const step = ApplicationStage.stageDuration;
    expect(application.stageAt(now), ApplicationStage.submitted);
    expect(application.stageAt(now.add(step)), ApplicationStage.review);
    expect(application.stageAt(now.add(step * 10)), ApplicationStage.disbursed);
  });
}
