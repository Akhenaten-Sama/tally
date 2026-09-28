import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tally/core/errors/app_exception.dart';
import 'package:tally/core/network/mock_network.dart';
import 'package:tally/core/security/credential_store.dart';
import 'package:tally/features/auth/data/transaction_pin_repository.dart';

void main() {
  late DateTime now;
  late MockTransactionPinRepository pins;

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    final store = CredentialStore(const FlutterSecureStorage());
    await store.save(
      passcode: '482915',
      pin: '2580',
      isDemo: false,
      biometricsEnabled: false,
    );
    now = DateTime(2026, 9, 28, 12);
    pins = MockTransactionPinRepository(
      MockNetwork(MockNetworkConfig.instant),
      store,
      clock: () => now,
    );
  });

  test('accepts the PIN the user set', () async {
    await expectLater(pins.verify('2580'), completes);
  });

  test('counts down remaining attempts', () async {
    await expectLater(
      pins.verify('0000'),
      throwsA(
        isA<IncorrectPinException>().having((e) => e.attemptsLeft, 'left', 2),
      ),
    );
  });

  test('locks after three wrong PINs, even for the right PIN', () async {
    for (var i = 0; i < 2; i++) {
      await expectLater(
        pins.verify('0000'),
        throwsA(isA<IncorrectPinException>()),
      );
    }
    await expectLater(pins.verify('0000'), throwsA(isA<PinLockedException>()));
    await expectLater(pins.verify('2580'), throwsA(isA<PinLockedException>()));
  });

  test('unlocks after the lockout period', () async {
    for (var i = 0; i < 3; i++) {
      await pins.verify('0000').catchError((_) {});
    }
    now = now.add(MockTransactionPinRepository.lockout);
    await expectLater(pins.verify('2580'), completes);
  });

  test('a correct PIN resets the attempt count', () async {
    await pins.verify('0000').catchError((_) {});
    await pins.verify('0000').catchError((_) {});
    await pins.verify('2580');
    await expectLater(
      pins.verify('0000'),
      throwsA(
        isA<IncorrectPinException>().having((e) => e.attemptsLeft, 'left', 2),
      ),
    );
  });
}
