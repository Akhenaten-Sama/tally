import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/auth_controller.dart';
import '../data/database.dart';
import '../data/demo_seeder.dart';
import '../network/mock_network.dart';
import '../theme/kora_colors.dart';

Future<void> showDebugMenu(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  builder: (_) => const _DebugMenu(),
);

class _DebugMenu extends ConsumerWidget {
  const _DebugMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(mockNetworkConfigProvider);
    final notifier = ref.read(mockNetworkConfigProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Developer tools', style: context.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            'Simulate what a real bank backend does to the app.',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.kora.muted,
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Offline'),
            subtitle: const Text('Every request fails with a network error'),
            value: config.offline,
            onChanged: (v) => notifier.update((c) => c.copyWith(offline: v)),
          ),
          const _Label('Latency'),
          SegmentedButton<LatencyProfile>(
            segments: [
              for (final p in LatencyProfile.values)
                ButtonSegment(value: p, label: Text(p.label)),
            ],
            selected: {config.latency},
            onSelectionChanged: (s) =>
                notifier.update((c) => c.copyWith(latency: s.single)),
          ),
          const _Label('Transfer outcome'),
          SegmentedButton<OutcomeMode>(
            segments: const [
              ButtonSegment(value: OutcomeMode.random, label: Text('Random')),
              ButtonSegment(value: OutcomeMode.success, label: Text('Succeed')),
              ButtonSegment(value: OutcomeMode.failure, label: Text('Fail')),
              ButtonSegment(value: OutcomeMode.pending, label: Text('Pending')),
            ],
            selected: {config.outcomeMode},
            onSelectionChanged: (s) =>
                notifier.update((c) => c.copyWith(outcomeMode: s.single)),
          ),
          if (config.outcomeMode == OutcomeMode.random) ...[
            _Label('Failure rate: ${(config.failureRate * 100).round()}%'),
            Slider(
              value: config.failureRate,
              max: 0.5,
              divisions: 10,
              onChanged: (v) =>
                  notifier.update((c) => c.copyWith(failureRate: v)),
            ),
          ],
          const _Label('Auto-lock after backgrounding'),
          SegmentedButton<Duration>(
            segments: const [
              ButtonSegment(value: Duration.zero, label: Text('Instantly')),
              ButtonSegment(value: Duration(minutes: 1), label: Text('1 min')),
              ButtonSegment(value: Duration(minutes: 5), label: Text('5 min')),
            ],
            selected: {ref.watch(autoLockDelayProvider)},
            onSelectionChanged: (s) =>
                ref.read(autoLockDelayProvider.notifier).set(s.single),
          ),
          const SizedBox(height: 8),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.restart_alt_rounded),
            title: const Text('Reset demo data'),
            subtitle: const Text('Restore the original balance and history'),
            onTap: () async {
              await DemoSeeder(ref.read(databaseProvider)).reset();
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: Text(text, style: context.textTheme.titleSmall),
  );
}
