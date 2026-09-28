import 'package:flutter_test/flutter_test.dart';
import 'package:kora/core/money/money.dart';
import 'package:kora/features/mortgage/domain/amortization.dart';

void main() {
  const principal = Money(1500000000); // ₦15,000,000

  test('matches the standard annuity formula', () {
    // ₦15m at 6% over 20 years = ₦107,464.66 a month (₦716.43 per ₦100k).
    final monthly = monthlyRepayment(
      principal: principal,
      annualRateBps: 600,
      months: 240,
    );
    expect(monthly.kobo, closeTo(10746466, 1));
  });

  test('schedule pays the loan off to exactly zero kobo', () {
    final schedule = amortize(
      principal: principal,
      annualRateBps: 600,
      months: 240,
      firstDueDate: DateTime(2024, 10, 25),
    );
    expect(schedule, hasLength(240));
    expect(schedule.last.balanceAfter, const Money.zero());
    final repaid = schedule.fold(0, (sum, i) => sum + i.principal.kobo);
    expect(repaid, principal.kobo);
  });

  test('each payment is principal plus interest, in whole kobo', () {
    final schedule = amortize(
      principal: principal,
      annualRateBps: 1950,
      months: 120,
      firstDueDate: DateTime(2026, 1, 31),
    );
    for (final i in schedule) {
      expect(i.payment, i.principal + i.interest);
    }
    // Interest falls and principal rises as the balance shrinks.
    expect(schedule.first.interest > schedule.last.interest, isTrue);
    expect(schedule.first.principal < schedule[100].principal, isTrue);
  });

  test('zero-interest loans divide evenly', () {
    final schedule = amortize(
      principal: const Money(1200),
      annualRateBps: 0,
      months: 12,
      firstDueDate: DateTime(2026),
    );
    expect(schedule.every((i) => i.payment == const Money(100)), isTrue);
  });

  test('addMonths clamps to the end of shorter months', () {
    expect(addMonths(DateTime(2026, 1, 31), 1), DateTime(2026, 2, 28));
    expect(addMonths(DateTime(2026, 12, 25), 2), DateTime(2027, 2, 25));
    expect(addMonths(DateTime(2026, 3, 25), -24), DateTime(2024, 3, 25));
  });
}
