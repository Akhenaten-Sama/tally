import 'package:flutter/material.dart';

import '../../../../core/security/biometrics.dart';

/// Keypad key that triggers Face ID / fingerprint.
class BiometricKey extends StatelessWidget {
  const BiometricKey({super.key, required this.kind, required this.onTap});

  final BiometricKind kind;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Use ${kind.label}',
    excludeSemantics: true,
    child: InkWell(
      customBorder: const StadiumBorder(),
      onTap: onTap,
      child: SizedBox(height: 64, child: Icon(kind.icon, size: 30)),
    ),
  );
}
