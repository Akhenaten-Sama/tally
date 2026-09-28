import 'package:flutter/material.dart';

import '../brand/brand.dart';

/// Status colours, the same for every brand.
abstract final class AppColors {
  static const success = Color(0xFF1E9E62);
  static const error = Color(0xFFD64545);
  static const warning = Color(0xFFD99A00);
}

/// Semantic colours Material's ColorScheme has no slot for, derived from
/// the current [Brand].
@immutable
class KoraColors extends ThemeExtension<KoraColors> {
  const KoraColors({
    required this.background,
    required this.surface,
    required this.muted,
    required this.border,
    required this.credit,
    required this.debit,
    required this.pending,
    required this.card,
    required this.onCard,
    required this.accent,
    required this.onAccent,
    required this.bright,
    required this.secondary,
  });

  factory KoraColors.light(Brand brand) => KoraColors(
    background: const Color(0xFFF5F6F1),
    surface: Colors.white,
    muted: const Color(0xFF5E6B63),
    border: const Color(0xFFE2E6DE),
    credit: AppColors.success,
    debit: const Color(0xFF0F1A14),
    pending: AppColors.warning,
    card: brand.primary,
    onCard: Colors.white,
    accent: brand.accent,
    onAccent: brand.onAccent,
    bright: brand.bright,
    secondary: brand.secondary,
  );

  factory KoraColors.dark(Brand brand) => KoraColors(
    background: const Color(0xFF09110D),
    surface: const Color(0xFF121C17),
    muted: const Color(0xFF93A198),
    border: const Color(0xFF22302A),
    credit: const Color(0xFF4CC98B),
    debit: const Color(0xFFEEF3EC),
    pending: const Color(0xFFF0B429),
    card: Color.lerp(brand.primary, Colors.white, 0.06)!,
    onCard: Colors.white,
    accent: brand.accent,
    onAccent: brand.onAccent,
    bright: brand.bright,
    secondary: Color.lerp(brand.secondary, Colors.white, 0.35)!,
  );

  final Color background;
  final Color surface;
  final Color muted;
  final Color border;
  final Color credit;
  final Color debit;
  final Color pending;

  /// The balance card and other brand surfaces.
  final Color card;
  final Color onCard;
  final Color accent;
  final Color onAccent;
  final Color bright;
  final Color secondary;

  @override
  KoraColors copyWith({
    Color? background,
    Color? surface,
    Color? muted,
    Color? border,
    Color? credit,
    Color? debit,
    Color? pending,
    Color? card,
    Color? onCard,
    Color? accent,
    Color? onAccent,
    Color? bright,
    Color? secondary,
  }) => KoraColors(
    background: background ?? this.background,
    surface: surface ?? this.surface,
    muted: muted ?? this.muted,
    border: border ?? this.border,
    credit: credit ?? this.credit,
    debit: debit ?? this.debit,
    pending: pending ?? this.pending,
    card: card ?? this.card,
    onCard: onCard ?? this.onCard,
    accent: accent ?? this.accent,
    onAccent: onAccent ?? this.onAccent,
    bright: bright ?? this.bright,
    secondary: secondary ?? this.secondary,
  );

  @override
  KoraColors lerp(KoraColors? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return KoraColors(
      background: l(background, other.background),
      surface: l(surface, other.surface),
      muted: l(muted, other.muted),
      border: l(border, other.border),
      credit: l(credit, other.credit),
      debit: l(debit, other.debit),
      pending: l(pending, other.pending),
      card: l(card, other.card),
      onCard: l(onCard, other.onCard),
      accent: l(accent, other.accent),
      onAccent: l(onAccent, other.onAccent),
      bright: l(bright, other.bright),
      secondary: l(secondary, other.secondary),
    );
  }
}

extension KoraThemeX on BuildContext {
  KoraColors get kora => Theme.of(this).extension<KoraColors>()!;
  TextTheme get textTheme => Theme.of(this).textTheme;
}
