import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/mock_network.dart';
import '../../../core/security/attempt_limiter.dart';
import '../../../core/security/credential_store.dart';

abstract interface class TransactionPinRepository {
  /// Completes normally if [pin] is correct. Throws [IncorrectPinException]
  /// or [PinLockedException] otherwise.
  Future<void> verify(String pin);
}

/// Checks the PIN "server side" with an attempt limit and lockout, the way a
/// bank would, against the PIN the user set during sign-up.
class MockTransactionPinRepository implements TransactionPinRepository {
  MockTransactionPinRepository(
    this._network,
    this._store, {
    DateTime Function()? clock,
  }) : _limiter = AttemptLimiter(
         maxAttempts: maxAttempts,
         lockout: lockout,
         clock: clock,
       );

  static const maxAttempts = 3;
  static const lockout = Duration(minutes: 1);

  final MockNetwork _network;
  final CredentialStore _store;
  final AttemptLimiter _limiter;

  @override
  Future<void> verify(String pin) async {
    await _network.roundTrip();
    await _limiter.guard(() => _store.checkPin(pin));
  }
}

final transactionPinRepositoryProvider = Provider<TransactionPinRepository>(
  (ref) => MockTransactionPinRepository(
    ref.watch(mockNetworkProvider),
    ref.watch(credentialStoreProvider),
  ),
);
