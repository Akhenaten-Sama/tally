import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/money/money.dart';

part 'account.freezed.dart';

/// CBN tiered KYC. Limits are enforced when money leaves the account.
enum KycTier {
  tier1(1, 'Tier 1', 'Phone number', Money(5000000)),
  tier2(2, 'Tier 2', 'BVN', Money(20000000)),
  tier3(3, 'Tier 3', 'NIN and address', Money(500000000));

  const KycTier(this.level, this.label, this.requirement, this.dailyLimit);

  final int level;
  final String label;
  final String requirement;
  final Money dailyLimit;

  static KycTier fromLevel(int level) =>
      values.firstWhere((t) => t.level == level, orElse: () => tier1);
}

@freezed
abstract class Account with _$Account {
  const Account._();

  const factory Account({
    required String id,
    required String holderName,
    required String accountNumber,
    required Money balance,
    required KycTier tier,
  }) = _Account;

  String get firstName => holderName.split(' ').first;
}
