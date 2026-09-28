import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/brand/brand.dart';
import '../../../../core/theme/tally_colors.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _Action(
          icon: Icons.north_east_rounded,
          label: 'Send',
          onTap: () => context.push(Routes.send),
        ),
        _Action(
          icon: Icons.phone_android_rounded,
          label: 'Airtime',
          onTap: () => context.push(Routes.airtime),
        ),
        _Action(
          icon: Icons.receipt_long_rounded,
          label: 'Bills',
          onTap: () => context.push(Routes.bills),
        ),
        if (Brand.current.hasMortgages)
          _Action(
            icon: Icons.house_rounded,
            label: 'Mortgage',
            onTap: () => context.go(Routes.mortgage),
          )
        else
          _Action(
            icon: Icons.savings_rounded,
            label: 'Save',
            onTap: () => context.go(Routes.savings),
          ),
      ],
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tally = context.tally;
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: tally.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: tally.border),
                ),
                child: Icon(icon, color: tally.debit),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: context.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
