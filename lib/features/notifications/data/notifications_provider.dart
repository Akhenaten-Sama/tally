import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/routes.dart';
import '../../../core/brand/brand.dart';
import '../../../core/data/app_meta.dart';
import '../../../core/utils/formatters.dart';
import '../../mortgage/data/mortgage_repository.dart';
import '../../mortgage/domain/mortgage.dart';
import '../../transactions/data/transaction_repository.dart';
import '../../transactions/domain/bank_transaction.dart';
import '../domain/app_notification.dart';

const _seenKey = 'notifications_seen_at';

/// Notifications derived from account activity, newest first, so they
/// always agree with what the rest of the app shows.
final notificationsProvider = Provider<List<AppNotification>>((ref) {
  final transactions = ref.watch(allTransactionsProvider).value ?? const [];
  final now = DateTime.now();
  final items = <AppNotification>[];

  for (final t in transactions.take(40)) {
    final notification = switch (t) {
      BankTransaction(category: TxnCategory.reversal) => AppNotification(
        id: t.id,
        icon: Icons.undo_rounded,
        title: 'Refund received',
        body: '${t.amount.format()} has been returned to your account.',
        time: t.createdAt,
        route: Routes.transaction(t.id),
      ),
      BankTransaction(category: TxnCategory.interest) => AppNotification(
        id: t.id,
        icon: Icons.trending_up_rounded,
        title: 'Interest paid',
        body:
            '${t.amount.format()} interest added to your '
            '${t.counterpartyName.replaceFirst('Interest: ', '')}.',
        time: t.createdAt,
        route: Routes.transaction(t.id),
      ),
      BankTransaction(isCredit: true) => AppNotification(
        id: t.id,
        icon: Icons.south_west_rounded,
        title: 'Money received',
        body: '${t.amount.format()} from ${t.counterpartyName}.',
        time: t.createdAt,
        route: Routes.transaction(t.id),
      ),
      BankTransaction(
        category: TxnCategory.mortgage,
        status: TxnStatus.successful,
      ) =>
        AppNotification(
          id: t.id,
          icon: Icons.house_rounded,
          title: 'Mortgage repayment received',
          body: '${t.amount.format()} · ${t.narration}. Thank you!',
          time: t.createdAt,
          route: Routes.transaction(t.id),
        ),
      BankTransaction(status: TxnStatus.reversed) => AppNotification(
        id: '${t.id}-failed',
        icon: Icons.error_outline_rounded,
        title: 'Payment failed',
        body:
            '${t.amount.format()} to ${t.counterpartyName} didn\'t go '
            'through and was refunded.',
        time: t.createdAt,
        route: Routes.transaction(t.id),
      ),
      _ => null,
    };
    if (notification != null) items.add(notification);
  }

  if (Brand.current.hasMortgages) {
    final next = ref.watch(mortgageProvider).value?.nextInstallment;
    if (next != null) {
      final today = DateTime(now.year, now.month, now.day, 8);
      items.add(
        AppNotification(
          id: 'mortgage-due-${next.number}',
          icon: Icons.event_rounded,
          title: 'Repayment coming up',
          body:
              'Your mortgage repayment of ${next.payment.format()} is due on '
              '${formatDayLabel(next.dueDate)}.',
          time: today.isAfter(now)
              ? today.subtract(const Duration(days: 1))
              : today,
          route: Routes.mortgage,
        ),
      );
    }

    final applications = ref.watch(mortgageApplicationsProvider).value ?? [];
    for (final a in applications) {
      final stage = a.stageAt(now);
      items.add(
        AppNotification(
          id: 'application-${a.id}-${stage.name}',
          icon: Icons.description_outlined,
          title: 'Application update: ${stage.title}',
          body: '${a.product.name} · ${stage.description}',
          time: a.submittedAt.add(ApplicationStage.stageDuration * stage.index),
          route: Routes.mortgageApplication(a.id),
        ),
      );
    }
  }

  return items.sortedBy((n) => n.time).reversed.toList();
});

final notificationsSeenAtProvider = StreamProvider<DateTime?>(
  (ref) => ref
      .watch(appMetaProvider)
      .watch(_seenKey)
      .map((v) => v == null ? null : DateTime.tryParse(v)),
);

final unreadNotificationsProvider = Provider<int>((ref) {
  final seenAt = ref.watch(notificationsSeenAtProvider).value;
  final items = ref.watch(notificationsProvider);
  // Never opened: only the last couple of days count as new.
  final since = seenAt ?? DateTime.now().subtract(const Duration(days: 2));
  return items.where((n) => n.time.isAfter(since)).length;
});

Future<void> markNotificationsSeen(WidgetRef ref) =>
    ref.read(appMetaProvider).set(_seenKey, DateTime.now().toIso8601String());
