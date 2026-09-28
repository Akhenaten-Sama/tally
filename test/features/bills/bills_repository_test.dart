import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kora/core/data/database.dart';
import 'package:kora/core/data/mock_ledger.dart';
import 'package:kora/core/errors/app_exception.dart';
import 'package:kora/core/money/money.dart';
import 'package:kora/core/network/mock_network.dart';
import 'package:kora/features/auth/domain/phone_number.dart';
import 'package:kora/features/bills/data/bills_repository.dart';
import 'package:kora/features/bills/domain/billers.dart';
import 'package:kora/features/transactions/domain/bank_transaction.dart';

void main() {
  late AppDatabase db;
  late MockNetwork network;
  late MockLedger ledger;
  late MockBillsRepository bills;
  final phone = PhoneNumber.tryParse('08031234567')!;
  const startingBalance = 10000000; // ₦100,000

  Future<int> balance() async =>
      (await db.select(db.accounts).getSingle()).balanceKobo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    network = MockNetwork(MockNetworkConfig.instant);
    ledger = MockLedger(db, network);
    bills = MockBillsRepository(ledger, network);
    await db
        .into(db.accounts)
        .insert(
          AccountsCompanion.insert(
            id: 'acct',
            holderName: 'Test User',
            accountNumber: '8000000001',
            balanceKobo: startingBalance,
            kycTier: const Value(2),
          ),
        );
  });

  tearDown(() async {
    ledger.dispose();
    await db.close();
  });

  group('network detection', () {
    test('recognises each network by prefix', () {
      MobileNetwork? of(String n) =>
          MobileNetwork.detect(PhoneNumber.tryParse(n)!);
      expect(of('08031234567'), MobileNetwork.mtn);
      expect(of('08021234567'), MobileNetwork.airtel);
      expect(of('08051234567'), MobileNetwork.glo);
      expect(of('08091234567'), MobileNetwork.nineMobile);
    });

    test('data plans are whole-naira prices per network', () {
      for (final n in MobileNetwork.values) {
        expect(n.dataPlans, isNotEmpty);
        expect(n.dataPlans.every((p) => p.price.kobo % 100 == 0), isTrue);
      }
    });
  });

  test('airtime debits the account once per reference', () async {
    final first = await bills.buyAirtime(
      reference: 'a1',
      network: MobileNetwork.mtn,
      phone: phone,
      amount: Money.naira(500),
    );
    await bills.buyAirtime(
      reference: 'a1',
      network: MobileNetwork.mtn,
      phone: phone,
      amount: Money.naira(500),
    );
    expect(first.category, TxnCategory.airtime);
    expect(first.counterpartyAccount, '08031234567');
    expect(await balance(), startingBalance - 50000);
  });

  test('rejects airtime outside ₦50–₦50,000', () async {
    await expectLater(
      bills.buyAirtime(
        reference: 'a2',
        network: MobileNetwork.glo,
        phone: phone,
        amount: Money.naira(20),
      ),
      throwsA(isA<ValidationException>()),
    );
  });

  test('prepaid electricity returns a 20-digit token', () async {
    const meter = '45071239981';
    final customer = await bills.validateMeter(
      disco: Disco.ikeja,
      type: MeterType.prepaid,
      meterNumber: meter,
    );
    final txn = await bills.payElectricity(
      reference: 'e1',
      disco: Disco.ikeja,
      type: MeterType.prepaid,
      meterNumber: meter,
      customer: customer,
      amount: Money.naira(10000),
    );
    expect(txn.electricityToken, matches(RegExp(r'^\d{4}(-\d{4}){4}$')));
    expect(txn.narration, contains('kWh'));
  });

  test('meter lookups are deterministic', () async {
    Future<BillCustomer> look() => bills.validateMeter(
      disco: Disco.eko,
      type: MeterType.prepaid,
      meterNumber: '12345678901',
    );
    expect((await look()).name, (await look()).name);
  });

  test('a failed biller refunds the payment', () async {
    network.config = network.config.copyWith(outcomeMode: OutcomeMode.failure);
    final plan = MobileNetwork.airtel.dataPlans.first;
    final txn = await bills.buyData(reference: 'd1', plan: plan, phone: phone);

    expect(txn.status, TxnStatus.reversed);
    expect(await balance(), startingBalance);
  });

  test('cable subscriptions charge the package price', () async {
    final package = CableProvider.gotv.packages.first;
    const card = '7023418890';
    final customer = await bills.validateSmartcard(
      provider: CableProvider.gotv,
      smartcardNumber: card,
    );
    await bills.payCable(
      reference: 'c1',
      package: package,
      smartcardNumber: card,
      customer: customer,
    );
    expect(await balance(), startingBalance - package.price.kobo);
  });
}
