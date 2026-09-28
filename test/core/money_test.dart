import 'package:flutter_test/flutter_test.dart';
import 'package:tally/core/money/money.dart';

void main() {
  group('Money', () {
    test('formats kobo with grouping and two decimals', () {
      expect(const Money(24835075).format(), '₦248,350.75');
      expect(const Money(5).format(), '₦0.05');
      expect(const Money(-1075).format(), '-₦10.75');
    });

    test('can drop kobo for whole-naira labels', () {
      expect(const Money(20000000).format(showKobo: false), '₦200,000');
    });

    test('converts naira input without floating point drift', () {
      expect(Money.naira(0.1) + Money.naira(0.2), Money.naira(0.3));
      expect(Money.naira(19.99).kobo, 1999);
    });

    test('formats very large balances exactly', () {
      expect(const Money(900719925474099).format(), '₦9,007,199,254,740.99');
    });
  });
}
