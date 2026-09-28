import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/brand/brand.dart';
import '../../../../core/theme/kora_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../mortgage/data/mortgage_repository.dart';

/// "Next mortgage repayment" on Home, for brands that offer mortgages.
class MortgageDueCard extends ConsumerWidget {
  const MortgageDueCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!Brand.current.hasMortgages) return const SizedBox.shrink();
    final next = ref.watch(mortgageProvider).value?.nextInstallment;
    if (next == null) return const SizedBox.shrink();
    final kora = context.kora;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Material(
        color: kora.surface,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => context.go(Routes.mortgage),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: kora.border),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: kora.accent.withValues(alpha: 0.35),
                  child: Icon(Icons.house_rounded, color: kora.debit),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next mortgage repayment',
                        style: TextStyle(color: kora.muted),
                      ),
                      Text(
                        '${next.payment.format()} · due '
                        '${formatDayLabel(next.dueDate)}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: kora.muted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
