import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../errors/app_exception.dart';

enum LatencyProfile {
  instant('Instant', Duration.zero, Duration.zero),
  realistic(
    'Realistic',
    Duration(milliseconds: 300),
    Duration(milliseconds: 1500),
  ),
  slow('Slow 3G', Duration(seconds: 2), Duration(seconds: 5));

  const LatencyProfile(this.label, this.min, this.max);

  final String label;
  final Duration min;
  final Duration max;
}

/// How money-moving calls settle. [random] uses the configured rates.
enum OutcomeMode { random, success, failure, pending }

enum MockOutcome { success, failure, pending }

class MockNetworkConfig {
  const MockNetworkConfig({
    this.latency = LatencyProfile.realistic,
    this.offline = false,
    this.failureRate = 0.05,
    this.pendingRate = 0.05,
    this.outcomeMode = OutcomeMode.random,
  });

  /// Deterministic settings for tests.
  static const instant = MockNetworkConfig(
    latency: LatencyProfile.instant,
    failureRate: 0,
    pendingRate: 0,
  );

  final LatencyProfile latency;
  final bool offline;
  final double failureRate;
  final double pendingRate;
  final OutcomeMode outcomeMode;

  MockNetworkConfig copyWith({
    LatencyProfile? latency,
    bool? offline,
    double? failureRate,
    double? pendingRate,
    OutcomeMode? outcomeMode,
  }) => MockNetworkConfig(
    latency: latency ?? this.latency,
    offline: offline ?? this.offline,
    failureRate: failureRate ?? this.failureRate,
    pendingRate: pendingRate ?? this.pendingRate,
    outcomeMode: outcomeMode ?? this.outcomeMode,
  );
}

/// Simulates the network between the app and a bank backend so every
/// loading, offline, failure and pending state in the UI gets exercised.
class MockNetwork {
  MockNetwork(this.config, {Random? random}) : _random = random ?? Random();

  MockNetworkConfig config;
  final Random _random;

  /// Waits for a simulated round trip, then fails if the device is "offline".
  Future<void> roundTrip() async {
    final min = config.latency.min.inMilliseconds;
    final max = config.latency.max.inMilliseconds;
    final ms = max > min ? min + _random.nextInt(max - min) : min;
    if (ms > 0) await Future<void>.delayed(Duration(milliseconds: ms));
    if (config.offline) throw const NetworkException();
  }

  /// How a provider (NIBSS, a biller) responds to a request we already sent.
  MockOutcome settle() => switch (config.outcomeMode) {
    OutcomeMode.success => MockOutcome.success,
    OutcomeMode.failure => MockOutcome.failure,
    OutcomeMode.pending => MockOutcome.pending,
    OutcomeMode.random => _roll(),
  };

  /// How long a pending transaction takes to resolve.
  Duration pendingDelay() => Duration(seconds: 8 + _random.nextInt(12));

  bool chance(double probability) => _random.nextDouble() < probability;

  MockOutcome _roll() {
    final r = _random.nextDouble();
    if (r < config.failureRate) return MockOutcome.failure;
    if (r < config.failureRate + config.pendingRate) return MockOutcome.pending;
    return MockOutcome.success;
  }
}

class MockNetworkConfigNotifier extends Notifier<MockNetworkConfig> {
  @override
  MockNetworkConfig build() => const MockNetworkConfig();

  void update(MockNetworkConfig Function(MockNetworkConfig) change) =>
      state = change(state);
}

final mockNetworkConfigProvider =
    NotifierProvider<MockNetworkConfigNotifier, MockNetworkConfig>(
      MockNetworkConfigNotifier.new,
    );

/// One long-lived instance; config changes are pushed in rather than
/// rebuilding the network (and every repository that depends on it).
final mockNetworkProvider = Provider<MockNetwork>((ref) {
  final network = MockNetwork(ref.read(mockNetworkConfigProvider));
  ref.listen(mockNetworkConfigProvider, (_, next) => network.config = next);
  return network;
});
