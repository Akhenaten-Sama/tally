import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../../core/money/money.dart';

/// Keypad-driven amount entry.
///
/// Keeps the raw keystrokes so "10." and "10.5" display exactly as typed,
/// and only converts to [Money] (integer kobo) when asked.
@immutable
class AmountInput {
  const AmountInput([this.raw = '']);

  final String raw;

  /// Up to ₦999,999,999.
  static const maxNairaDigits = 9;

  static final _grouped = NumberFormat('#,##0', 'en_US');

  AmountInput press(String key) {
    if (key == '.') {
      if (raw.contains('.')) return this;
      return AmountInput(raw.isEmpty ? '0.' : '$raw.');
    }
    if (raw.contains('.')) {
      if (raw.split('.')[1].length >= 2) return this;
      return AmountInput('$raw$key');
    }
    if (raw == '0') return AmountInput(key);
    if (raw.length >= maxNairaDigits) return this;
    return AmountInput('$raw$key');
  }

  AmountInput backspace() =>
      raw.isEmpty ? this : AmountInput(raw.substring(0, raw.length - 1));

  Money get money {
    if (raw.isEmpty) return const Money.zero();
    final parts = raw.split('.');
    final naira = int.parse(parts[0].isEmpty ? '0' : parts[0]);
    final kobo = parts.length > 1 && parts[1].isNotEmpty
        ? int.parse(parts[1].padRight(2, '0'))
        : 0;
    return Money(naira * 100 + kobo);
  }

  /// "₦12,500.5" while typing, keeping a trailing "." or partial kobo.
  String get display {
    if (raw.isEmpty) return '₦0';
    final parts = raw.split('.');
    final naira = _grouped.format(int.parse(parts[0]));
    return raw.contains('.') ? '₦$naira.${parts[1]}' : '₦$naira';
  }

  @override
  bool operator ==(Object other) => other is AmountInput && other.raw == raw;

  @override
  int get hashCode => raw.hashCode;
}
