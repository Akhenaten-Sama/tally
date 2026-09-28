import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

enum BiometricKind {
  face,
  fingerprint;

  String get label => switch ((this, defaultTargetPlatform)) {
    (face, TargetPlatform.iOS) => 'Face ID',
    (fingerprint, TargetPlatform.iOS) => 'Touch ID',
    (face, _) => 'Face unlock',
    (fingerprint, _) => 'Fingerprint',
  };

  IconData get icon => switch (this) {
    face => Icons.face_rounded,
    fingerprint => Icons.fingerprint_rounded,
  };
}

class Biometrics {
  final _auth = LocalAuthentication();

  /// The biometric this device can use, or null if none is enrolled.
  Future<BiometricKind?> available() async {
    try {
      if (!await _auth.canCheckBiometrics) return null;
      final types = await _auth.getAvailableBiometrics();
      if (types.contains(BiometricType.face)) return BiometricKind.face;
      if (types.isNotEmpty) return BiometricKind.fingerprint;
      return null;
    } on Exception {
      return null;
    }
  }

  /// Shows the system prompt. False if cancelled, failed or unavailable.
  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } on Exception {
      return false;
    }
  }
}

final biometricsProvider = Provider<Biometrics>((ref) => Biometrics());

final biometricKindProvider = FutureProvider<BiometricKind?>(
  (ref) => ref.watch(biometricsProvider).available(),
);
