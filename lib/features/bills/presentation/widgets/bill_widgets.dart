import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/tally_colors.dart';
import '../../../../core/widgets/bill_illustration.dart';
import '../../../../core/widgets/initials_avatar.dart';
import '../../../../core/widgets/liquid_glass_card.dart';
import '../../data/recent_billers.dart';

/// Round logo-style badge for a network or biller.
class BillerBadge extends StatelessWidget {
  const BillerBadge({
    super.key,
    required this.label,
    required this.color,
    this.onColor = Colors.white,
    this.size = 44,
    this.asset,
  });

  final String label;
  final Color color;
  final Color onColor;
  final double size;

  /// A round logo image; when null a text badge is drawn.
  final String? asset;

  @override
  Widget build(BuildContext context) {
    final image = asset;
    if (image != null) {
      return Semantics(
        label: label,
        image: true,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // Keeps white logos (Airtel) visible on white cards.
            border: Border.all(color: context.tally.border),
          ),
          child: ClipOval(child: Image.asset(image, fit: BoxFit.cover)),
        ),
      );
    }
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Text(
        label.length <= 3 ? label : label.substring(0, 1),
        style: TextStyle(
          color: onColor,
          fontWeight: FontWeight.w900,
          fontSize: size * (label.length <= 3 ? 0.28 : 0.42),
        ),
      ),
    );
  }
}

/// A tappable option in a horizontal picker (networks, providers).
class BillerChoice extends StatelessWidget {
  const BillerChoice({
    super.key,
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
    this.onColor = Colors.white,
    this.asset,
  });

  final String label;
  final Color color;
  final Color onColor;
  final bool selected;
  final VoidCallback onTap;
  final String? asset;

  @override
  Widget build(BuildContext context) {
    final tally = context.tally;
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        excludeSemantics: true,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: tally.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? tally.debit : tally.border,
                width: selected ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                BillerBadge(
                  label: label,
                  color: color,
                  onColor: onColor,
                  size: 36,
                  asset: asset,
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: context.textTheme.labelMedium?.copyWith(
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Verified-customer banner after a meter or smartcard lookup.
class CustomerBanner extends StatelessWidget {
  const CustomerBanner({super.key, required this.name, this.address});

  final String name;
  final String? address;

  @override
  Widget build(BuildContext context) {
    final tally = context.tally;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: tally.credit.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_rounded, size: 18, color: tally.credit),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: tally.credit,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (address != null)
                  Text(address!, style: TextStyle(color: tally.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Keeps the action button above the keyboard; closes the keyboard on tap
/// outside a field or on scroll. Shared by every bill form.
class BillForm extends StatelessWidget {
  const BillForm({super.key, required this.children, required this.button});

  final List<Widget> children;
  final Widget button;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
    behavior: HitTestBehavior.translucent,
    child: Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: children,
          ),
        ),
        SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: button,
        ),
      ],
    ),
  );
}

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 8),
    child: Text(
      text,
      style: context.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

/// Brand glass header at the top of bill screens: an icon, a small label,
/// a big value and an optional detail line.
class BillHeader extends StatelessWidget {
  const BillHeader({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.detail,
    this.leading,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? detail;

  /// Replaces the icon, e.g. with a network badge.
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final tally = context.tally;
    final muted = tally.onCard.withValues(alpha: 0.75);
    return LiquidGlassCard(
      child: Row(
        children: [
          leading ??
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(icon, color: tally.accent),
              ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: muted)),
                const SizedBox(height: 2),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    value,
                    key: ValueKey(value),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.headlineSmall?.copyWith(
                      color: tally.onCard,
                      fontWeight: FontWeight.w800,
                      fontFeatures: amountFeatures,
                    ),
                  ),
                ),
                if (detail != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    detail!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: muted),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 10),
    child: Row(
      children: [
        Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              action!,
              style: TextStyle(
                color: context.tally.secondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    ),
  );
}

/// A selectable card for grids of amounts, plans and packages.
class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    required this.selected,
    required this.onTap,
    required this.title,
    this.subtitle,
    this.badge,
    this.semanticLabel,
    this.centered = false,
  });

  /// Centre the text, e.g. for plain amounts.
  final bool centered;
  final bool selected;
  final VoidCallback onTap;
  final String title;
  final String? subtitle;

  /// Small corner tag, e.g. "Popular".
  final String? badge;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tally = context.tally;
    return Semantics(
      button: true,
      selected: selected,
      label: semanticLabel,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              color: selected ? tally.card : tally.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: selected ? tally.card : tally.border,
                width: 1.2,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: tally.card.withValues(alpha: 0.25),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              children: [
                Column(
                  crossAxisAlignment: centered
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontFeatures: amountFeatures,
                        color: selected ? tally.onCard : tally.debit,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: selected
                              ? tally.onCard.withValues(alpha: 0.8)
                              : tally.muted,
                          fontFeatures: amountFeatures,
                        ),
                      ),
                  ],
                ),
                if (badge != null)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: tally.accent,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        badge!,
                        style: context.textTheme.labelSmall?.copyWith(
                          color: tally.onAccent,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Grid of [OptionCard]s that sizes itself inside a scrolling list.
class OptionGrid extends StatelessWidget {
  const OptionGrid({
    super.key,
    required this.columns,
    required this.children,
    this.aspectRatio = 1.9,
  });

  final int columns;
  final double aspectRatio;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => GridView.count(
    crossAxisCount: columns,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.zero,
    mainAxisSpacing: 10,
    crossAxisSpacing: 10,
    childAspectRatio: aspectRatio,
    children: children,
  );
}

/// Horizontal strip of saved numbers, meters or smartcards.
class SavedBillerStrip extends StatelessWidget {
  const SavedBillerStrip({
    super.key,
    required this.items,
    required this.onSelected,
    this.leading = const [],
  });

  final List<SavedBiller> items;
  final ValueChanged<SavedBiller> onSelected;

  /// Pinned first entries, e.g. "My number".
  final List<SavedBiller> leading;

  @override
  Widget build(BuildContext context) {
    final all = [...leading, ...items];
    if (all.isEmpty) return const SizedBox.shrink();
    final tally = context.tally;
    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: all.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final item = all[i];
          return InkWell(
            onTap: () => onSelected(item),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 250),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: tally.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: tally.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.network case final network?)
                    BillerBadge(
                      label: network.label,
                      color: network.color,
                      onColor: network.onColor,
                      size: 32,
                      asset: network.logoAsset,
                    )
                  else if (item.art case final art?)
                    BillIllustration(art: art, size: 40)
                  else
                    InitialsAvatar(name: item.title, radius: 16),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          item.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: tally.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
