import 'dart:math';

import '../brand/brand.dart';

/// A new transaction reference in the current brand's style.
///
/// Banks with a core-banking letterhead (CMB) use long numeric session IDs,
/// e.g. `97852603255140058`, which their statements print as
/// `MT FT-97852603255140058 …`. Other brands use `TALLY` + 12 characters.
/// Pass a seeded [random] for repeatable demo data.
String newReference({Random? random}) {
  final r = random ?? Random.secure();
  if (Brand.current.letterhead != null) {
    return [
      1 + r.nextInt(9),
      for (var i = 0; i < 16; i++) r.nextInt(10),
    ].join();
  }
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  return 'TALLY${[for (var i = 0; i < 12; i++) chars[r.nextInt(chars.length)]].join()}';
}

/// Reference for the credit that refunds a failed payment.
String reversalReference(String original) => 'RV$original';
