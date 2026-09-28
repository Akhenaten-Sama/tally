import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/kora_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/liquid_glass_card.dart';
import '../../../core/widgets/skeleton.dart';
import '../data/mortgage_repository.dart';
import '../domain/mortgage.dart';
import 'repay_mortgage.dart';
import 'widgets/application_tile.dart';
import 'widgets/installment_tile.dart';

final _monthYear = DateFormat('MMM yyyy');

class MortgageScreen extends ConsumerWidget {
  const MortgageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mortgage = ref.watch(mortgageProvider);
    final applications = ref.watch(mortgageApplicationsProvider).value ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('My mortgage')),
      body: switch (mortgage) {
        AsyncData(:final value) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          children: [
            if (value == null)
              const _NoMortgage()
            else ...[
              _SummaryCard(mortgage: value),
              const SizedBox(height: 16),
              if (value.nextInstallment != null) ...[
                _NextRepayment(mortgage: value),
                const SizedBox(height: 24),
              ],
              _Details(mortgage: value),
              const SizedBox(height: 24),
              _SectionHeader(
                title: 'Upcoming payments',
                action: 'Full schedule',
                onAction: () => context.push(Routes.mortgageSchedule),
              ),
              for (final installment
                  in value.schedule.skip(value.installmentsPaid).take(3))
                InstallmentTile(
                  installment: installment,
                  isNext: installment.number == value.installmentsPaid + 1,
                  isPaid: false,
                ),
            ],
            if (applications.isNotEmpty) ...[
              const SizedBox(height: 24),
              const _SectionHeader(title: 'Your applications'),
              for (final application in applications)
                ApplicationTile(application: application),
            ],
            const SizedBox(height: 24),
            const _ProductsCta(),
          ],
        ),
        AsyncError(:final error) => Center(
          child: ErrorView(
            error: error,
            onRetry: () => ref.invalidate(mortgageProvider),
          ),
        ),
        _ => const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Skeleton(height: 200, radius: 24),
              SizedBox(height: 16),
              Skeleton(height: 120, radius: 20),
            ],
          ),
        ),
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.mortgage});

  final Mortgage mortgage;

  @override
  Widget build(BuildContext context) {
    final kora = context.kora;
    final onCardMuted = kora.onCard.withValues(alpha: 0.75);
    final percent = (mortgage.progress * 100).toStringAsFixed(1);

    return LiquidGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.house_rounded, color: kora.accent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  mortgage.propertyName,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: kora.onCard,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            mortgage.propertyLocation,
            style: context.textTheme.bodySmall?.copyWith(color: onCardMuted),
          ),
          const SizedBox(height: 20),
          Text(
            'Outstanding balance',
            style: context.textTheme.bodyMedium?.copyWith(color: onCardMuted),
          ),
          Text(
            mortgage.outstanding.format(),
            style: context.textTheme.headlineMedium?.copyWith(
              color: kora.onCard,
              fontWeight: FontWeight.w800,
              fontFeatures: amountFeatures,
            ),
          ),
          const SizedBox(height: 16),
          Semantics(
            label: '$percent percent of the loan repaid',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: mortgage.progress,
                minHeight: 8,
                color: kora.accent,
                backgroundColor: kora.onCard.withValues(alpha: 0.2),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$percent% repaid · ${mortgage.principalRepaid.format(showKobo: false)} '
            'of ${mortgage.principal.format(showKobo: false)}',
            style: context.textTheme.bodySmall?.copyWith(color: onCardMuted),
          ),
        ],
      ),
    );
  }
}

class _NextRepayment extends ConsumerWidget {
  const _NextRepayment({required this.mortgage});

  final Mortgage mortgage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kora = context.kora;
    final next = mortgage.nextInstallment!;
    final days = DateUtils.dateOnly(next.dueDate)
        .difference(DateUtils.dateOnly(DateTime.now()))
        .inDays;
    final dueText = switch (days) {
      < 0 => 'Overdue by ${-days} ${-days == 1 ? 'day' : 'days'}',
      0 => 'Due today',
      1 => 'Due tomorrow',
      _ => 'Due in $days days · ${formatDayLabel(next.dueDate)}',
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kora.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kora.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Next repayment', style: TextStyle(color: kora.muted)),
          const SizedBox(height: 4),
          Text(
            next.payment.format(),
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              fontFeatures: amountFeatures,
            ),
          ),
          Text(
            dueText,
            style: TextStyle(
              color: days < 0 ? AppColors.error : kora.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => repayMortgage(context, ref, mortgage),
            child: const Text('Make a repayment'),
          ),
        ],
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.mortgage});

  final Mortgage mortgage;

  @override
  Widget build(BuildContext context) {
    final years = mortgage.tenorMonths ~/ 12;
    final rows = [
      ('Product', mortgage.product.name),
      ('Interest rate', mortgage.product.rateLabel),
      ('Loan amount', mortgage.principal.format()),
      ('Monthly repayment', mortgage.monthlyPayment.format()),
      ('Tenor', '$years years'),
      (
        'Payments made',
        '${mortgage.installmentsPaid} of ${mortgage.tenorMonths}',
      ),
      ('Final payment', _monthYear.format(mortgage.maturityDate)),
    ];
    return Column(
      children: [
        for (final (label, value) in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Row(
              children: [
                Text(label, style: TextStyle(color: context.kora.muted)),
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
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(
        title,
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      const Spacer(),
      if (action != null) TextButton(onPressed: onAction, child: Text(action!)),
    ],
  );
}

class _ProductsCta extends StatelessWidget {
  const _ProductsCta();

  @override
  Widget build(BuildContext context) {
    final kora = context.kora;
    return Material(
      color: kora.secondary.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push(Routes.mortgageProducts),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.calculate_rounded, color: kora.secondary, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explore mortgage products',
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Calculate repayments and apply in minutes',
                      style: TextStyle(color: kora.muted),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: kora.muted),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoMortgage extends StatelessWidget {
  const _NoMortgage();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 32),
    child: Column(
      children: [
        Icon(Icons.house_outlined, size: 56, color: context.kora.muted),
        const SizedBox(height: 12),
        Text(
          "You don't have a mortgage with us yet",
          style: context.textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          'See what you could borrow below.',
          style: TextStyle(color: context.kora.muted),
        ),
      ],
    ),
  );
}
