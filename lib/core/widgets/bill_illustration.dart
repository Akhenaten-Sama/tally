import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/tally_colors.dart';

enum BillArt { airtime, data, electricity, cable }

/// Flat, two-tone spot illustrations drawn in code, so they pick up the
/// current brand's colours and stay crisp at any size.
class BillIllustration extends StatelessWidget {
  const BillIllustration({super.key, required this.art, this.size = 72});

  final BillArt art;
  final double size;

  @override
  Widget build(BuildContext context) {
    final tally = context.tally;
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: CustomPaint(
          painter: _BillArtPainter(
            art: art,
            primary: tally.card,
            bright: tally.bright,
            accent: tally.accent,
            secondary: tally.secondary,
          ),
        ),
      ),
    );
  }
}

class _BillArtPainter extends CustomPainter {
  _BillArtPainter({
    required this.art,
    required this.primary,
    required this.bright,
    required this.accent,
    required this.secondary,
  });

  final BillArt art;
  final Color primary;
  final Color bright;
  final Color accent;
  final Color secondary;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw on a 100 × 100 grid.
    canvas.scale(size.width / 100, size.height / 100);

    // Backdrop blob, ground shadow and sparkles shared by every scene.
    canvas.drawCircle(
      const Offset(52, 50),
      42,
      Paint()..color = accent.withValues(alpha: 0.28),
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(50, 90), width: 54, height: 7),
      Paint()..color = Colors.black.withValues(alpha: 0.1),
    );
    _sparkle(canvas, const Offset(16, 24), 4, secondary);
    _sparkle(canvas, const Offset(86, 76), 3, bright);
    canvas.drawCircle(const Offset(88, 18), 2.5, Paint()..color = accent);

    switch (art) {
      case BillArt.airtime:
        _airtime(canvas);
      case BillArt.data:
        _data(canvas);
      case BillArt.electricity:
        _electricity(canvas);
      case BillArt.cable:
        _cable(canvas);
    }
  }

  void _airtime(Canvas canvas) {
    final body = RRect.fromLTRBR(30, 16, 66, 86, const Radius.circular(9));
    canvas.drawRRect(body.shift(const Offset(3, 3)), _fill(Colors.black12));
    canvas.drawRRect(body, _fill(primary));
    canvas.drawRRect(
      RRect.fromLTRBR(34, 24, 62, 74, const Radius.circular(5)),
      _fill(Colors.white),
    );
    // Screen: a top-up confirmation.
    canvas.drawCircle(const Offset(48, 40), 8, _fill(accent));
    _tick(canvas, const Offset(48, 40), 4.5, primary);
    canvas.drawRRect(
      RRect.fromLTRBR(39, 54, 57, 58, const Radius.circular(2)),
      _fill(secondary.withValues(alpha: 0.6)),
    );
    canvas.drawRRect(
      RRect.fromLTRBR(42, 62, 54, 65.5, const Radius.circular(2)),
      _fill(secondary.withValues(alpha: 0.3)),
    );
    canvas.drawRRect(
      RRect.fromLTRBR(43, 79, 53, 81, const Radius.circular(1)),
      _fill(Colors.white.withValues(alpha: 0.6)),
    );
    // Signal waves.
    for (var i = 0; i < 3; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: const Offset(70, 30), radius: 7.0 + i * 7),
        -pi / 3,
        pi * 2 / 3,
        false,
        _stroke(bright.withValues(alpha: 1 - i * 0.28), 4),
      );
    }
  }

  void _data(Canvas canvas) {
    const center = Offset(44, 56);
    canvas.drawCircle(center.translate(3, 3), 26, _fill(Colors.black12));
    canvas.drawCircle(center, 26, _fill(secondary));
    final lines = _stroke(Colors.white.withValues(alpha: 0.55), 2.2);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: 24, height: 52),
      lines,
    );
    canvas.drawLine(center.translate(-26, 0), center.translate(26, 0), lines);
    canvas.drawArc(
      Rect.fromCenter(center: center.translate(0, -24), width: 46, height: 20),
      0.15,
      pi - 0.3,
      false,
      lines,
    );
    canvas.drawArc(
      Rect.fromCenter(center: center.translate(0, 24), width: 46, height: 20),
      pi + 0.15,
      pi - 0.3,
      false,
      lines,
    );
    // Wi-Fi arcs rising from the globe.
    const origin = Offset(72, 40);
    for (var i = 0; i < 3; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: origin, radius: 6.0 + i * 7),
        -pi * 3 / 4,
        pi / 2,
        false,
        _stroke(i.isEven ? primary : bright, 4),
      );
    }
    canvas.drawCircle(origin, 3.5, _fill(accent));
  }

  void _electricity(Canvas canvas) {
    // Glow rays.
    for (var i = 0; i < 7; i++) {
      final angle = -pi + i * pi / 6;
      final dir = Offset(cos(angle), sin(angle));
      const c = Offset(50, 42);
      canvas.drawLine(
        c + dir * 30,
        c + dir * 38,
        _stroke(bright.withValues(alpha: 0.8), 3.5),
      );
    }
    canvas.drawCircle(const Offset(53, 45), 23, _fill(Colors.black12));
    canvas.drawCircle(const Offset(50, 42), 23, _fill(accent));
    canvas.drawCircle(
      const Offset(42, 34),
      7,
      _fill(Colors.white.withValues(alpha: 0.55)),
    );
    // Base.
    canvas.drawRRect(
      RRect.fromLTRBR(39, 62, 61, 80, const Radius.circular(4)),
      _fill(primary),
    );
    for (final y in [67.0, 73.0]) {
      canvas.drawLine(
        Offset(42, y),
        Offset(58, y),
        _stroke(Colors.white.withValues(alpha: 0.5), 2),
      );
    }
    // Bolt.
    final bolt = Path()
      ..moveTo(53, 25)
      ..lineTo(41, 45)
      ..lineTo(49, 45)
      ..lineTo(45, 60)
      ..lineTo(59, 38)
      ..lineTo(51, 38)
      ..close();
    canvas.drawPath(bolt, _fill(primary));
  }

  void _cable(Canvas canvas) {
    // Antenna.
    final antenna = _stroke(primary, 3);
    canvas.drawLine(const Offset(50, 34), const Offset(36, 16), antenna);
    canvas.drawLine(const Offset(50, 34), const Offset(64, 14), antenna);
    canvas.drawCircle(const Offset(36, 16), 3.5, _fill(accent));
    canvas.drawCircle(const Offset(64, 14), 3.5, _fill(bright));
    // Set.
    final body = RRect.fromLTRBR(18, 32, 82, 78, const Radius.circular(10));
    canvas.drawRRect(body.shift(const Offset(3, 3)), _fill(Colors.black12));
    canvas.drawRRect(body, _fill(primary));
    canvas.drawRRect(
      RRect.fromLTRBR(24, 38, 76, 71, const Radius.circular(6)),
      _fill(secondary),
    );
    canvas.drawRRect(
      RRect.fromLTRBR(24, 38, 76, 50, const Radius.circular(6)),
      _fill(Colors.white.withValues(alpha: 0.12)),
    );
    final play = Path()
      ..moveTo(45, 46)
      ..lineTo(59, 54.5)
      ..lineTo(45, 63)
      ..close();
    canvas.drawPath(play, _fill(accent));
    // Stand.
    canvas.drawRRect(
      RRect.fromLTRBR(38, 80, 62, 84, const Radius.circular(2)),
      _fill(primary),
    );
  }

  void _sparkle(Canvas canvas, Offset c, double r, Color color) {
    final path = Path()
      ..moveTo(c.dx, c.dy - r * 2)
      ..quadraticBezierTo(c.dx, c.dy, c.dx + r * 2, c.dy)
      ..quadraticBezierTo(c.dx, c.dy, c.dx, c.dy + r * 2)
      ..quadraticBezierTo(c.dx, c.dy, c.dx - r * 2, c.dy)
      ..quadraticBezierTo(c.dx, c.dy, c.dx, c.dy - r * 2)
      ..close();
    canvas.drawPath(path, _fill(color));
  }

  void _tick(Canvas canvas, Offset c, double r, Color color) {
    final path = Path()
      ..moveTo(c.dx - r, c.dy)
      ..lineTo(c.dx - r * 0.25, c.dy + r * 0.75)
      ..lineTo(c.dx + r, c.dy - r * 0.7);
    canvas.drawPath(path, _stroke(color, 2.4)..strokeJoin = StrokeJoin.round);
  }

  static Paint _fill(Color color) => Paint()..color = color;

  static Paint _stroke(Color color, double width) => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round;

  @override
  bool shouldRepaint(_BillArtPainter old) =>
      old.art != art ||
      old.primary != primary ||
      old.accent != accent ||
      old.secondary != secondary ||
      old.bright != bright;
}
