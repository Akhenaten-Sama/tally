import 'package:flutter/material.dart';

import '../../../../core/theme/kora_colors.dart';
import '../../../../core/widgets/initials_avatar.dart';

class RecipientHeader extends StatelessWidget {
  const RecipientHeader({
    super.key,
    required this.name,
    required this.bankName,
    required this.accountNumber,
  });

  final String name;
  final String bankName;
  final String accountNumber;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: context.kora.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: context.kora.border),
    ),
    child: Row(
      children: [
        InitialsAvatar(name: name),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '$bankName · $accountNumber',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.kora.muted,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
