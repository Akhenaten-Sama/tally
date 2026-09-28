import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// What the app knows about the signed-in user at launch.
class StoredProfile {
  const StoredProfile({required this.isDemo, required this.biometricsEnabled});

  final bool isDemo;
  final bool biometricsEnabled;
}

/// Keeps the login passcode and transaction PIN in the Keychain / Keystore.
///
/// Only salted hashes are stored, never the codes themselves. In a real bank
/// the PIN is verified by the server; this stands in for that check.
class CredentialStore {
  CredentialStore(this._storage, {Random? random})
    : _random = random ?? Random.secure();

  final FlutterSecureStorage _storage;
  final Random _random;

  static const _passcodeKey = 'passcode';
  static const _pinKey = 'transaction_pin';
  static const _isDemoKey = 'is_demo';
  static const _biometricsKey = 'biometrics_enabled';

  Future<StoredProfile?> load() async {
    final values = await _storage.readAll();
    if (!values.containsKey(_passcodeKey)) return null;
    return StoredProfile(
      isDemo: values[_isDemoKey] == 'true',
      biometricsEnabled: values[_biometricsKey] == 'true',
    );
  }

  Future<void> save({
    required String passcode,
    required String pin,
    required bool isDemo,
    required bool biometricsEnabled,
  }) async {
    await _storage.write(key: _passcodeKey, value: _hash(passcode));
    await _storage.write(key: _pinKey, value: _hash(pin));
    await _storage.write(key: _isDemoKey, value: '$isDemo');
    await _storage.write(key: _biometricsKey, value: '$biometricsEnabled');
  }

  Future<bool> checkPasscode(String passcode) => _check(_passcodeKey, passcode);

  Future<bool> checkPin(String pin) => _check(_pinKey, pin);

  Future<void> setPasscode(String passcode) =>
      _storage.write(key: _passcodeKey, value: _hash(passcode));

  Future<void> setPin(String pin) =>
      _storage.write(key: _pinKey, value: _hash(pin));

  Future<void> setBiometricsEnabled(bool enabled) =>
      _storage.write(key: _biometricsKey, value: '$enabled');

  Future<void> clear() => _storage.deleteAll();

  Future<bool> _check(String key, String secret) async {
    final stored = await _storage.read(key: key);
    if (stored == null) return false;
    final [salt, hash] = stored.split(':');
    return _constantTimeEquals(_digest(salt, secret), hash);
  }

  String _hash(String secret) {
    final salt = base64Url.encode(
      List<int>.generate(16, (_) => _random.nextInt(256)),
    );
    return '$salt:${_digest(salt, secret)}';
  }

  static String _digest(String salt, String secret) =>
      sha256.convert(utf8.encode('$salt$secret')).toString();

  /// Doesn't stop early on the first differing character, so response time
  /// leaks nothing about how close a guess was.
  static bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return diff == 0;
  }
}

final credentialStoreProvider = Provider<CredentialStore>(
  (ref) => CredentialStore(const FlutterSecureStorage()),
);
