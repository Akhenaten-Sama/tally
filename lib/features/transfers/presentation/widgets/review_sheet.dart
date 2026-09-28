import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/kora_colors.dart';
import '../send_money_controller.dart';

/// Returns true when the user confirms.
Future<bool?> showReviewSheet(BuildContext context) =>
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => const _ReviewSheet(),
    );

class _ReviewSheet extends ConsumerWidget {
  const _ReviewSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(sendMoneyProvider);

    return Padding(
      // Keep the note field above the keyboard.
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Confirm transfer',
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            draft.amount.money.format(),
            textAlign: TextAlign.center,
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontFeatures: amountFeatures,
            ),
          ),
          const SizedBox(height: 20),
          _Row('To', draft.accountName ?? ''),
          _Row('Bank', draft.bank?.name ?? ''),
          _Row('Account number', draft.accountNumber),
          _Row('Fee', draft.fee.isZero ? 'Free' : draft.fee.format()),
          _Row('Total', draft.total.format(), emphasize: true),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: draft.narration,
            maxLength: 50,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Add a note (optional)',
            ),
            onChanged: ref.read(sendMoneyProvider.notifier).setNarration,
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Send ${draft.amount.money.format()}'),
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
