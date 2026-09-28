import 'package:flutter/material.dart';

import '../theme/tally_colors.dart';

/// Placeholder for screens scheduled in a later milestone.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.milestone,
  });

  final String title;
  final IconData icon;
  final int milestone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: context.tally.muted),
            const SizedBox(height: 12),
            Text(
              'Arriving in milestone $milestone',
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.tally.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
