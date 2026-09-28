import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/theme/kora_colors.dart';
import '../../account/data/account_repository.dart';
import '../../account/domain/account.dart';

class AccountLimitsScreen extends ConsumerWidget {
  const AccountLimitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(primaryAccountProvider).value;
    final current = account?.tier ?? KycTier.tier1;
    final kora = context.kora;

    return Scaffold(
      appBar: AppBar(title: const Text('Account limits')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
        children: [
          Text(
            'The more we know about you, the more you can send each day. '
            'This is required by the Central Bank of Nigeria.',
            style: TextStyle(color: kora.muted),
          ),
          const SizedBox(height: 20),
          for (final tier in KycTier.values) ...[
            _TierCard(
              tier: tier,
              reached: tier.level <= current.level,
              isCurrent: tier == current,
            ),
            const SizedBox(height: 12),
          ],
          if (current != KycTier.tier3) ...[
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => context.push(Routes.upgradeTier),
              child: Text('Upgrade to ${KycTier.tier3.label}'),
            ),
          ],
        ],
      ),
    );
  }
}

class _TierCard extends StatelessWidget {
  const _TierCard({
    required this.tier,
    required this.reached,
    required this.isCurrent,
  });

  final KycTier tier;
  final bool reached;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final kora = context.kora;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrent ? kora.card : kora.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isCurrent ? kora.card : kora.border),
      ),
      child: Row(
        children: [
          Icon(
            reached ? Icons.check_circle_rounded : Icons.circle_outlined,
            color: isCurrent
                ? kora.accent
                : reached
                ? kora.credit
                : kora.muted,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCurrent ? '${tier.label} · your level' : tier.label,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: isCurrent ? kora.onCard : kora.debit,
                  ),
                ),
                Text(
                  'Needs: ${tier.requirement}',
                  style: TextStyle(
                    color: isCurrent
                        ? kora.onCard.withValues(alpha: 0.75)
                        : kora.muted,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                tier.dailyLimit.format(showKobo: false),
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: isCurrent ? kora.onCard : kora.debit,
                ),
              ),
              Text(
                'per day',
                style: TextStyle(
                  color: isCurrent
                      ? kora.onCard.withValues(alpha: 0.75)
                      : kora.muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
