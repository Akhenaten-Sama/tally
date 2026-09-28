import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tally_colors.dart';
import '../../../../core/widgets/liquid_glass_card.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../account/domain/account.dart';
import '../../../../core/brand/brand.dart';

class BalanceVisibility extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle() => state = !state;
}

final balanceVisibleProvider = NotifierProvider<BalanceVisibility, bool>(
  BalanceVisibility.new,
);

class BalanceCard extends ConsumerWidget {
  const BalanceCard({super.key, required this.account});

  final Account account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visible = ref.watch(balanceVisibleProvider);
    final tally = context.tally;
    final onCardMuted = tally.onCard.withValues(alpha: 0.7);

    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Available balance',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: onCardMuted,
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: visible ? 'Hide balance' : 'Show balance',
                icon: Icon(
                  visible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 18,
                  color: onCardMuted,
                ),
                onPressed: ref.read(balanceVisibleProvider.notifier).toggle,
              ),
              const Spacer(),
              _TierChip(tier: account.tier),
            ],
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              visible ? account.balance.format() : '₦ • • • • • •',
              key: ValueKey(visible),
              semanticsLabel: visible ? null : 'Balance hidden',
              style: context.textTheme.headlineLarge?.copyWith(
                color: tally.onCard,
                fontWeight: FontWeight.w800,
                fontFeatures: amountFeatures,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Text(
                '${Brand.current.shortName} · ${account.accountNumber}',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: onCardMuted,
                  fontFeatures: amountFeatures,
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                tooltip: 'Copy account number',
                icon: Icon(Icons.copy_rounded, size: 16, color: onCardMuted),
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(text: account.accountNumber),
                  );
                  await HapticFeedback.selectionClick();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Account number copied')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BalanceCardSkeleton extends StatelessWidget {
  const BalanceCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) => const _CardShell(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Skeleton(width: 120, height: 14),
        SizedBox(height: 16),
        Skeleton(width: 200, height: 30),
        SizedBox(height: 28),
        Skeleton(width: 150, height: 14),
      ],
    ),
  );
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => LiquidGlassCard(
    padding: const EdgeInsets.fromLTRB(20, 14, 12, 10),
    child: SizedBox(width: double.infinity, child: child),
  );
}

class _TierChip extends StatelessWidget {
  const _TierChip({required this.tier});

  final KycTier tier;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: GlassPill(
      child: Text(
        tier.label,
        style: context.textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );
}
