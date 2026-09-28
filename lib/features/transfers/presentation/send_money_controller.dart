import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/money/money.dart';
import '../../auth/data/transaction_pin_repository.dart';
import '../../transactions/domain/bank_transaction.dart';
import '../data/transfer_repository.dart';
import '../domain/amount_input.dart';
import '../domain/bank.dart';
import '../domain/transfer.dart';

part 'send_money_controller.freezed.dart';

@freezed
abstract class SendMoneyDraft with _$SendMoneyDraft {
  const SendMoneyDraft._();

  const factory SendMoneyDraft({
    Bank? bank,
    @Default('') String accountNumber,

    /// Set once name enquiry succeeds, or straight from a beneficiary.
    String? accountName,
    @Default(AmountInput()) AmountInput amount,
    @Default('') String narration,

    /// Idempotency key. Created on the first send attempt and kept for
    /// retries; cleared whenever the recipient or amount changes.
    String? reference,
  }) = _SendMoneyDraft;

  bool get hasAccountNumber => accountNumber.length == 10;

  Money get fee => bank == null
      ? const Money.zero()
      : transferFee(amount.money, bank: bank!);

  Money get total => amount.money + fee;
}

class SendMoneyController extends Notifier<SendMoneyDraft> {
  @override
  SendMoneyDraft build() => const SendMoneyDraft();

  void selectBank(Bank bank) =>
      state = state.copyWith(bank: bank, accountName: null, reference: null);

  void setAccountNumber(String accountNumber) => state = state.copyWith(
    accountNumber: accountNumber,
    accountName: null,
    reference: null,
  );

  void setAccountName(String name) => state = state.copyWith(accountName: name);

  void useBeneficiary(Beneficiary beneficiary) => state = SendMoneyDraft(
    bank: beneficiary.bank,
    accountNumber: beneficiary.accountNumber,
    accountName: beneficiary.name,
  );

  void pressKey(String key) => _setAmount(state.amount.press(key));

  void backspace() => _setAmount(state.amount.backspace());

  void setNarration(String narration) =>
      state = state.copyWith(narration: narration.trim());

  /// Verifies the PIN, then sends. Safe to call again after a failure:
  /// the same reference is reused, so money can never leave twice.
  Future<BankTransaction> submitWithPin(String pin) async {
    await ref.read(transactionPinRepositoryProvider).verify(pin);
    return _send();
  }

  /// Call only after the system biometric prompt succeeded.
  Future<BankTransaction> submitWithBiometrics() => _send();

  Future<BankTransaction> _send() {
    final reference = state.reference ?? _newReference();
    state = state.copyWith(reference: reference);

    return ref
        .read(transferRepositoryProvider)
        .send(
          TransferRequest(
            reference: reference,
            bank: state.bank!,
            accountNumber: state.accountNumber,
            accountName: state.accountName!,
            amount: state.amount.money,
            narration: state.narration,
          ),
        );
  }

  void _setAmount(AmountInput amount) {
    if (amount == state.amount) return;
    state = state.copyWith(amount: amount, reference: null);
  }

  static String _newReference() =>
      'KORA${const Uuid().v4().replaceAll('-', '').substring(0, 16).toUpperCase()}';
}

/// Lives only while the send flow is on screen; the next flow starts fresh.
final sendMoneyProvider =
    NotifierProvider.autoDispose<SendMoneyController, SendMoneyDraft>(
      SendMoneyController.new,
    );

final accountNameLookupProvider = FutureProvider.autoDispose
    .family<String, (Bank, String)>(
      (ref, key) => ref
          .watch(transferRepositoryProvider)
          .resolveAccountName(bank: key.$1, accountNumber: key.$2),
    );
