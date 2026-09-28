import 'package:flutter/material.dart';

import '../../../core/money/money.dart';
import '../../auth/domain/phone_number.dart';

/// Nigerian mobile networks. Prices and plans are indicative.
enum MobileNetwork {
  mtn('MTN', Color(0xFFFFCC00), Color(0xFF1A1A1A), [
    '803', '806', '703', '706', '813', '816', '810', '814', '903', '906', //
    '913', '916', '704',
  ]),
  airtel('Airtel', Color(0xFFE40000), Colors.white, [
    '802',
    '808',
    '708',
    '812',
    '701',
    '902',
    '901',
    '907',
    '912',
  ]),
  glo('Glo', Color(0xFF50B848), Colors.white, [
    '805',
    '807',
    '705',
    '815',
    '811',
    '905',
    '915',
  ]),
  nineMobile('9mobile', Color(0xFF006E53), Colors.white, [
    '809',
    '818',
    '817',
    '909',
    '908',
  ]);

  const MobileNetwork(this.label, this.color, this.onColor, this.prefixes);

  final String label;
  final Color color;
  final Color onColor;

  /// First three digits after the leading 0.
  final List<String> prefixes;

  /// Official logo as a round badge; null draws a text badge instead.
  String? get logoAsset => switch (this) {
    mtn => 'assets/networks/mtn.png',
    airtel => 'assets/networks/airtel.png',
    glo => 'assets/networks/glo.png',
    nineMobile => 'assets/networks/9mobile.png',
  };

  /// Best guess from the number's prefix. Numbers can be ported between
  /// networks, so the user can still change it.
  static MobileNetwork? detect(PhoneNumber phone) {
    final prefix = phone.national.substring(0, 3);
    for (final network in values) {
      if (network.prefixes.contains(prefix)) return network;
    }
    return null;
  }

  List<DataPlan> get dataPlans => [
    for (final (size, days, naira) in _plans)
      DataPlan(
        network: this,
        size: size,
        validityDays: days,
        // Small differences between networks keep the lists believable.
        price: Money.naira((naira * _priceFactor).round() ~/ 50 * 50),
      ),
  ];

  double get _priceFactor => switch (this) {
    mtn => 1.0,
    airtel => 1.0,
    glo => 0.9,
    nineMobile => 0.95,
  };

  static const _plans = [
    ('500MB', 7, 500),
    ('1.5GB', 30, 1500),
    ('3.5GB', 30, 3000),
    ('10GB', 30, 6500),
    ('25GB', 30, 13000),
    ('75GB', 30, 30000),
  ];
}

@immutable
class DataPlan {
  const DataPlan({
    required this.network,
    required this.size,
    required this.validityDays,
    required this.price,
  });

  final MobileNetwork network;
  final String size;
  final int validityDays;
  final Money price;

  String get label =>
      '$size · ${validityDays == 1 ? '1 day' : '$validityDays days'}';

  @override
  bool operator ==(Object other) =>
      other is DataPlan && other.network == network && other.size == size;

  @override
  int get hashCode => Object.hash(network, size);
}

/// Electricity distribution companies.
enum Disco {
  ikeja('Ikeja Electric', 'IKEDC', 'ikeja-electric'),
  eko('Eko Electricity', 'EKEDC', 'eko-electric'),
  abuja('Abuja Electricity', 'AEDC', 'abuja-electric'),
  ibadan('Ibadan Electricity', 'IBEDC', 'ibadan-electric'),
  portHarcourt('Port Harcourt Electricity', 'PHED', 'portharcourt-electric'),
  enugu('Enugu Electricity', 'EEDC', 'enugu-electric'),
  kano('Kano Electricity', 'KEDCO', 'kano-electric'),
  benin('Benin Electricity', 'BEDC', 'benin-electric');

  const Disco(this.name, this.code, this.vtpassServiceId);

  final String name;
  final String code;

  /// VTpass `serviceID` for live meter verification.
  final String vtpassServiceId;

  /// Band A tariff per kWh, used to show units bought.
  static const tariffPerKwh = Money(20950);
}

enum MeterType { prepaid, postpaid }

enum CableProvider {
  dstv('DStv', Color(0xFF0033A1), [
    ('Padi', 440000),
    ('Yanga', 600000),
    ('Confam', 1100000),
    ('Compact', 1900000),
    ('Compact Plus', 3000000),
    ('Premium', 4450000),
  ]),
  gotv('GOtv', Color(0xFF00A94F), [
    ('Smallie', 190000),
    ('Jinja', 390000),
    ('Jolli', 580000),
    ('Max', 850000),
    ('Supa', 1140000),
  ]),
  startimes('StarTimes', Color(0xFFF58220), [
    ('Nova', 190000),
    ('Basic', 370000),
    ('Classic', 550000),
    ('Super', 900000),
  ]);

  const CableProvider(this.label, this.color, this._packages);

  final String label;
  final Color color;
  final List<(String, int)> _packages;

  /// VTpass `serviceID` for live smartcard verification.
  String get vtpassServiceId => name;

  List<CablePackage> get packages => [
    for (final (name, kobo) in _packages)
      CablePackage(provider: this, name: name, price: Money(kobo)),
  ];
}

@immutable
class CablePackage {
  const CablePackage({
    required this.provider,
    required this.name,
    required this.price,
  });

  final CableProvider provider;
  final String name;
  final Money price;

  @override
  bool operator ==(Object other) =>
      other is CablePackage && other.provider == provider && other.name == name;

  @override
  int get hashCode => Object.hash(provider, name);
}

/// Who a meter or smartcard belongs to, from the biller's lookup.
@immutable
class BillCustomer {
  const BillCustomer({required this.name, this.address});

  final String name;
  final String? address;
}
