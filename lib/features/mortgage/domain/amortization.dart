import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../../core/money/money.dart';

@immutable
class Installment {
  const Installment({
    required this.number,
    required this.dueDate,
    required this.payment,
    required this.principal,
    required this.interest,
    required this.balanceAfter,
  });

  /// 1-based.
  final int number;
  final DateTime dueDate;
  final Money payment;
  final Money principal;
  final Money interest;
  final Money balanceAfter;
}

/// Fixed monthly repayment for an annuity mortgage, in whole kobo.
///
/// The rate formula needs floating point; the result is rounded to kobo
/// once, and the schedule below carries balances as integers from there.
Money monthlyRepayment({
  required Money principal,
  required int annualRateBps,
  required int months,
}) {
  if (months <= 0) return principal;
  final r = annualRateBps / 10000 / 12;
  if (r == 0) return Money((principal.kobo / months).ceil());
  final payment = principal.kobo * r / (1 - pow(1 + r, -months));
  return Money(payment.round());
}

/// The full repayment schedule. The last payment absorbs rounding so the
/// balance ends at exactly zero.
List<Installment> amortize({
  required Money principal,
  required int annualRateBps,
  required int months,
  required DateTime firstDueDate,
}) {
  final r = annualRateBps / 10000 / 12;
  final payment = monthlyRepayment(
    principal: principal,
    annualRateBps: annualRateBps,
    months: months,
  ).kobo;

  var balance = principal.kobo;
  return [
    for (var i = 1; i <= months; i++)
      () {
        final interest = (balance * r).round();
        var principalPart = payment - interest;
        if (i == months || principalPart > balance) principalPart = balance;
        balance -= principalPart;
        return Installment(
          number: i,
          dueDate: addMonths(firstDueDate, i - 1),
          payment: Money(principalPart + interest),
          principal: Money(principalPart),
          interest: Money(interest),
          balanceAfter: Money(balance),
        );
      }(),
  ];
}

/// Same day of month [months] later, clamped for short months.
DateTime addMonths(DateTime date, int months) {
  final firstOfTarget = DateTime(date.year, date.month + months);
  final lastDay = DateTime(firstOfTarget.year, firstOfTarget.month + 1, 0).day;
  return DateTime(
    firstOfTarget.year,
    firstOfTarget.month,
    min(date.day, lastDay),
  );
}
