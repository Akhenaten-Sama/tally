import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/network/mock_network.dart';
import '../domain/phone_number.dart';

abstract interface class AuthRepository {
  /// Sends a one-time code by SMS.
  Future<void> requestOtp(PhoneNumber phone);

  /// Throws [IncorrectOtpException] if [code] is wrong.
  Future<void> verifyOtp(PhoneNumber phone, String code);
}

class MockAuthRepository implements AuthRepository {
  MockAuthRepository(this._network);

  /// No SMS is sent in the demo; this code always works.
  static const demoOtp = '123456';

  final MockNetwork _network;

  @override
  Future<void> requestOtp(PhoneNumber phone) => _network.roundTrip();

  @override
  Future<void> verifyOtp(PhoneNumber phone, String code) async {
    await _network.roundTrip();
    if (code != demoOtp) throw const IncorrectOtpException();
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => MockAuthRepository(ref.watch(mockNetworkProvider)),
);
