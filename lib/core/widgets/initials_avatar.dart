import 'package:flutter/material.dart';

import '../theme/kora_colors.dart';
import '../utils/formatters.dart';

class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar({super.key, required this.name, this.radius = 22});

  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: radius,
    backgroundColor: context.kora.accent.withValues(alpha: 0.35),
    child: Text(
      initials(name),
      style: context.textTheme.labelLarge?.copyWith(
        color: context.kora.debit,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}
