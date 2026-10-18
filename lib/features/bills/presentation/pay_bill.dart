import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/money/money.dart';
import '../../../core/widgets/confirm_sheet.dart';
import '../../auth/data/transaction_pin_repository.dart';
import '../../transactions/domain/bank_transaction.dart';
import '../../transfers/presentation/widgets/pin_sheet.dart';
import '../../../core/utils/references.dart';

/// Confirm → PIN or Face ID → result screen, shared by every bill type.
/// [pay] receives one reference per attempt, so retrying inside the PIN
/// sheet after a network error can't charge twice.
Future<void> payBill(
  BuildContext context,
  WidgetRef ref, {
  required String title,
  required Money amount,
  required List<(String, String)> rows,
  required Future<BankTransaction> Function(String reference) pay,
}) async {
  final confirmed = await showConfirmSheet(
    context,
    title: title,
    amount: amount,
    rows: rows,
  );
  if (confirmed != true || !context.mounted) return;

  final reference = newReference();
  final pins = ref.read(transactionPinRepositoryProvider);

  final transaction = await showPinSheet(
    context,
    onPin: (pin) async {
      await pins.verify(pin);
      return pay(reference);
    },
    onBiometrics: () => pay(reference),
  );
  if (transaction == null || !context.mounted) return;
  context.go(Routes.transferStatus(transaction.id));
}
