import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/error_view.dart';
import '../data/mortgage_repository.dart';
import '../domain/mortgage.dart';
import 'widgets/installment_tile.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mortgage = ref.watch(mortgageProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Repayment schedule')),
      body: switch (mortgage) {
        AsyncData(value: final Mortgage m) => _Schedule(mortgage: m),
        AsyncData() => const Center(child: Text('No active mortgage')),
        AsyncError(:final error) => Center(child: ErrorView(error: error)),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Schedule extends StatefulWidget {
  const _Schedule({required this.mortgage});

  final Mortgage mortgage;

  @override
  State<_Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<_Schedule> {
  // Open scrolled to the last payment made, so the next one is in view.
  late final _scroll = ScrollController(
    initialScrollOffset:
        (widget.mortgage.installmentsPaid - 1).clamp(0, 1 << 20) *
        InstallmentTile.height,
  );

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final schedule = widget.mortgage.schedule;
    final paid = widget.mortgage.installmentsPaid;
    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemExtent: InstallmentTile.height,
      itemCount: schedule.length,
      itemBuilder: (_, i) => InstallmentTile(
        installment: schedule[i],
        isPaid: i < paid,
        isNext: i == paid,
      ),
    );
  }
}
