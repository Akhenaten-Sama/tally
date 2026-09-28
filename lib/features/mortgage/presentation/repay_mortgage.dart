import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../app/routes.dart';
import '../../auth/data/transaction_pin_repository.dart';
import '../../transfers/presentation/widgets/pin_sheet.dart';
import '../data/mortgage_repository.dart';
import '../domain/mortgage.dart';
import 'widgets/repayment_sheet.dart';

/// Review → PIN or Face ID → result screen. One reference per attempt, so a
/// retry after a network error inside the PIN sheet can't pay twice.
Future<void> repayMortgage(
  BuildContext context,
  WidgetRef ref,
  Mortgage mortgage,
) async {
  final confirmed = await showRepaymentSheet(context, mortgage);
  if (confirmed != true || !context.mounted) return;

  final reference =
      'CMB-MTG-${const Uuid().v4().replaceAll('-', '').substring(0, 12).toUpperCase()}';
  final repository = ref.read(mortgageRepositoryProvider);
  final pins = ref.read(transactionPinRepositoryProvider);

  final transaction = await showPinSheet(
    context,
    onPin: (pin) async {
      await pins.verify(pin);
      return repository.repayNextInstallment(
        mortgageId: mortgage.id,
        reference: reference,
      );
    },
    onBiometrics: () => repository.repayNextInstallment(
      mortgageId: mortgage.id,
      reference: reference,
    ),
  );
  if (transaction == null || !context.mounted) return;
  context.go(Routes.transferStatus(transaction.id));
}
