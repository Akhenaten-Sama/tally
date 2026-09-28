import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tally/core/security/credential_store.dart';

void main() {
  late CredentialStore store;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    store = CredentialStore(const FlutterSecureStorage());
  });

  Future<void> saveDefaults() => store.save(
    passcode: '482915',
    pin: '2580',
    isDemo: false,
    biometricsEnabled: true,
  );

  test('has no profile until credentials are saved', () async {
    expect(await store.load(), isNull);
    await saveDefaults();
    final profile = await store.load();
    expect(profile?.isDemo, isFalse);
    expect(profile?.biometricsEnabled, isTrue);
  });

  test('checks passcode and PIN separately', () async {
    await saveDefaults();
    expect(await store.checkPasscode('482915'), isTrue);
    expect(await store.checkPasscode('2580'), isFalse);
    expect(await store.checkPin('2580'), isTrue);
    expect(await store.checkPin('482915'), isFalse);
  });

  test('never stores the codes in plain text', () async {
    await saveDefaults();
    final raw = await const FlutterSecureStorage().readAll();
    for (final value in raw.values) {
      expect(value, isNot(contains('482915')));
      expect(value, isNot(contains('2580')));
    }
  });

  test('salts each hash, so equal codes store differently', () async {
    await store.save(
      passcode: '135790',
      pin: '135790',
      isDemo: false,
      biometricsEnabled: false,
    );
    final raw = await const FlutterSecureStorage().readAll();
    expect(raw['passcode'], isNot(raw['transaction_pin']));
  });

  test('clear signs the user out', () async {
    await saveDefaults();
    await store.clear();
    expect(await store.load(), isNull);
    expect(await store.checkPasscode('482915'), isFalse);
  });

  test('changing the PIN replaces the old one', () async {
    await saveDefaults();
    await store.setPin('7391');
    expect(await store.checkPin('2580'), isFalse);
    expect(await store.checkPin('7391'), isTrue);
    expect(await store.checkPasscode('482915'), isTrue);
  });
}
