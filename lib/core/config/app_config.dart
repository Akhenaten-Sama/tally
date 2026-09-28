enum Flavor { dev, demo }

/// Build-time configuration. Pass `--dart-define=FLAVOR=dev` to switch.
abstract final class AppConfig {
  static final Flavor flavor = Flavor.values.byName(
    const String.fromEnvironment('FLAVOR', defaultValue: 'demo'),
  );

  /// Screen to open on launch, e.g. `--dart-define=INITIAL_ROUTE=/send`.
  /// Handy for screenshots and working on a deep screen.
  static const initialRoute = String.fromEnvironment(
    'INITIAL_ROUTE',
    defaultValue: '/home',
  );

  /// The debug menu ships in the demo build on purpose so reviewers can
  /// force failures, go offline and reset data without a debugger attached.
  static const bool debugMenuEnabled = true;
}
