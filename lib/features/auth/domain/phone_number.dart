import 'package:flutter/foundation.dart';

/// A Nigerian mobile number (070x, 080x, 081x, 090x, 091x).
@immutable
class PhoneNumber {
  const PhoneNumber._(this.national);

  /// Accepts "08031234567", "8031234567", "+2348031234567", with or
  /// without spaces. Returns null if it isn't a Nigerian mobile number.
  static PhoneNumber? tryParse(String input) {
    var digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('234')) digits = digits.substring(3);
    if (digits.startsWith('0')) digits = digits.substring(1);
    if (!RegExp(r'^[789][01]\d{8}$').hasMatch(digits)) return null;
    return PhoneNumber._(digits);
  }

  /// The 10 digits after the country code.
  final String national;

  String get e164 => '+234$national';

  /// "0803 123 4567".
  String get display =>
      '0${national.substring(0, 3)} ${national.substring(3, 6)} '
      '${national.substring(6)}';

  @override
  bool operator ==(Object other) =>
      other is PhoneNumber && other.national == national;

  @override
  int get hashCode => national.hashCode;
}
