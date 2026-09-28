import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/tally_colors.dart';

/// A brand-coloured card with a "liquid glass" finish: glowing colour
/// blobs, drifting concentric rings, a glassy top highlight and a slow
/// shimmer sweep. Static when the user has asked for reduced motion.
class LiquidGlassCard extends StatefulWidget {
  const LiquidGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = 28,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  State<LiquidGlassCard> createState() => _LiquidGlassCardState();
}

class _LiquidGlassCardState extends State<LiquidGlassCard>
    with SingleTickerProviderStateMixin {
  late final _motion = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 9),
  )..repeat();

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tally = context.tally;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final radius = BorderRadius.circular(widget.radius);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: tally.card.withValues(alpha: 0.35),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: CustomPaint(
          painter: _LiquidGlassPainter(
            progress: reduceMotion
                ? const AlwaysStoppedAnimation(0.2)
                : _motion,
            base: tally.card,
            bright: tally.bright,
            accent: tally.accent,
            secondary: tally.secondary,
            radius: widget.radius,
          ),
          child: Padding(padding: widget.padding, child: widget.child),
        ),
      ),
    );
  }
}

class _LiquidGlassPainter extends CustomPainter {
  _LiquidGlassPainter({
    required this.progress,
    required this.base,
    required this.bright,
    required this.accent,
    required this.secondary,
    required this.radius,
  }) : super(repaint: progress);

  final Animation<double> progress;
  final Color base;
  final Color bright;
  final Color accent;
  final Color secondary;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final t = progress.value;
    final wave = sin(t * pi * 2);
    final w = size.width;
    final h = size.height;

    // 1. Deep brand gradient.
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(base, Colors.black, 0.25)!,
            base,
            Color.lerp(base, bright, 0.55)!,
          ],
          stops: const [0, 0.55, 1],
        ).createShader(rect),
    );

    // 2. Soft glowing colour blobs that drift slowly.
    void blob(Offset center, double r, Color color, double alpha) {
      canvas.drawCircle(
        center,
        r,
        Paint()
          ..shader = RadialGradient(
            colors: [
              color.withValues(alpha: alpha),
              color.withValues(alpha: 0),
            ],
          ).createShader(Rect.fromCircle(center: center, radius: r)),
      );
    }

    blob(Offset(w * (0.88 + 0.03 * wave), h * -0.05), w * 0.75, accent, 0.6);
    blob(Offset(w * -0.1, h * (1.05 - 0.05 * wave)), w * 0.7, secondary, 0.55);
    blob(Offset(w * (0.55 - 0.05 * wave), h * 0.65), w * 0.45, bright, 0.35);

    // 3. Concentric rings rippling out from the top-right corner.
    final ringCenter = Offset(w * 1.02 + 6 * wave, h * -0.08 + 4 * wave);
    for (var i = 1; i <= 8; i++) {
      canvas.drawCircle(
        ringCenter,
        w * 0.14 * i,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.1
          ..color = Colors.white.withValues(alpha: 0.2 - i * 0.02),
      );
    }
    final echoCenter = Offset(w * -0.05, h * 1.1);
    for (var i = 1; i <= 4; i++) {
      canvas.drawCircle(
        echoCenter,
        w * 0.12 * i,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = Colors.white.withValues(alpha: 0.08 - i * 0.015),
      );
    }

    // 4. Glassy highlight across the top edge.
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.center,
          colors: [
            Colors.white.withValues(alpha: 0.22),
            Colors.white.withValues(alpha: 0),
          ],
        ).createShader(rect),
    );

    // 5. Shimmer: a soft diagonal band crosses once per cycle, then rests.
    final sweep = (t * 1.6).clamp(0.0, 1.0);
    if (sweep > 0 && sweep < 1) {
      final x = lerpDouble(-0.6 * w, 1.6 * w, sweep)!;
      final band = Rect.fromLTWH(x - w * 0.35, 0, w * 0.7, h);
      canvas.drawRect(
        rect,
        Paint()
          ..blendMode = BlendMode.plus
          ..shader = LinearGradient(
            begin: const Alignment(-1, -0.4),
            end: const Alignment(1, 0.4),
            colors: [
              Colors.white.withValues(alpha: 0),
              Colors.white.withValues(alpha: 0.12),
              Colors.white.withValues(alpha: 0),
            ],
          ).createShader(band),
      );
    }

    // 6. Hairline glass edge.
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.deflate(0.5), Radius.circular(radius)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.45),
            Colors.white.withValues(alpha: 0.05),
            Colors.white.withValues(alpha: 0.2),
          ],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_LiquidGlassPainter old) =>
      old.base != base ||
      old.bright != bright ||
      old.accent != accent ||
      old.secondary != secondary;
}

/// A frosted-glass pill for labels on top of [LiquidGlassCard].
class GlassPill extends StatelessWidget {
  const GlassPill({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(99),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
        ),
        child: child,
      ),
    ),
  );
}
