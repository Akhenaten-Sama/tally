import 'package:flutter_test/flutter_test.dart';
import 'package:tally/core/money/money.dart';
import 'package:tally/features/transfers/domain/amount_input.dart';

AmountInput type(String keys) =>
    keys.split('').fold(const AmountInput(), (input, k) => input.press(k));

void main() {
  test('builds naira amounts with grouping', () {
    final input = type('125000');
    expect(input.display, '₦125,000');
    expect(input.money, const Money(12500000));
  });

  test('keeps a trailing decimal point and partial kobo as typed', () {
    expect(type('10.').display, '₦10.');
    expect(type('10.5').display, '₦10.5');
    expect(type('10.5').money, const Money(1050));
  });

  test('allows at most two decimal places and one point', () {
    expect(type('1.234').raw, '1.23');
    expect(type('1..2').raw, '1.2');
  });

  test('a leading point becomes 0.', () {
    expect(type('.5').raw, '0.5');
  });

  test('does not allow leading zeros', () {
    expect(type('007').raw, '7');
  });

  test('caps the naira part at nine digits', () {
    expect(type('12345678901').raw, '123456789');
  });

  test('backspace removes the last key', () {
    expect(type('12.5').backspace().backspace().raw, '12');
    expect(const AmountInput().backspace().raw, '');
  });
}
