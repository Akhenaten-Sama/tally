import 'package:flutter/material.dart';

import '../brand/brand.dart';
import 'kora_colors.dart';

/// Tabular figures keep amounts from shifting width as digits change.
const amountFeatures = [FontFeature.tabularFigures()];

abstract final class AppTheme {
  static ThemeData light([Brand? brand]) {
    final b = brand ?? Brand.current;
    return _build(Brightness.light, b, KoraColors.light(b));
  }

  static ThemeData dark([Brand? brand]) {
    final b = brand ?? Brand.current;
    return _build(Brightness.dark, b, KoraColors.dark(b));
  }

  static ThemeData _build(Brightness brightness, Brand brand, KoraColors kora) {
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
          surface: kora.surface,
          onSurface: kora.debit,
          error: AppColors.error,
          outline: kora.border,
        );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: kora.background,
    );
    final text = brand
        .textTheme(base.textTheme)
        .apply(bodyColor: kora.debit, displayColor: kora.debit);
    final rounded = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    );

    return base.copyWith(
      textTheme: text,
      extensions: [kora],
      appBarTheme: AppBarTheme(
        backgroundColor: kora.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: kora.surface,
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
          side: BorderSide(color: kora.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: kora.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: kora.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: kora.border),
        ),
      ),
      dividerTheme: DividerThemeData(color: kora.border, space: 1),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
