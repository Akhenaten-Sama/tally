import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Everything that differs between white-label builds of the app.
/// Pick one at build time: `--dart-define=BRAND=cmb`.
@immutable
class Brand {
  const Brand({
    required this.id,
    required this.name,
    required this.shortName,
    required this.primary,
    required this.bright,
    required this.accent,
    required this.onAccent,
    required this.secondary,
    required this.fontFamily,
    required this.welcomeHeadline,
    required this.welcomeBody,
    required this.welcomeIcon,
    required this.showDemoHints,
    this.logoAsset,
    this.promoBannerAsset,
    this.heroImageAsset,
    this.heroAlignment = Alignment.center,
    this.hasMortgages = false,
  });

  final String id;

  /// "Cooperative Mortgage Bank".
  final String name;

  /// Used in tight spots: "CMBank · 8123456790".
  final String shortName;

  /// Buttons, the balance card, the welcome screen. Dark enough for white
  /// text to pass WCAG AA.
  final Color primary;

  /// The brand's signature colour, for large fills and highlights.
  final Color bright;
  final Color accent;
  final Color onAccent;
  final Color secondary;

  /// A Google Fonts family name.
  final String fontFamily;
  final String welcomeHeadline;
  final String welcomeBody;

  /// Animated graphic on the welcome screen when there's no [heroImageAsset].
  final IconData welcomeIcon;

  /// Full-bleed photo at the top of the welcome screen.
  final String? heroImageAsset;

  /// Which part of [heroImageAsset] to keep in frame (the faces).
  final Alignment heroAlignment;

  /// Show demo passcodes/PINs/OTPs and developer tools in the UI. On for
  /// the public portfolio build so reviewers can get in; off for pitches,
  /// where the presenter knows the codes and it should feel real.
  final bool showDemoHints;

  /// Shown on a white tile; null draws [name] as a wordmark instead.
  final String? logoAsset;
  final String? promoBannerAsset;

  final bool hasMortgages;

  TextTheme textTheme(TextTheme base) =>
      GoogleFonts.getTextTheme(fontFamily, base);

  static const kora = Brand(
    id: 'kora',
    name: 'Kora',
    shortName: 'Kora',
    primary: Color(0xFF0E3B2E),
    bright: Color(0xFF14463A),
    accent: Color(0xFFC8F169),
    onAccent: Color(0xFF082A20),
    secondary: Color(0xFF3B6E5A),
    fontFamily: 'Plus Jakarta Sans',
    welcomeHeadline: 'Banking that keeps up with you.',
    welcomeBody:
        'Send money to any Nigerian bank, pay bills and grow your savings, '
        'all from one app.',
    welcomeIcon: Icons.account_balance_wallet_rounded,
    showDemoHints: true,
  );

  static const cmb = Brand(
    id: 'cmb',
    name: 'Cooperative Mortgage Bank',
    shortName: 'CMBank',
    // Brand green #00A859 is too light for white body text (3.1:1), so
    // actions use a deeper shade of it (5.3:1).
    primary: Color(0xFF007A45),
    bright: Color(0xFF00A859),
    accent: Color(0xFFBBCE61),
    onAccent: Color(0xFF0B3B22),
    secondary: Color(0xFF3A569C),
    fontFamily: 'Mulish',
    welcomeHeadline: "There's no feeling like having a place to call your own.",
    welcomeBody:
        'Save towards your home, manage your mortgage and bank on the go '
        'with Cooperative Mortgage Bank.',
    welcomeIcon: Icons.house_rounded,
    heroImageAsset: 'assets/brands/cmb/welcome_hero.jpg',
    heroAlignment: Alignment(-0.2, 0.3),
    showDemoHints: false,
    logoAsset: 'assets/brands/cmb/logo.jpg',
    promoBannerAsset: 'assets/brands/cmb/promo_home_ownership.jpg',
    hasMortgages: true,
  );

  static final Brand current = switch (const String.fromEnvironment(
    'BRAND',
    defaultValue: 'kora',
  )) {
    'cmb' => cmb,
    _ => kora,
  };
}
