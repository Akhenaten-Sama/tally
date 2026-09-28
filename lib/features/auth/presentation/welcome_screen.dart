import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/brand/brand.dart';
import '../../../core/brand/brand_logo.dart';
import '../../../core/theme/tally_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = Brand.current;
    final tally = context.tally;
    final text = context.textTheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: tally.card,
        body: Column(
          children: [
            const Expanded(child: _Hero()),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      brand.welcomeHeadline,
                      style: text.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      brand.welcomeBody,
                      style: text.bodyLarge?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 28),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: tally.accent,
                        foregroundColor: tally.onAccent,
                      ),
                      onPressed: () => context.push(Routes.onboardingPhone),
                      child: const Text('Create an account'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                      ),
                      onPressed: () => context.push(Routes.login),
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Brand photo with a slow Ken Burns zoom, or a gently floating brand
/// graphic when the brand has no photo. Fades into the background below.
class _Hero extends StatefulWidget {
  const _Hero();

  @override
  State<_Hero> createState() => _HeroState();
}

class _HeroState extends State<_Hero> with SingleTickerProviderStateMixin {
  late final _motion = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 16),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brand = Brand.current;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final t = reduceMotion
        ? const AlwaysStoppedAnimation(0.0)
        : CurvedAnimation(parent: _motion, curve: Curves.easeInOut);
    final photo = brand.heroImageAsset;

    return LayoutBuilder(
      builder: (context, constraints) {
        // The photo is small, so show it modestly wide rather than cropping
        // it to fill; its top and bottom edges fade into the background.
        const photoAspect = 980 / 500;
        final photoHeight = min(
          constraints.maxHeight,
          constraints.maxWidth / photoAspect * 1.35,
        );

        return Stack(
          fit: StackFit.expand,
          children: [
            if (photo != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: photoHeight,
                // Fade the photo itself to transparent at the top and bottom,
                // so no edge can show against the background.
                child: ShaderMask(
                  blendMode: BlendMode.dstIn,
                  shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    // Fully clear for the first few pixels: the top row can
                    // straddle a physical pixel and would otherwise bleed.
                    stops: [0, 0.03, 0.45, 0.75, 1],
                    colors: [
                      Color(0x00000000),
                      Color(0x00000000),
                      Color(0xFF000000),
                      Color(0xFF000000),
                      Color(0x00000000),
                    ],
                  ).createShader(bounds),
                  child: ClipRect(
                    child: AnimatedBuilder(
                      animation: t,
                      builder: (context, child) => Transform.scale(
                        scale: 1 + 0.06 * t.value,
                        alignment: brand.heroAlignment,
                        child: child,
                      ),
                      child: Image.asset(
                        photo,
                        fit: BoxFit.cover,
                        alignment: brand.heroAlignment,
                        semanticLabel: 'A couple relaxing in their home',
                      ),
                    ),
                  ),
                ),
              ),
            if (photo != null)
              // Covers the photo's top edge, which can land between
              // physical pixels and show as a hairline.
              Positioned(
                left: 0,
                right: 0,
                bottom: photoHeight - 2,
                height: 4,
                child: ColoredBox(color: context.tally.card),
              )
            else
              Center(
                child: AnimatedBuilder(
                  animation: t,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(0, 12 * sin(t.value * pi * 2)),
                    child: child,
                  ),
                  child: Icon(
                    brand.welcomeIcon,
                    size: 200,
                    color: Colors.white.withValues(alpha: 0.14),
                  ),
                ),
              ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: BrandLogo(height: brand.logoAsset == null ? 40 : 72),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
