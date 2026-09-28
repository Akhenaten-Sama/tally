import 'package:flutter/material.dart';

import '../brand/brand.dart';
import 'tally_colors.dart';

/// Tabular figures keep amounts from shifting width as digits change.
const amountFeatures = [FontFeature.tabularFigures()];

abstract final class AppTheme {
  static ThemeData light([Brand? brand]) {
    final b = brand ?? Brand.current;
    return _build(Brightness.light, b, TallyColors.light(b));
  }

  static ThemeData dark([Brand? brand]) {
    final b = brand ?? Brand.current;
    return _build(Brightness.dark, b, TallyColors.dark(b));
  }

  static ThemeData _build(
    Brightness brightness,
    Brand brand,
    TallyColors tally,
  ) {
    final isDark = brightness == Brightness.dark;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: brand.primary,
          brightness: brightness,
        ).copyWith(
          // On dark backgrounds the brand's accent reads better than its
          // deep primary.
          primary: isDark ? brand.accent : brand.primary,
          onPrimary: isDark ? brand.onAccent : Colors.white,
          secondary: brand.accent,
          onSecondary: brand.onAccent,
          surface: tally.surface,
          onSurface: tally.debit,
          error: AppColors.error,
          outline: tally.border,
        );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: tally.background,
    );
    final text = brand
        .textTheme(base.textTheme)
        .apply(bodyColor: tally.debit, displayColor: tally.debit);
    final rounded = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    );

    return base.copyWith(
      textTheme: text,
      extensions: [tally],
      appBarTheme: AppBarTheme(
        backgroundColor: tally.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: tally.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: brand.accent.withValues(alpha: isDark ? 0.25 : 0.6),
        labelTextStyle: WidgetStatePropertyAll(
          text.labelSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: rounded,
          textStyle: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: rounded,
          side: BorderSide(color: tally.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: tally.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: tally.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: tally.border),
        ),
      ),
      dividerTheme: DividerThemeData(color: tally.border, space: 1),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
