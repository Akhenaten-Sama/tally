import 'package:flutter_test/flutter_test.dart';
import 'package:kora/features/auth/domain/phone_number.dart';

void main() {
  test('accepts the common ways Nigerians write their number', () {
    for (final input in [
      '08031234567',
      '0803 123 4567',
      '8031234567',
      '+2348031234567',
      '234 803 123 4567',
    ]) {
      expect(
        PhoneNumber.tryParse(input)?.e164,
        '+2348031234567',
        reason: input,
      );
    }
  });

  test('accepts every mobile prefix family', () {
    for (final prefix in ['070', '080', '081', '090', '091']) {
      expect(PhoneNumber.tryParse('${prefix}12345678'), isNotNull);
    }
  });

  test('rejects landlines, short numbers and other countries', () {
    for (final input in ['0123456789', '0803123456', '+447911123456', '']) {
      expect(PhoneNumber.tryParse(input), isNull, reason: input);
    }
  });

  test('formats for display', () {
    expect(PhoneNumber.tryParse('08031234567')!.display, '0803 123 4567');
  });
}
