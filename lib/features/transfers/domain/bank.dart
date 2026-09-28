import 'package:flutter/foundation.dart';

import '../../../core/brand/brand.dart';

@immutable
class Bank {
  const Bank({required this.code, required this.name, this.isInternal = false});

  /// NIP institution code.
  final String code;
  final String name;

  /// Our own bank: transfers between its accounts are internal and free.
  final bool isInternal;

  static final internal = Bank(
    code: '090999',
    name: Brand.current.shortName,
    isInternal: true,
  );

  static final all = [
    internal,
    const Bank(code: '044', name: 'Access Bank'),
    const Bank(code: '023', name: 'Citibank Nigeria'),
    const Bank(code: '050', name: 'Ecobank Nigeria'),
    const Bank(code: '070', name: 'Fidelity Bank'),
    const Bank(code: '011', name: 'First Bank of Nigeria'),
    const Bank(code: '214', name: 'First City Monument Bank'),
    const Bank(code: '058', name: 'Guaranty Trust Bank'),
    const Bank(code: '50211', name: 'Kuda Microfinance Bank'),
    const Bank(code: '50515', name: 'Moniepoint Microfinance Bank'),
    const Bank(code: '999992', name: 'OPay'),
    const Bank(code: '999991', name: 'PalmPay'),
    const Bank(code: '221', name: 'Stanbic IBTC Bank'),
    const Bank(code: '232', name: 'Sterling Bank'),
    const Bank(code: '032', name: 'Union Bank of Nigeria'),
    const Bank(code: '033', name: 'United Bank for Africa'),
    const Bank(code: '035', name: 'Wema Bank'),
    const Bank(code: '057', name: 'Zenith Bank'),
  ];

  static Bank byCode(String code) =>
      all.firstWhere((b) => b.code == code, orElse: () => internal);

  @override
  bool operator ==(Object other) => other is Bank && other.code == code;

  @override
  int get hashCode => code.hashCode;
}
