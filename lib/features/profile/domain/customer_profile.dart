import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_profile.freezed.dart';

/// What the bank knows about the customer beyond the account itself.
/// Identity numbers are only ever kept as their last four digits.
@freezed
abstract class CustomerProfile with _$CustomerProfile {
  const CustomerProfile._();

  const factory CustomerProfile({
    required String phone,
    String? email,
    DateTime? dateOfBirth,
    String? address,
    String? bvnLast4,
    String? ninLast4,
    required DateTime memberSince,
  }) = _CustomerProfile;

  static String mask(String? last4) =>
      last4 == null ? 'Not added' : '•••••••$last4';
}
