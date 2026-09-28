import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/tally_colors.dart';

/// On-screen keypad for amounts and PINs. Built in-app rather than using the
/// system keyboard so the layout is identical on iOS and Android and no
/// third-party keyboard ever sees what's typed.
class NumberPad extends StatelessWidget {
  const NumberPad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    this.onDecimal,
    this.onClear,
    this.leading,
    this.enabled = true,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  /// Shows a "." key when set.
  final VoidCallback? onDecimal;

  /// Long-pressing backspace clears everything when set.
  final VoidCallback? onClear;

  /// Fills the bottom-left key when there's no "." (e.g. a Face ID button).
  final Widget? leading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    Widget digit(String d) => _Key(
      label: d,
      enabled: enabled,
      onTap: () => onDigit(d),
      child: Text(d, style: _digitStyle(context)),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final row in const [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
        ])
          Row(children: [for (final d in row) digit(d)]),
        Row(
          children: [
            if (onDecimal != null)
              _Key(
                label: 'Decimal point',
                enabled: enabled,
                onTap: onDecimal!,
                child: Text('.', style: _digitStyle(context)),
              )
            else
              Expanded(child: leading ?? const SizedBox()),
            digit('0'),
            _Key(
              label: 'Delete',
              enabled: enabled,
              onTap: onBackspace,
              onLongPress: onClear,
              child: const Icon(Icons.backspace_outlined),
            ),
          ],
        ),
      ],
    );
  }

  TextStyle? _digitStyle(BuildContext context) =>
      context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600);
}

class _Key extends StatelessWidget {
  const _Key({
    required this.label,
    required this.onTap,
    required this.child,
    required this.enabled,
    this.onLongPress,
  });

  final String label;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        button: true,
        label: label,
        excludeSemantics: true,
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: enabled
              ? () {
                  HapticFeedback.lightImpact();
                  onTap();
                }
              : null,
          onLongPress: enabled && onLongPress != null
              ? () {
                  HapticFeedback.mediumImpact();
                  onLongPress!();
                }
              : null,
          child: SizedBox(height: 64, child: Center(child: child)),
        ),
      ),
    );
  }
}
