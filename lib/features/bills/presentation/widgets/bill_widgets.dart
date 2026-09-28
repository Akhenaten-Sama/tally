import 'package:flutter/material.dart';

import '../../../../core/theme/kora_colors.dart';

/// Round logo-style badge for a network or biller.
class BillerBadge extends StatelessWidget {
  const BillerBadge({
    super.key,
    required this.label,
    required this.color,
    this.onColor = Colors.white,
    this.size = 44,
  });

  final String label;
  final Color color;
  final Color onColor;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
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

/// A tappable option in a horizontal picker (networks, providers).
class BillerChoice extends StatelessWidget {
  const BillerChoice({
    super.key,
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
    this.onColor = Colors.white,
  });

  final String label;
  final Color color;
  final Color onColor;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final kora = context.kora;
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
              color: kora.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? kora.debit : kora.border,
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
    final kora = context.kora;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: kora.credit.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_rounded, size: 18, color: kora.credit),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: kora.credit,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (address != null)
                  Text(address!, style: TextStyle(color: kora.muted)),
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
