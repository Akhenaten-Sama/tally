import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/security/biometrics.dart';
import '../../../../core/theme/kora_colors.dart';
import 'onboarding_controller.dart';
import 'onboarding_scaffold.dart';
import '../../../../core/brand/brand.dart';

class BiometricsScreen extends ConsumerStatefulWidget {
  const BiometricsScreen({super.key, required this.kind});

  final BiometricKind kind;

  @override
  ConsumerState<BiometricsScreen> createState() => _BiometricsScreenState();
}

class _BiometricsScreenState extends ConsumerState<BiometricsScreen> {
  var _busy = false;

  Future<void> _finish({required bool enable}) async {
    setState(() => _busy = true);
    var enabled = false;
    if (enable) {
      // Confirm it works before relying on it.
      enabled = await ref
          .read(biometricsProvider)
          .authenticate(
            'Turn on ${widget.kind.label} for ${Brand.current.shortName}',
          );
    }
    await ref
        .read(onboardingProvider.notifier)
        .finish(biometricsEnabled: enabled);
    // The router moves to Home once signed in.
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.kind.label;
    return OnboardingScaffold(
      step: 6,
      title: 'Turn on $label?',
      subtitle:
          'Unlock ${Brand.current.shortName} and approve transfers without typing your '
          'passcode or PIN.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: context.kora.accent.withValues(alpha: 0.35),
                shape: BoxShape.circle,
              ),
              child: Icon(widget.kind.icon, size: 64),
            ),
          ),
          const Spacer(),
          FilledButton(
            onPressed: _busy ? null : () => _finish(enable: true),
            child: Text('Turn on $label'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _busy ? null : () => _finish(enable: false),
            child: const Text('Not now'),
          ),
        ],
      ),
    );
  }
}
