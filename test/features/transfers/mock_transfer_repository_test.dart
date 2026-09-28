import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tally/core/data/database.dart';
import 'package:tally/core/errors/app_exception.dart';
import 'package:tally/core/money/money.dart';
import 'package:tally/core/network/mock_network.dart';
import 'package:tally/features/transactions/domain/bank_transaction.dart';
import 'package:tally/features/transfers/data/mock_transfer_repository.dart';
import 'package:tally/features/transfers/domain/bank.dart';
import 'package:tally/features/transfers/domain/transfer.dart';

void main() {
  late AppDatabase db;
  late MockNetwork network;
  late MockTransferRepository repository;

  const startingBalance = Money(10000000); // ₦100,000
  final now = DateTime(2026, 9, 28, 12);
  final gtb = Bank.byCode('058');

  TransferRequest request({
    String reference = 'ref-1',
    Money amount = const Money(1000000),
    Bank? bank,
  }) => TransferRequest(
    reference: reference,
    bank: bank ?? gtb,
    accountNumber: '0123456780',
    accountName: 'OKAFOR CHINEDU',
    amount: amount,
  );

  Future<Money> balance() async =>
      Money((await db.select(db.accounts).getSingle()).balanceKobo);

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    network = MockNetwork(MockNetworkConfig.instant);
    repository = MockTransferRepository(db, network, clock: () => now);
    await db
        .into(db.accounts)
        .insert(
          AccountsCompanion.insert(
            id: 'acct',
            holderName: 'Test User',
            accountNumber: '8000000001',
            balanceKobo: startingBalance.kobo,
            kycTier: const Value(2),
          ),
        );
  });

  tearDown(() async {
    repository.dispose();
    await db.close();
  });

  test('successful transfer debits amount plus NIP fee', () async {
    final txn = await repository.send(request());

    expect(txn.status, TxnStatus.successful);
    expect(txn.fee, const Money(2688));
    expect(await balance(), startingBalance - const Money(1002688));
  });

  test('transfers to Tally accounts are free', () async {
    await repository.send(request(bank: Bank.internal));

    expect(await balance(), startingBalance - const Money(1000000));
  });

  test('retrying with the same reference does not debit twice', () async {
    final first = await repository.send(request());
    final retry = await repository.send(request());

    expect(retry.id, first.id);
    expect(await balance(), startingBalance - first.total);
  });

  test('provider failure reverses the debit with a separate credit', () async {
    network.config = network.config.copyWith(outcomeMode: OutcomeMode.failure);

    final txn = await repository.send(request());
    final rows = await db.select(db.transactions).get();

    expect(txn.status, TxnStatus.reversed);
    expect(await balance(), startingBalance);
    expect(
      rows.singleWhere((r) => r.category == TxnCategory.reversal).amountKobo,
      txn.total.kobo,
    );
  });

  test('rejects transfers above the balance without recording them', () async {
    await expectLater(
      repository.send(request(amount: const Money(20000000))),
      throwsA(isA<InsufficientFundsException>()),
    );
    expect(await db.select(db.transactions).get(), isEmpty);
    expect(await balance(), startingBalance);
  });

  test('enforces the KYC daily limit across transfers', () async {
    await (db.update(db.accounts)).write(
      const AccountsCompanion(kycTier: Value(1), balanceKobo: Value(99999999)),
    );
    await repository.send(request(amount: const Money(4000000)));

    await expectLater(
      repository.send(
        request(reference: 'ref-2', amount: const Money(1000000)),
      ),
      throwsA(isA<LimitExceededException>()),
    );
  });

  test('offline requests fail before any money moves', () async {
    network.config = network.config.copyWith(offline: true);

    await expectLater(
      repository.send(request()),
      throwsA(isA<NetworkException>()),
    );
    expect(await balance(), startingBalance);
  });

  test('reconcilePending settles stale pending transfers', () async {
    network.config = network.config.copyWith(outcomeMode: OutcomeMode.pending);
    await repository.send(request());
    repository.dispose(); // simulate the app being killed

    final later = MockTransferRepository(
      db,
      network,
      clock: () => now.add(const Duration(minutes: 5)),
    );
    await later.reconcilePending();

    final row = await (db.select(
      db.transactions,
    )..where((t) => t.reference.equals('ref-1'))).getSingle();
    expect(row.status, isNot(TxnStatus.pending));
  });
}
