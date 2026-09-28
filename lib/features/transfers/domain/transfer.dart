import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/money/money.dart';
import 'bank.dart';

part 'transfer.freezed.dart';

@freezed
abstract class TransferRequest with _$TransferRequest {
  const factory TransferRequest({
    /// Idempotency key, generated once when the user reaches the PIN step.
    /// Retrying with the same reference never sends money twice.
    required String reference,
    required Bank bank,
    required String accountNumber,
    required String accountName,
    required Money amount,
    @Default('') String narration,
  }) = _TransferRequest;
}

@freezed
abstract class Beneficiary with _$Beneficiary {
  const factory Beneficiary({
    required String name,
    required String accountNumber,
    required Bank bank,
    required DateTime lastUsedAt,
  }) = _Beneficiary;
}

/// NIP charges (VAT inclusive) that most Nigerian banks pass on.
Money transferFee(Money amount, {required Bank bank}) {
  if (bank.isInternal) return const Money.zero();
  if (amount <= const Money(500000)) return const Money(1075);
  if (amount <= const Money(5000000)) return const Money(2688);
  return const Money(5375);
}
