import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/brand/brand.dart';
import '../../../core/config/app_config.dart';
import '../../../core/debug/debug_menu.dart';
import '../../../core/theme/kora_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/error_view.dart';
import '../../account/data/account_repository.dart';
import '../../transactions/data/transaction_repository.dart';
import '../../transactions/presentation/widgets/transaction_tile.dart';
import '../../notifications/data/notifications_provider.dart';
import '../../transfers/data/transfer_repository.dart';
import 'widgets/balance_card.dart';
import 'widgets/mortgage_due_card.dart';
import 'widgets/promo_banner.dart';
import 'widgets/quick_actions.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(primaryAccountProvider);
    final recent = ref.watch(recentTransactionsProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          // Data is live from the local store; a pull settles stuck transfers.
          onRefresh: ref.read(transferRepositoryProvider).reconcilePending,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                sliver: SliverList.list(
                  children: [
                    _Header(firstName: account.value?.firstName),
                    const SizedBox(height: 20),
                    switch (account) {
                      AsyncData(:final value) => BalanceCard(account: value),
                      AsyncError(:final error) => ErrorView(
                        error: error,
                        onRetry: () => ref.invalidate(primaryAccountProvider),
                      ),
                      _ => const BalanceCardSkeleton(),
                    },
                    const MortgageDueCard(),
                    const SizedBox(height: 20),
                    const QuickActions(),
                    PromoBanner(
                      onTap: () => context.push(
                        Brand.current.hasMortgages
                            ? Routes.mortgageProducts
                            : Routes.savings,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'Recent transactions',
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => context.go(Routes.history),
                          child: const Text('See all'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              switch (recent) {
                AsyncData(:final value) when value.isEmpty =>
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        'No transactions yet. Money you send and receive '
                        'shows up here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: context.kora.muted),
                      ),
                    ),
                  ),
                AsyncData(:final value) => SliverList.builder(
                  itemCount: value.length,
                  itemBuilder: (_, i) => TransactionTile(
                    transaction: value[i],
                    onTap: () => context.push(Routes.transaction(value[i].id)),
                  ),
                ),
                AsyncError(:final error) => SliverToBoxAdapter(
                  child: ErrorView(
                    error: error,
                    onRetry: () => ref.invalidate(recentTransactionsProvider),
                  ),
                ),
                _ => SliverList.builder(
                  itemCount: 5,
                  itemBuilder: (_, _) => const TransactionTileSkeleton(),
                ),
              },
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({this.firstName});

  final String? firstName;

  @override
  Widget build(BuildContext context) {
    final name = firstName ?? '';
    return Row(
      children: [
        GestureDetector(
          // Hidden entry point to the debug menu, used in demos.
          onLongPress: AppConfig.debugMenuEnabled
              ? () => showDebugMenu(context)
              : null,
          child: CircleAvatar(
            radius: 22,
            backgroundColor: context.kora.accent,
            child: Text(
              name.isEmpty ? '' : name[0],
              style: context.textTheme.titleMedium?.copyWith(
                color: context.kora.onAccent,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting(),
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.kora.muted,
                ),
              ),
              Text(
                name,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const _NotificationBell(),
      ],
    );
  }
}

class _NotificationBell extends ConsumerWidget {
  const _NotificationBell();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadNotificationsProvider);
    return IconButton(
      tooltip: unread == 0 ? 'Notifications' : '$unread unread notifications',
      onPressed: () => context.push(Routes.notifications),
      icon: Badge(
        isLabelVisible: unread > 0,
        label: Text(unread > 9 ? '9+' : '$unread'),
        backgroundColor: context.kora.bright,
        child: const Icon(Icons.notifications_none_rounded),
      ),
    );
  }
}
