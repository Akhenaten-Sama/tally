import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/brand/brand_logo.dart';
import '../core/theme/tally_colors.dart';
import '../features/auth/data/auth_controller.dart';
import '../features/auth/presentation/unlock_screen.dart';

/// Sits above the navigator and:
/// - locks the app after it has been in the background for the auto-lock
///   delay,
/// - covers the app while locked, keeping the screen underneath intact,
/// - hides balances in the app switcher with a branded cover.
class AppLockGuard extends ConsumerStatefulWidget {
  const AppLockGuard({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppLockGuard> createState() => _AppLockGuardState();
}

class _AppLockGuardState extends ConsumerState<AppLockGuard> {
  late final AppLifecycleListener _lifecycle;
  DateTime? _backgroundedAt;
  var _obscured = false;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onStateChange: _onStateChange);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  void _onStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        // App switcher, Control Centre, an incoming call.
        setState(() => _obscured = true);
      case AppLifecycleState.hidden || AppLifecycleState.paused:
        _backgroundedAt ??= DateTime.now();
      case AppLifecycleState.resumed:
        final since = _backgroundedAt;
        _backgroundedAt = null;
        if (since != null &&
            DateTime.now().difference(since) >=
                ref.read(autoLockDelayProvider)) {
          ref.read(authControllerProvider.notifier).lock();
        }
        setState(() => _obscured = false);
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locked =
        ref.watch(authControllerProvider.select((a) => a.status)) ==
        AuthStatus.locked;

    return Stack(
      children: [
        // Hidden from screen readers and frozen while locked.
        ExcludeSemantics(
          excluding: locked,
          child: TickerMode(enabled: !locked, child: widget.child),
        ),
        if (locked) const Positioned.fill(child: UnlockScreen()),
        if (_obscured) const Positioned.fill(child: _PrivacyCover()),
      ],
    );
  }
}

class _PrivacyCover extends StatelessWidget {
  const _PrivacyCover();

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: context.tally.card,
    child: const Center(child: BrandLogo(height: 96)),
  );
}
