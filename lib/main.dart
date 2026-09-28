import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app/app.dart';
import 'core/config/app_config.dart';
import 'core/security/credential_store.dart';
import 'features/auth/data/auth_controller.dart';
import 'core/data/database.dart';
import 'core/data/demo_seeder.dart';
import 'features/transfers/data/transfer_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  await DemoSeeder(db).ensureSeeded();

  final credentials = CredentialStore(const FlutterSecureStorage());
  final initialAuth = await _initialAuthState(credentials);

  final container = ProviderContainer(
    // Errors surface immediately with a "Try again" button instead of
    // Riverpod silently retrying (e.g. an "account not found" lookup).
    retry: (_, _) => null,
    overrides: [
      databaseProvider.overrideWithValue(db),
      credentialStoreProvider.overrideWithValue(credentials),
      initialAuthStateProvider.overrideWithValue(initialAuth),
    ],
  );
  // Settle transfers that were still pending when the app was last killed.
  unawaited(container.read(transferRepositoryProvider).reconcilePending());

  runApp(
    UncontrolledProviderScope(container: container, child: const KoraApp()),
  );
}

/// Returning users start locked; dev builds skip straight in with the demo
/// credentials so every hot restart doesn't need a passcode.
Future<AuthState> _initialAuthState(CredentialStore credentials) async {
  var profile = await credentials.load();
  if (AppConfig.flavor == Flavor.dev) {
    if (profile == null) {
      await credentials.save(
        passcode: DemoCredentials.passcode,
        pin: DemoCredentials.pin,
        isDemo: true,
        biometricsEnabled: false,
      );
      profile = await credentials.load();
    }
    return AuthState(
      status: AuthStatus.unlocked,
      isDemo: profile!.isDemo,
      biometricsEnabled: profile.biometricsEnabled,
    );
  }
  if (profile == null) return const AuthState(status: AuthStatus.signedOut);
  return AuthState(
    status: AuthStatus.locked,
    isDemo: profile.isDemo,
    biometricsEnabled: profile.biometricsEnabled,
  );
}
