import '../errors/app_exception.dart';

/// Limits guesses at a secret (PIN, passcode): after [maxAttempts] wrong
/// tries in a row, every attempt is refused until [lockout] has passed.
class AttemptLimiter {
  AttemptLimiter({
    required this.maxAttempts,
    required this.lockout,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final int maxAttempts;
  final Duration lockout;
  final DateTime Function() _clock;

  int _failed = 0;
  DateTime? _lockedUntil;

  /// Runs [check] unless locked. Completes normally if it returns true;
  /// otherwise throws [IncorrectPinException] or [PinLockedException].
  Future<void> guard(
    Future<bool> Function() check, {
    String label = 'PIN',
  }) async {
    final now = _clock();
    final lockedUntil = _lockedUntil;
    if (lockedUntil != null && now.isBefore(lockedUntil)) {
      throw PinLockedException(lockedUntil.difference(now));
    }

    if (await check()) {
      _failed = 0;
      _lockedUntil = null;
      return;
    }

    _failed++;
    if (_failed >= maxAttempts) {
      _failed = 0;
      _lockedUntil = now.add(lockout);
      throw PinLockedException(lockout);
    }
    throw IncorrectPinException(maxAttempts - _failed, label: label);
  }
}
