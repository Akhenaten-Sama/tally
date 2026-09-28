import 'package:flutter/material.dart';

import '../../../../core/theme/tally_colors.dart';

/// Shared layout for sign-up steps: progress, title, subtitle, content.
class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    super.key,
    required this.step,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  static const totalSteps = 6;

  final int step;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          label: 'Step $step of $totalSteps',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: step / totalSteps,
              minHeight: 6,
              backgroundColor: context.tally.border,
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.tally.muted,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
