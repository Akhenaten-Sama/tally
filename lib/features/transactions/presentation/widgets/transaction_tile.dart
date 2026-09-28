import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/kora_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../domain/bank_transaction.dart';

extension TxnCategoryUi on TxnCategory {
  String get label => switch (this) {
    TxnCategory.transfer => 'Transfer',
    TxnCategory.airtime => 'Airtime',
    TxnCategory.data => 'Data',
    TxnCategory.electricity => 'Electricity',
    TxnCategory.cable => 'Cable TV',
    TxnCategory.savings => 'Savings',
    TxnCategory.interest => 'Interest',
    TxnCategory.reversal => 'Reversal',
    TxnCategory.mortgage => 'Mortgage',
  };

  IconData get icon => switch (this) {
    TxnCategory.transfer => Icons.swap_horiz_rounded,
    TxnCategory.airtime => Icons.phone_android_rounded,
    TxnCategory.data => Icons.wifi_rounded,
    TxnCategory.electricity => Icons.bolt_rounded,
    TxnCategory.cable => Icons.tv_rounded,
    TxnCategory.savings => Icons.savings_rounded,
    TxnCategory.interest => Icons.trending_up_rounded,
    TxnCategory.reversal => Icons.undo_rounded,
    TxnCategory.mortgage => Icons.house_rounded,
  };
}

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction, this.onTap});

  final BankTransaction transaction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final kora = context.kora;
    final t = transaction;
    final sign = t.isCredit ? '+' : '−';
    final settledColor = t.isCredit ? kora.credit : kora.debit;

    return Semantics(
      button: onTap != null,
      label:
          '${t.category.label}, ${t.counterpartyName}, '
          '${t.isCredit ? 'received' : 'sent'} ${t.amount.format()}, '
          '${t.status.name}, ${formatTime(t.createdAt)}',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: kora.accent.withValues(alpha: 0.25),
                child: Icon(t.category.icon, color: kora.debit, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.counterpartyName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${t.category.label} · ${formatTime(t.createdAt)}',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: kora.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$sign${t.amount.format()}',
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontFeatures: amountFeatures,
                      color: t.status == TxnStatus.reversed
                          ? kora.muted
                          : settledColor,
                      decoration: t.status == TxnStatus.reversed
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  if (t.status != TxnStatus.successful) ...[
                    const SizedBox(height: 4),
                    StatusPill(status: t.status),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.status});

  final TxnStatus status;

  @override
  Widget build(BuildContext context) {
    final kora = context.kora;
    final (label, color) = switch (status) {
      TxnStatus.pending => ('Pending', kora.pending),
      TxnStatus.successful => ('Successful', kora.credit),
      TxnStatus.failed => ('Failed', AppColors.error),
      TxnStatus.reversed => ('Reversed', kora.muted),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class TransactionTileSkeleton extends StatelessWidget {
  const TransactionTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    child: Row(
      children: [
        Skeleton(width: 44, height: 44, radius: 22),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Skeleton(width: 140, height: 14),
              SizedBox(height: 6),
              Skeleton(width: 90, height: 10),
            ],
          ),
        ),
        Skeleton(width: 70, height: 14),
      ],
    ),
  );
}
