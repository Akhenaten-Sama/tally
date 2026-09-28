import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/mock_ledger.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/lookups/lookup_providers.dart';
import '../../../core/lookups/vtpass_biller_lookup.dart';
import '../../../core/money/money.dart';
import '../../../core/network/mock_network.dart';
import '../../auth/domain/phone_number.dart';
import '../../transactions/domain/bank_transaction.dart';
import '../../transfers/data/mock_directory.dart';
import '../domain/billers.dart';

abstract interface class BillsRepository {
  Future<BankTransaction> buyAirtime({
    required String reference,
    required MobileNetwork network,
    required PhoneNumber phone,
    required Money amount,
  });

  Future<BankTransaction> buyData({
    required String reference,
    required DataPlan plan,
    required PhoneNumber phone,
  });

  /// Meter lookup, shown before paying so the customer can check it.
  Future<BillCustomer> validateMeter({
    required Disco disco,
    required MeterType type,
    required String meterNumber,
  });

  /// Prepaid purchases carry the 20-digit token in the narration.
  Future<BankTransaction> payElectricity({
    required String reference,
    required Disco disco,
    required MeterType type,
    required String meterNumber,
    required BillCustomer customer,
    required Money amount,
  });

  Future<BillCustomer> validateSmartcard({
    required CableProvider provider,
    required String smartcardNumber,
  });

  Future<BankTransaction> payCable({
    required String reference,
    required CablePackage package,
    required String smartcardNumber,
    required BillCustomer customer,
  });
}

class MockBillsRepository implements BillsRepository {
  MockBillsRepository(
    this._ledger,
    this._network, {
    this._liveLookup,
    Random? random,
  }) : _random = random ?? Random.secure();

  /// Real meter and smartcard checks when VTpass keys are configured.
  final VtpassBillerLookup? _liveLookup;

  final MockLedger _ledger;
  final MockNetwork _network;
  final Random _random;

  static const _streets = [
    '14 Adeniyi Jones Avenue, Ikeja',
    '3 Admiralty Way, Lekki Phase 1',
    '22 Bode Thomas Street, Surulere',
    '7 Aminu Kano Crescent, Wuse 2',
    '41 Ring Road, Ibadan',
    '9 Aba Road, Port Harcourt',
  ];

  @override
  Future<BankTransaction> buyAirtime({
    required String reference,
    required MobileNetwork network,
    required PhoneNumber phone,
    required Money amount,
  }) async {
    if (amount < Money.naira(50) || amount > Money.naira(50000)) {
      throw const ValidationException(
        'Airtime must be between ₦50 and ₦50,000.',
      );
    }
    return _ledger.pay(
      LedgerDebit(
        reference: reference,
        category: TxnCategory.airtime,
        amount: amount,
        counterpartyName: '${network.label} Airtime',
        counterpartyAccount: '0${phone.national}',
      ),
    );
  }

  @override
  Future<BankTransaction> buyData({
    required String reference,
    required DataPlan plan,
    required PhoneNumber phone,
  }) => _ledger.pay(
    LedgerDebit(
      reference: reference,
      category: TxnCategory.data,
      amount: plan.price,
      narration: plan.label,
      counterpartyName: '${plan.network.label} Data',
      counterpartyAccount: '0${phone.national}',
    ),
  );

  @override
  Future<BillCustomer> validateMeter({
    required Disco disco,
    required MeterType type,
    required String meterNumber,
  }) async {
    if (!RegExp(r'^\d{11,13}$').hasMatch(meterNumber)) {
      throw const ValidationException('Meter numbers are 11 to 13 digits.');
    }
    final live = _liveLookup;
    if (live != null) {
      return live.verifyMeter(
        disco: disco,
        type: type,
        meterNumber: meterNumber,
      );
    }
    await _network.roundTrip();
    return _lookup('${disco.code}$meterNumber', withAddress: true);
  }

  @override
  Future<BankTransaction> payElectricity({
    required String reference,
    required Disco disco,
    required MeterType type,
    required String meterNumber,
    required BillCustomer customer,
    required Money amount,
  }) async {
    if (amount < Money.naira(1000)) {
      throw const ValidationException('The minimum is ₦1,000.');
    }
    final units = amount.kobo / Disco.tariffPerKwh.kobo;
    return _ledger.pay(
      LedgerDebit(
        reference: reference,
        category: TxnCategory.electricity,
        amount: amount,
        narration: type == MeterType.prepaid
            ? '${_token()} · ${units.toStringAsFixed(1)} kWh'
            : 'Postpaid bill payment',
        counterpartyName: '${disco.name} (${_typeLabel(type)})',
        counterpartyAccount: meterNumber,
        counterpartyBank: customer.name,
      ),
    );
  }

  @override
  Future<BillCustomer> validateSmartcard({
    required CableProvider provider,
    required String smartcardNumber,
  }) async {
    if (!RegExp(r'^\d{10,11}$').hasMatch(smartcardNumber)) {
      throw const ValidationException(
        'Smartcard and IUC numbers are 10 or 11 digits.',
      );
    }
    final live = _liveLookup;
    if (live != null) {
      return live.verifySmartcard(
        provider: provider,
        smartcardNumber: smartcardNumber,
      );
    }
    await _network.roundTrip();
    return _lookup('${provider.name}$smartcardNumber', withAddress: false);
  }

  @override
  Future<BankTransaction> payCable({
    required String reference,
    required CablePackage package,
    required String smartcardNumber,
    required BillCustomer customer,
  }) => _ledger.pay(
    LedgerDebit(
      reference: reference,
      category: TxnCategory.cable,
      amount: package.price,
      narration: '${package.name} · 1 month',
      counterpartyName: '${package.provider.label} ${package.name}',
      counterpartyAccount: smartcardNumber,
      counterpartyBank: customer.name,
    ),
  );

  /// Same number, same customer, every time; about 1 in 13 doesn't exist.
  BillCustomer _lookup(String key, {required bool withAddress}) {
    final name = mockAccountName(billerDirectory, key);
    final address = withAddress
        ? _streets[key.codeUnits.fold(0, (a, b) => a + b) % _streets.length]
        : null;
    return BillCustomer(name: name, address: address);
  }

  /// 20 digits in groups of four, like a real STS token.
  String _token() => List.generate(
    5,
    (_) => List.generate(4, (_) => _random.nextInt(10)).join(),
  ).join('-');

  static String _typeLabel(MeterType type) =>
      type == MeterType.prepaid ? 'Prepaid' : 'Postpaid';
}

final billsRepositoryProvider = Provider<BillsRepository>(
  (ref) => MockBillsRepository(
    ref.watch(mockLedgerProvider),
    ref.watch(mockNetworkProvider),
    liveLookup: ref.watch(vtpassBillerLookupProvider),
  ),
);
