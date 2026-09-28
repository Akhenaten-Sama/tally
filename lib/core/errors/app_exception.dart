import '../money/money.dart';

/// Every error the UI can show. [message] is safe to display to users.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

class NetworkException extends AppException {
  const NetworkException([
    super.message = "You're offline. Check your connection and try again.",
  ]);
}

class ValidationException extends AppException {
  const ValidationException(super.message);
}

class AccountNotFoundException extends AppException {
  const AccountNotFoundException([
    super.message = "We couldn't find that account. Check the number and bank.",
  ]);
}

class InsufficientFundsException extends AppException {
  const InsufficientFundsException([
    super.message = "You don't have enough money for this transfer.",
  ]);
}

class LimitExceededException extends AppException {
  LimitExceededException(this.remaining)
    : super(
        'This exceeds your daily limit. You can send up to '
        '${remaining.format()} more today, or upgrade your account.',
      );

  final Money remaining;
}

class IncorrectPinException extends AppException {
  IncorrectPinException(this.attemptsLeft, {String label = 'PIN'})
    : super(
        'Incorrect $label. $attemptsLeft '
        '${attemptsLeft == 1 ? 'attempt' : 'attempts'} left.',
      );

  final int attemptsLeft;
}

class PinLockedException extends AppException {
  PinLockedException(this.retryAfter)
    : super(
        'Too many incorrect attempts. Try again in '
        '${retryAfter.inSeconds < 60 ? '${retryAfter.inSeconds}s' : '${retryAfter.inMinutes} min'}.',
      );

  final Duration retryAfter;
}

class IncorrectOtpException extends AppException {
  const IncorrectOtpException([
    super.message = "That code isn't right. Check the SMS and try again.",
  ]);
}

/// A live lookup provider refused the request for reasons unrelated to the
/// account itself (quota, bad key). Callers fall back to simulated lookups.
class LookupUnavailableException extends AppException {
  const LookupUnavailableException(super.message);
}
