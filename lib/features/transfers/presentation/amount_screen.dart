import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kora_colors.dart';
import '../../../core/widgets/number_pad.dart';
import '../../account/data/account_repository.dart';
import 'send_money_controller.dart';
import 'widgets/pin_sheet.dart';
import 'widgets/recipient_header.dart';
import 'widgets/review_sheet.dart';
import '../../../core/brand/brand.dart';

/// Step 2: how much? Then review, then PIN.
class AmountScreen extends ConsumerWidget {
  const AmountScreen({super.key});

  Future<void> _confirm(BuildContext context, WidgetRef ref) async {
    final confirmed = await showReviewSheet(context);
    if (confirmed != true || !context.mounted) return;

    final controller = ref.read(sendMoneyProvider.notifier);
    final transaction = await showPinSheet(
      context,
      onPin: controller.submitWithPin,
      onBiometrics: controller.submitWithBiometrics,
    );
    if (transaction == null || !context.mounted) return;
    context.go(Routes.transferStatus(transaction.id));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(sendMoneyProvider);
    final controller = ref.read(sendMoneyProvider.notifier);
    final balance = ref.watch(primaryAccountProvider).value?.balance;
    final kora = context.kora;

    final amount = draft.amount.money;
    final overBalance = balance != null && draft.total > balance;
    final canContinue = !amount.isZero && !overBalance && balance != null;

    final String helper;
    final Color helperColor;
    if (overBalance) {
      helper = 'Insufficient balance';
      helperColor = AppColors.error;
    } else if (amount.isZero) {
      helper = balance == null ? '' : 'Balance: ${balance.format()}';
      helperColor = kora.muted;
    } else {
      helper = draft.fee.isZero
          ? 'No fee to ${Brand.current.shortName} accounts'
          : 'Fee: ${draft.fee.format()}';
      helperColor = kora.muted;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Amount')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              RecipientHeader(
                name: draft.accountName ?? '',
                bankName: draft.bank?.name ?? '',
                accountNumber: draft.accountNumber,
              ),
              const Spacer(),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Semantics(
                  liveRegion: true,
                  child: Text(
                    draft.amount.display,
                    style: context.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontFeatures: amountFeatures,
                      color: amount.isZero ? kora.muted : kora.debit,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(helper, style: TextStyle(color: helperColor)),
              const Spacer(),
              NumberPad(
                onDigit: controller.pressKey,
                onDecimal: () => controller.pressKey('.'),
                onBackspace: controller.backspace,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: canContinue ? () => _confirm(context, ref) : null,
                child: const Text('Continue'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
