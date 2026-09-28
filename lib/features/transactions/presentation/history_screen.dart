import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';

import '../../../core/theme/tally_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/error_view.dart';
import '../data/transaction_repository.dart';
import 'widgets/transaction_tile.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(allTransactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            tooltip: 'Account statement',
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () => context.push(Routes.statement),
          ),
        ],
      ),
      body: switch (transactions) {
        AsyncData(:final value) => CustomScrollView(
          slivers: [
            for (final MapEntry(key: day, value: items) in groupBy(
              value,
              (t) => formatDayLabel(t.createdAt),
            ).entries) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                  child: Text(
                    day,
                    style: context.textTheme.labelLarge?.copyWith(
                      color: context.tally.muted,
                    ),
                  ),
                ),
              ),
              SliverList.builder(
                itemCount: items.length,
                itemBuilder: (_, i) => TransactionTile(
                  transaction: items[i],
                  onTap: () => context.push(Routes.transaction(items[i].id)),
                ),
              ),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
        AsyncError(:final error) => Center(
          child: ErrorView(
            error: error,
            onRetry: () => ref.invalidate(allTransactionsProvider),
          ),
        ),
        _ => ListView.builder(
          itemCount: 8,
          itemBuilder: (_, _) => const TransactionTileSkeleton(),
        ),
      },
    );
  }
}
