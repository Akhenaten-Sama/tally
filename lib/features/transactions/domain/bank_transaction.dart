import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/money/money.dart';

part 'bank_transaction.freezed.dart';

enum TxnDirection { credit, debit }

enum TxnCategory {
  transfer,
  airtime,
  data,
  electricity,
  cable,
  savings,
  interest,
  reversal,
  mortgage,
}

/// `failed` means money never left the account. `reversed` means it was
/// debited, the provider failed, and a separate reversal credit refunded it.
enum TxnStatus { pending, successful, failed, reversed }

@freezed
abstract class BankTransaction with _$BankTransaction {
  const BankTransaction._();

  const factory BankTransaction({
    required String id,
    required String reference,
    required TxnDirection direction,
    required TxnCategory category,
    required TxnStatus status,
    required Money amount,
    @Default(Money.zero()) Money fee,
    @Default('') String narration,
    required String counterpartyName,
    String? counterpartyAccount,
    String? counterpartyBank,
    required DateTime createdAt,
  }) = _BankTransaction;

  bool get isCredit => direction == TxnDirection.credit;

  /// What actually left (or entered) the account.
  Money get total => amount + fee;

  /// The 20-digit STS token from a prepaid electricity purchase, if any.
  String? get electricityToken => category == TxnCategory.electricity
      ? RegExp(r'^\d{4}(-\d{4}){4}').firstMatch(narration)?.group(0)
      : null;
}
