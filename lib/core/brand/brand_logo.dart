import 'package:flutter/material.dart';

import 'brand.dart';

/// The brand's logo on a white tile, or its wordmark if it has no logo.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, required this.height, this.wordmarkColor});

  final double height;

  /// Colour of the text wordmark; ignored when there's a logo image.
  final Color? wordmarkColor;

  @override
  Widget build(BuildContext context) {
    final brand = Brand.current;
    final asset = brand.logoAsset;
    if (asset == null) {
      return Text(
        brand.shortName.toLowerCase(),
        style: TextStyle(
          fontSize: height * 0.8,
          height: 1,
          color: wordmarkColor ?? brand.accent,
          fontWeight: FontWeight.w800,
          letterSpacing: -1,
        ),
      );
    }
    return Semantics(
      label: brand.name,
      image: true,
      child: Container(
        height: height,
        padding: EdgeInsets.all(height * 0.06),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(height * 0.18),
        ),
        child: Image.asset(asset, fit: BoxFit.contain),
      ),
    );
  }
}
