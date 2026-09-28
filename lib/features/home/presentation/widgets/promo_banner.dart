import 'package:flutter/material.dart';

import '../../../../core/brand/brand.dart';

/// A brand campaign image on Home, if the brand has one.
class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final asset = Brand.current.promoBannerAsset;
    if (asset == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Semantics(
        button: onTap != null,
        label: 'Home ownership savings',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Material(
            child: Ink.image(
              image: AssetImage(asset),
              fit: BoxFit.cover,
              child: InkWell(
                onTap: onTap,
                child: const AspectRatio(aspectRatio: 3),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
