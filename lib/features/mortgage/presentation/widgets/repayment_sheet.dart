import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/kora_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../account/data/account_repository.dart';
import '../../domain/mortgage.dart';

/// Review before paying the next installment. Returns true to proceed.
Future<bool?> showRepaymentSheet(BuildContext context, Mortgage mortgage) =>
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => _RepaymentSheet(mortgage: mortgage),
    );

class _RepaymentSheet extends ConsumerWidget {
  const _RepaymentSheet({required this.mortgage});

  final Mortgage mortgage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final installment = mortgage.nextInstallment!;
    final balance = ref.watch(primaryAccountProvider).value?.balance;
    final canPay = balance != null && balance >= installment.payment;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Mortgage repayment',
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            installment.payment.format(),
            textAlign: TextAlign.center,
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontFeatures: amountFeatures,
            ),
          ),
          const SizedBox(height: 20),
          _Row('Payment', '${installment.number} of ${mortgage.tenorMonths}'),
          _Row('Due', formatDayLabel(installment.dueDate)),
          _Row('Towards principal', installment.principal.format()),
          _Row('Interest', installment.interest.format()),
          _Row(
            'Balance after',
            installment.balanceAfter.format(),
            emphasize: true,
          ),
          if (balance != null)
            _Row('Paid from', 'Current account · ${balance.format()}'),
          const SizedBox(height: 16),
          if (!canPay)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'Your current account balance is too low for this payment.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.error),
              ),
            ),
          FilledButton(
            onPressed: canPay ? () => Navigator.pop(context, true) : null,
            child: Text('Pay ${installment.payment.format()}'),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value, {this.emphasize = false});

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Text(label, style: TextStyle(color: context.kora.muted)),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
              fontFeatures: amountFeatures,
            ),
          ),
        ),
      ],
    ),
  );
}
