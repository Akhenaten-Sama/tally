import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// A Naira amount stored as integer kobo.
///
/// Money is never represented as a double anywhere in the app: floating
/// point cannot represent most decimal fractions exactly, so sums drift.
@immutable
class Money implements Comparable<Money> {
  const Money(this.kobo);
  const Money.zero() : kobo = 0;

  /// Converts a user-entered Naira value. Only use at input boundaries.
  factory Money.naira(num naira) => Money((naira * 100).round());

  final int kobo;

  static final _grouped = NumberFormat('#,##0', 'en_US');

  bool get isZero => kobo == 0;
  bool get isNegative => kobo < 0;
  Money get abs => Money(kobo.abs());

  Money operator +(Money other) => Money(kobo + other.kobo);
  Money operator -(Money other) => Money(kobo - other.kobo);
  bool operator <(Money other) => kobo < other.kobo;
  bool operator <=(Money other) => kobo <= other.kobo;
  bool operator >(Money other) => kobo > other.kobo;
  bool operator >=(Money other) => kobo >= other.kobo;

  /// `₦1,234.50`. Formatted from integers so large balances never round.
  String format({bool showKobo = true}) {
    final sign = kobo < 0 ? '-' : '';
    final naira = _grouped.format(kobo.abs() ~/ 100);
    if (!showKobo) return '$sign₦$naira';
    final k = (kobo.abs() % 100).toString().padLeft(2, '0');
    return '$sign₦$naira.$k';
  }

  @override
  int compareTo(Money other) => kobo.compareTo(other.kobo);

  @override
  bool operator ==(Object other) => other is Money && other.kobo == kobo;

  @override
  int get hashCode => kobo.hashCode;

  @override
  String toString() => format();
}
