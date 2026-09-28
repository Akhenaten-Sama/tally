import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/kora_colors.dart';
import '../../domain/amortization.dart';

final _date = DateFormat('d MMM yyyy');

class InstallmentTile extends StatelessWidget {
  const InstallmentTile({
    super.key,
    required this.installment,
    required this.isPaid,
    required this.isNext,
  });

  static const height = 72.0;

  final Installment installment;
  final bool isPaid;
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    final kora = context.kora;
    final i = installment;

    return SizedBox(
      height: height,
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: isPaid
                ? kora.credit.withValues(alpha: 0.15)
                : isNext
                ? kora.accent
                : kora.border,
            child: isPaid
                ? Icon(Icons.check_rounded, size: 18, color: kora.credit)
                : Text(
                    '${i.number}',
                    style: context.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isNext ? kora.onAccent : kora.debit,
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _date.format(i.dueDate),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Principal ${i.principal.format(showKobo: false)} · '
                  'Interest ${i.interest.format(showKobo: false)}',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: kora.muted,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                i.payment.format(),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFeatures: amountFeatures,
                  color: isPaid ? kora.muted : kora.debit,
                ),
              ),
              Text(
                isPaid
                    ? 'Paid'
                    : isNext
                    ? 'Next due'
                    : 'Bal. ${i.balanceAfter.format(showKobo: false)}',
                style: context.textTheme.bodySmall?.copyWith(
                  color: isNext ? kora.secondary : kora.muted,
                  fontWeight: isNext ? FontWeight.w700 : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
