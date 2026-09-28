import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/tally_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/error_view.dart';
import '../data/mortgage_repository.dart';
import '../domain/mortgage.dart';
import '../../../core/brand/brand.dart';

/// Live tracker for a mortgage application.
class ApplicationScreen extends ConsumerWidget {
  const ApplicationScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final application = ref.watch(mortgageApplicationProvider(id));
    final now = ref.watch(clockProvider).value ?? DateTime.now();

    return Scaffold(
      appBar: AppBar(title: const Text('Application')),
      body: switch (application) {
        AsyncData(:final value) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          children: [
            _Header(application: value),
            const SizedBox(height: 28),
            _Timeline(current: value.stageAt(now)),
            const SizedBox(height: 16),
            if (Brand.current.showDemoHints)
              Text(
                'Demo: each stage completes after '
                '${ApplicationStage.stageDuration.inSeconds} seconds.',
                textAlign: TextAlign.center,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.tally.muted,
                ),
              ),
          ],
        ),
        AsyncError(:final error) => Center(child: ErrorView(error: error)),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.application});

  final MortgageApplication application;

  @override
  Widget build(BuildContext context) {
    final tally = context.tally;
    final a = application;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: tally.card,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            a.product.name,
            style: TextStyle(color: tally.onCard.withValues(alpha: 0.75)),
          ),
          Text(
            a.amount.format(showKobo: false),
            style: context.textTheme.headlineMedium?.copyWith(
              color: tally.onCard,
              fontWeight: FontWeight.w800,
              fontFeatures: amountFeatures,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${a.monthlyPayment.format()} a month · ${a.tenorMonths ~/ 12} years',
            style: TextStyle(color: tally.onCard),
          ),
          Text(
            a.property,
            style: TextStyle(color: tally.onCard.withValues(alpha: 0.75)),
          ),
          const SizedBox(height: 12),
          Text(
            'Ref ${a.id} · submitted ${formatDateTime(a.submittedAt)}',
            style: context.textTheme.bodySmall?.copyWith(
              color: tally.onCard.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.current});

  final ApplicationStage current;

  @override
  Widget build(BuildContext context) {
    final tally = context.tally;
    const stages = ApplicationStage.values;
    final finished = current == ApplicationStage.disbursed;

    return Column(
      children: [
        for (final (i, stage) in stages.indexed)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 32,
                  child: Column(
                    children: [
                      _Marker(
                        done: stage.index < current.index || finished,
                        active: stage == current && !finished,
                      ),
                      if (i < stages.length - 1)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: stage.index < current.index
                                ? tally.credit
                                : tally.border,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (Brand.current.showDemoHints)
                          Text(
                            stage.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: stage.index > current.index
                                  ? tally.muted
                                  : tally.debit,
                            ),
                          ),
                        if (stage.index <= current.index)
                          if (Brand.current.showDemoHints)
                            Text(
                              stage.description,
                              style: TextStyle(color: tally.muted),
                            ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Marker extends StatelessWidget {
  const _Marker({required this.done, required this.active});

  final bool done;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final tally = context.tally;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done
            ? tally.credit
            : active
            ? tally.accent
            : tally.surface,
        border: Border.all(
          color: done || active ? Colors.transparent : tally.border,
          width: 2,
        ),
      ),
      child: done
          ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
          : active
          ? Padding(
              padding: const EdgeInsets.all(7),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: tally.onAccent,
              ),
            )
          : null,
    );
  }
}
