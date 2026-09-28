import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';
import '../../../../core/security/biometrics.dart';
import 'create_code_screen.dart';
import 'onboarding_controller.dart';
import '../../../../core/brand/brand.dart';

class PasscodeStep extends ConsumerWidget {
  const PasscodeStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => CreateCodeScreen(
    step: 4,
    length: 6,
    title: 'Create a 6-digit passcode',
    confirmTitle: 'Confirm your passcode',
    subtitle: "You'll use this to open ${Brand.current.shortName}.",
    onCreated: (passcode) async {
      ref.read(onboardingProvider.notifier).setPasscode(passcode);
      unawaited(context.push(Routes.onboardingPin));
    },
  );
}

class PinStep extends ConsumerWidget {
  const PinStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => CreateCodeScreen(
    step: 5,
    length: 4,
    title: 'Create a 4-digit transaction PIN',
    confirmTitle: 'Confirm your PIN',
    subtitle:
        'You need this to approve transfers and payments. Make it '
        'different from your passcode.',
    onCreated: (pin) async {
      final onboarding = ref.read(onboardingProvider.notifier)..setPin(pin);
      final kind = await ref.read(biometricKindProvider.future);
      if (kind == null) {
        await onboarding.finish(biometricsEnabled: false);
      } else if (context.mounted) {
        unawaited(context.push(Routes.onboardingBiometrics, extra: kind));
      }
    },
  );
}
