import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/security/attempt_limiter.dart';
import '../../../core/security/credential_store.dart';
import '../../account/data/account_repository.dart';
import '../../profile/data/profile_repository.dart';
import 'transaction_pin_repository.dart';

part 'auth_controller.freezed.dart';

enum AuthStatus {
  /// No credentials on this device: welcome and sign-up only.
  signedOut,

  /// Credentials exist but the app is locked behind the passcode.
  locked,
  unlocked,
}

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    required AuthStatus status,

    /// Signed in with the shared demo credentials, so hints are shown.
    @Default(false) bool isDemo,
    @Default(false) bool biometricsEnabled,
  }) = _AuthState;
}

abstract final class DemoCredentials {
  static const passcode = '123456';
  static const pin = '1234';
}

/// Read once at launch from secure storage; see main().
final initialAuthStateProvider = Provider<AuthState>(
  (ref) => throw UnimplementedError('Overridden in main()'),
);

class AuthController extends Notifier<AuthState> {
  final _passcodeLimiter = AttemptLimiter(
    maxAttempts: 5,
    lockout: const Duration(minutes: 1),
  );

  CredentialStore get _store => ref.read(credentialStoreProvider);

  @override
  AuthState build() => ref.read(initialAuthStateProvider);

  /// Stands in for the bank's login API: any Nigerian number with the demo
  /// passcode signs in to the demo account.
  Future<void> logIn(String passcode) async {
    await _passcodeLimiter.guard(
      () async => passcode == DemoCredentials.passcode,
      label: 'passcode',
    );
    await startDemo();
  }

  Future<void> startDemo() async {
    await _store.save(
      passcode: DemoCredentials.passcode,
      pin: DemoCredentials.pin,
      isDemo: true,
      biometricsEnabled: false,
    );
    state = const AuthState(status: AuthStatus.unlocked, isDemo: true);
  }

  Future<void> completeOnboarding({
    required String name,
    required String phone,
    required String passcode,
    required String pin,
    required bool biometricsEnabled,
  }) async {
    await _store.save(
      passcode: passcode,
      pin: pin,
      isDemo: false,
      biometricsEnabled: biometricsEnabled,
    );
    await ref.read(accountRepositoryProvider).updateHolderName(name);
    await ref.read(profileRepositoryProvider).setPhone(phone);
    state = AuthState(
      status: AuthStatus.unlocked,
      biometricsEnabled: biometricsEnabled,
    );
  }

  /// Throws [IncorrectPinException] or [PinLockedException] on failure.
  Future<void> unlockWithPasscode(String passcode) async {
    await _passcodeLimiter.guard(
      () => _store.checkPasscode(passcode),
      label: 'passcode',
    );
    state = state.copyWith(status: AuthStatus.unlocked);
  }

  /// Throws [IncorrectPinException] or [PinLockedException] if [current]
  /// is wrong; the same attempt limit as unlocking applies.
  Future<void> changePasscode({
    required String current,
    required String next,
  }) async {
    await _passcodeLimiter.guard(
      () => _store.checkPasscode(current),
      label: 'passcode',
    );
    await _store.setPasscode(next);
    // Demo hints would now show the wrong code.
    state = state.copyWith(isDemo: false);
  }

  /// Verifies [current] through the same guarded check used for payments.
  Future<void> changePin({
    required String current,
    required String next,
  }) async {
    await ref.read(transactionPinRepositoryProvider).verify(current);
    await _store.setPin(next);
    state = state.copyWith(isDemo: false);
  }

  /// Call only after the system biometric prompt succeeded.
  void unlockWithBiometrics() =>
      state = state.copyWith(status: AuthStatus.unlocked);

  void lock() {
    if (state.status == AuthStatus.unlocked) {
      state = state.copyWith(status: AuthStatus.locked);
    }
  }

  Future<void> setBiometricsEnabled(bool enabled) async {
    await _store.setBiometricsEnabled(enabled);
    state = state.copyWith(biometricsEnabled: enabled);
  }

  /// "Not you?": forget this user entirely.
  Future<void> signOut() async {
    await _store.clear();
    state = const AuthState(status: AuthStatus.signedOut);
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

/// How long the app may sit in the background before it locks.
class AutoLockDelay extends Notifier<Duration> {
  @override
  Duration build() => const Duration(minutes: 1);

  void set(Duration delay) => state = delay;
}

final autoLockDelayProvider = NotifierProvider<AutoLockDelay, Duration>(
  AutoLockDelay.new,
);
