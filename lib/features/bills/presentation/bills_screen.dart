import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/theme/tally_colors.dart';
import '../../../core/widgets/bill_illustration.dart';
import '../../transactions/domain/bank_transaction.dart';
import '../../transactions/presentation/widgets/transaction_tile.dart';
import '../data/recent_billers.dart';
import 'widgets/bill_widgets.dart';

class BillsScreen extends ConsumerWidget {
  const BillsScreen({super.key});

  static String routeFor(TxnCategory category) => switch (category) {
    TxnCategory.electricity => Routes.electricity,
    TxnCategory.cable => Routes.cable,
    _ => Routes.airtime,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (spent, count) = ref.watch(billsThisMonthProvider);
    final recent = ref.watch(recentBillPaymentsProvider);
    final tally = context.tally;

    final categories = [
      (
        BillArt.airtime,
        'Airtime',
        'MTN, Airtel, Glo, 9mobile',
        () => context.push(Routes.airtime),
      ),
      (
        BillArt.data,
        'Data',
        'Daily to monthly plans',
        () =>
            context.push(Routes.airtime, extra: const BillPrefill(data: true)),
      ),
      (
        BillArt.electricity,
        'Electricity',
        'Prepaid & postpaid',
        () => context.push(Routes.electricity),
      ),
      (
        BillArt.cable,
        'Cable TV',
        'DStv, GOtv, StarTimes',
        () => context.push(Routes.cable),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Pay bills')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
        children: [
          BillHeader(
            icon: Icons.receipt_long_rounded,
            label: 'Bills this month',
            value: spent.format(),
            detail: count == 0
                ? 'Nothing paid yet this month'
                : '$count ${count == 1 ? 'payment' : 'payments'} so far',
          ),
          const SectionTitle('What would you like to pay?'),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.95,
            children: [
              for (final (art, title, subtitle, onTap) in categories)
                _CategoryTile(
                  art: art,
                  title: title,
                  subtitle: subtitle,
                  onTap: onTap,
                ),
            ],
          ),
          const SectionTitle('Recent payments'),
          if (recent.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Your bill payments will show up here, ready to repeat.',
                style: TextStyle(color: tally.muted),
              ),
            )
          else
            Container(
              decoration: BoxDecoration(
                color: tally.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: tally.border),
              ),
              child: Column(
                children: [
                  for (final (i, t) in recent.indexed) ...[
                    if (i > 0) const Divider(indent: 16, endIndent: 16),
                    _RecentPayment(transaction: t),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.art,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final BillArt art;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tally = context.tally;
    return Semantics(
      button: true,
      label: '$title. $subtitle',
      excludeSemantics: true,
      child: Material(
        color: tally.surface,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: tally.border),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [tally.accent.withValues(alpha: 0.18), tally.surface],
              ),
            ),
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(child: BillIllustration(art: art, size: 96)),
                ),
                Text(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: tally.muted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecentPayment extends StatelessWidget {
  const _RecentPayment({required this.transaction});

  final BankTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final tally = context.tally;
    final prefill = BillPrefill.fromTransaction(t);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: tally.accent.withValues(alpha: 0.3),
            child: Icon(t.category.icon, size: 20, color: tally.debit),
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
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  '${t.amount.format(showKobo: false)} · '
                  '${t.counterpartyAccount ?? ''}',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: tally.muted,
                  ),
                ),
              ],
            ),
          ),
          if (prefill != null)
            TextButton(
              onPressed: () => context.push(
                BillsScreen.routeFor(t.category),
                extra: prefill,
              ),
              child: const Text('Pay again'),
            ),
        ],
      ),
    );
  }
}
