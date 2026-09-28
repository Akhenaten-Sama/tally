import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/theme/tally_colors.dart';
import '../../data/mortgage_repository.dart';
import '../../domain/mortgage.dart';

class ApplicationTile extends ConsumerWidget {
  const ApplicationTile({super.key, required this.application});

  final MortgageApplication application;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(clockProvider).value ?? DateTime.now();
    final stage = application.stageAt(now);
    final tally = context.tally;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: tally.secondary.withValues(alpha: 0.12),
        child: Icon(Icons.description_outlined, color: tally.secondary),
      ),
      title: Text(
        '${application.product.name} · '
        '${application.amount.format(showKobo: false)}',
      ),
      subtitle: Text(stage.title),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () => context.push(Routes.mortgageApplication(application.id)),
    );
  }
}
