import 'package:flutter/material.dart';

import '../money/money.dart';
import '../theme/app_theme.dart';
import '../theme/tally_colors.dart';

/// A "check before you pay" sheet: title, big amount, detail rows and a
/// pay button. Returns true when the user confirms.
Future<bool?> showConfirmSheet(
  BuildContext context, {
  required String title,
  required Money amount,
  required List<(String, String)> rows,
  String? confirmLabel,
}) => showModalBottomSheet<bool>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  builder: (context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: context.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          amount.format(),
          textAlign: TextAlign.center,
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            fontFeatures: amountFeatures,
          ),
        ),
        const SizedBox(height: 20),
        for (final (label, value) in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: context.tally.muted)),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    value,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFeatures: amountFeatures,
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel ?? 'Pay ${amount.format()}'),
        ),
      ],
    ),
  ),
);
