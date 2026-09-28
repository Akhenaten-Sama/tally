import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tally_colors.dart';
import '../../../core/utils/formatters.dart';
import '../data/notifications_provider.dart';
import '../domain/app_notification.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  /// Captured on open so unread items stay highlighted while viewing.
  DateTime? _seenBefore;

  @override
  void initState() {
    super.initState();
    _seenBefore =
        ref.read(notificationsSeenAtProvider).value ??
        DateTime.now().subtract(const Duration(days: 2));
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => markNotificationsSeen(ref),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(notificationsProvider);
    final groups = groupBy(items, (n) => formatDayLabel(n.time));

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: items.isEmpty
          ? Center(
              child: Text(
                "You're all caught up.",
                style: TextStyle(color: context.tally.muted),
              ),
            )
          : ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                for (final MapEntry(key: day, value: dayItems)
                    in groups.entries) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                    child: Text(
                      day,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: context.tally.muted,
                      ),
                    ),
                  ),
                  for (final n in dayItems)
                    _NotificationTile(
                      notification: n,
                      unread: n.time.isAfter(_seenBefore!),
                    ),
                ],
              ],
            ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.unread});

  final AppNotification notification;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    final tally = context.tally;
    final n = notification;
    return InkWell(
      onTap: n.route == null ? null : () => context.push(n.route!),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: tally.accent.withValues(alpha: 0.3),
              child: Icon(n.icon, size: 20, color: tally.debit),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          n.title,
                          style: TextStyle(
                            fontWeight: unread
                                ? FontWeight.w800
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        formatTime(n.time),
                        style: context.textTheme.bodySmall?.copyWith(
                          color: tally.muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(n.body, style: TextStyle(color: tally.muted)),
                ],
              ),
            ),
            SizedBox(
              width: 18,
              child: unread
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8, top: 6),
                      child: Semantics(
                        label: 'Unread',
                        child: CircleAvatar(
                          radius: 4,
                          backgroundColor: tally.bright,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
