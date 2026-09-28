import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/theme/kora_colors.dart';
import 'airtime_screen.dart';

class BillsScreen extends StatelessWidget {
  const BillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final options = [
      (
        Icons.phone_android_rounded,
        'Airtime',
        'All networks',
        () => context.push(Routes.airtime, extra: TopUpKind.airtime),
      ),
      (
        Icons.wifi_rounded,
        'Data',
        'Daily to monthly plans',
        () => context.push(Routes.airtime, extra: TopUpKind.data),
      ),
      (
        Icons.bolt_rounded,
        'Electricity',
        'Prepaid & postpaid',
        () => context.push(Routes.electricity),
      ),
      (
        Icons.tv_rounded,
        'Cable TV',
        'DStv, GOtv, StarTimes',
        () => context.push(Routes.cable),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Pay bills')),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.1,
        children: [
          for (final (icon, title, subtitle, onTap) in options)
            _BillTile(
              icon: icon,
              title: title,
              subtitle: subtitle,
              onTap: onTap,
            ),
        ],
      ),
    );
  }
}

class _BillTile extends StatelessWidget {
  const _BillTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final kora = context.kora;
    return Material(
      color: kora.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kora.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: kora.accent.withValues(alpha: 0.35),
                child: Icon(icon, color: kora.debit),
              ),
              const Spacer(),
              Text(
                title,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                subtitle,
                style: context.textTheme.bodySmall?.copyWith(color: kora.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
