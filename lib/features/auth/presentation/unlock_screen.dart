import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/security/biometrics.dart';
import '../../../core/theme/tally_colors.dart';
import '../../../core/widgets/initials_avatar.dart';
import '../../account/data/account_repository.dart';
import '../data/auth_controller.dart';
import 'widgets/biometric_key.dart';
import 'widgets/code_entry.dart';
import '../../../core/brand/brand.dart';

/// Covers the app while it's locked. Shown above the navigator (see
/// AppLockGuard), so whatever screen was open is still there after unlock.
class UnlockScreen extends ConsumerStatefulWidget {
  const UnlockScreen({super.key});

  @override
  ConsumerState<UnlockScreen> createState() => _UnlockScreenState();
}

class _UnlockScreenState extends ConsumerState<UnlockScreen> {
  var _confirmingSignOut = false;

  @override
  void initState() {
    super.initState();
    // Offer biometrics straight away, like other banking apps.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!ref.read(authControllerProvider).biometricsEnabled) return;
      final kind = await ref.read(biometricKindProvider.future);
      if (kind != null && mounted) await _useBiometrics(kind);
    });
  }

  Future<void> _useBiometrics(BiometricKind kind) async {
    final ok = await ref
        .read(biometricsProvider)
        .authenticate('Unlock ${Brand.current.shortName}');
    if (ok && mounted) {
      ref.read(authControllerProvider.notifier).unlockWithBiometrics();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final account = ref.watch(primaryAccountProvider).value;
    final kind = auth.biometricsEnabled
        ? ref.watch(biometricKindProvider).value
        : null;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 32),
              if (account != null)
                InitialsAvatar(name: account.holderName, radius: 36),
              const SizedBox(height: 16),
              Text(
                account == null
                    ? 'Welcome back'
                    : 'Welcome back, ${account.firstName}',
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Enter your passcode',
                style: TextStyle(color: context.tally.muted),
              ),
              const Spacer(),
              CodeEntry(
                length: 6,
                hint: auth.isDemo && Brand.current.showDemoHints
                    ? 'Demo passcode: ${DemoCredentials.passcode}'
                    : null,
                onCompleted: ref
                    .read(authControllerProvider.notifier)
                    .unlockWithPasscode,
                leading: kind == null
                    ? null
                    : BiometricKey(
                        kind: kind,
                        onTap: () => _useBiometrics(kind),
                      ),
              ),
              const SizedBox(height: 8),
              // Two taps, since there's no navigator here for a dialog.
              TextButton(
                onPressed: _confirmingSignOut
                    ? ref.read(authControllerProvider.notifier).signOut
                    : () => setState(() => _confirmingSignOut = true),
                child: Text(
                  _confirmingSignOut
                      ? 'Tap again to sign out of this device'
                      : 'Not you? Sign out',
                  style: TextStyle(
                    color: _confirmingSignOut ? AppColors.error : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
