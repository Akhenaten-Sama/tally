/// API keys for live lookups, passed at build time from the git-ignored
/// `config/keys.json` (see `scripts/install_ios.sh`). Empty means "use the
/// simulated lookups". Never hard-code keys in source.
abstract final class LookupKeys {
  // Trimmed: keys pasted from a dashboard often carry stray spaces.
  static final paystackSecret = const String.fromEnvironment(
    'PAYSTACK_SECRET_KEY',
  ).trim();
  static final vtpassApiKey = const String.fromEnvironment('VTPASS_API_KEY')
      .trim();
  static final vtpassSecretKey = const String.fromEnvironment(
    'VTPASS_SECRET_KEY',
  ).trim();

  /// VTpass sandbox only knows its published test meters and smartcards.
  static const vtpassSandbox = bool.fromEnvironment(
    'VTPASS_SANDBOX',
    defaultValue: true,
  );

  static bool get hasPaystack => paystackSecret.isNotEmpty;
  static bool get hasVtpass =>
      vtpassApiKey.isNotEmpty && vtpassSecretKey.isNotEmpty;
}
