import 'package:flutter/material.dart';

import '../theme/tally_colors.dart';

/// A pulsing placeholder shaped like the content that is loading.
class Skeleton extends StatefulWidget {
  const Skeleton({
    super.key,
    this.width,
    required this.height,
    this.radius = 8,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Respect "reduce motion": show a static block instead of pulsing.
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final box = Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: context.tally.border,
        borderRadius: BorderRadius.circular(widget.radius),
      ),
    );
    if (reduceMotion) return box;
    return FadeTransition(
      opacity: Tween(begin: 0.45, end: 1.0).animate(_controller),
      child: box,
    );
  }
}
