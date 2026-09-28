import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/security/biometrics.dart';
import '../../../../core/theme/kora_colors.dart';
import '../../../auth/data/auth_controller.dart';
import '../../../auth/presentation/widgets/biometric_key.dart';
import '../../../auth/presentation/widgets/code_entry.dart';
import '../../../transactions/domain/bank_transaction.dart';
import '../../../../core/brand/brand.dart';

/// Approves a transfer with the 4-digit PIN, or Face ID if enabled.
/// Pops with the resulting transaction, or null if dismissed.
Future<BankTransaction?> showPinSheet(
  BuildContext context, {
  required Future<BankTransaction> Function(String pin) onPin,
  required Future<BankTransaction> Function() onBiometrics,
}) => showModalBottomSheet<BankTransaction>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  builder: (_) => _PinSheet(onPin: onPin, onBiometrics: onBiometrics),
);

class _PinSheet extends ConsumerStatefulWidget {
  const _PinSheet({required this.onPin, required this.onBiometrics});

  final Future<BankTransaction> Function(String pin) onPin;
  final Future<BankTransaction> Function() onBiometrics;

  @override
  ConsumerState<_PinSheet> createState() => _PinSheetState();
}

class _PinSheetState extends ConsumerState<_PinSheet> {
  String? _biometricError;

  Future<void> _done(BankTransaction transaction) async {
    await HapticFeedback.heavyImpact();
    if (mounted) Navigator.pop(context, transaction);
  }

  Future<void> _useBiometrics(BiometricKind kind) async {
    final ok = await ref
        .read(biometricsProvider)
        .authenticate('Approve this transfer');
    if (!ok) return;
    try {
      await _done(await widget.onBiometrics());
    } on AppException catch (e) {
      if (mounted) setState(() => _biometricError = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final kind = auth.biometricsEnabled
        ? ref.watch(biometricKindProvider).value
        : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Enter transaction PIN', style: context.textTheme.titleMedium),
          if (_biometricError != null) ...[
            const SizedBox(height: 8),
            Text(
              _biometricError!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.error),
            ),
          ],
          const SizedBox(height: 24),
          CodeEntry(
            length: 4,
            hint: auth.isDemo && Brand.current.showDemoHints
                ? 'Demo PIN: ${DemoCredentials.pin}'
                : null,
            onCompleted: (pin) async => _done(await widget.onPin(pin)),
            leading: kind == null
                ? null
                : BiometricKey(kind: kind, onTap: () => _useBiometrics(kind)),
          ),
        ],
      ),
    );
  }
}
