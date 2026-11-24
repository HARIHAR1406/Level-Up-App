// =============================================================================
// Level Up Design System - Color Palette
// =============================================================================
// Centralized color tokens for both dark and light themes.
// Includes module-specific accent colors (Budget blue/green,
// Habits indigo/accent), glow effects, and 20 immutable category colors.
// =============================================================================

import 'package:flutter/material.dart';

/// Centralized color palette for Level Up.
/// Contains dark and light theme tokens matching the design system specifications.
class AppColors {
  AppColors._();

  // ---------------------------------------------------------------------------
  // Dark Palette (Default)
  // ---------------------------------------------------------------------------
  static const Color darkBg = Color(0xFF0D1117);
  static const Color darkSurface = Color(0xFF161B27);
  static const Color darkSurface2 = Color(0xFF1E2535);
  static const Color darkBorder = Color(0xFF2A3148);
  static const Color darkText = Color(0xFFE6E9F4);
  static const Color darkMuted = Color(0xFF7E879E);
  static const Color darkText3 = Color(0xFF4A526A);
  static const Color darkBudgetBlue = Color(0xFF4F8EF7);
  static const Color darkBudgetGreen = Color(0xFF56D49A);
  static const Color darkHabitsIndigo = Color(0xFF675DF9);
  static const Color darkHabitsAccent = Color(0xFF7C75FF);
  static const Color darkDanger = Color(0xFFF06B6B);
  static const Color darkSuccess = Color(0xFF22C55E);
  static const Color darkCircleFill = Color(0xFF0D1117);

  // ---------------------------------------------------------------------------
  // Light Palette
  // ---------------------------------------------------------------------------
  static const Color lightBg = Color(0xFFF2F4FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurface2 = Color(0xFFE9EDFF);
  static const Color lightBorder = Color(0xFFC7C4D8);
  static const Color lightText = Color(0xFF141B2B);
  static const Color lightMuted = Color(0xFF5B5E6A);
  static const Color lightText3 = Color(0xFF9CA3AF);
  static const Color lightBudgetBlue = Color(0xFF0059BA);
  static const Color lightBudgetGreen = Color(0xFF006C47);
  static const Color lightHabitsIndigo = Color(0xFF4D41DF);
  static const Color lightHabitsAccent = Color(0xFF6C63FF);
  static const Color lightDanger = Color(0xFFD93838);
  static const Color lightSuccess = Color(0xFF22C55E);
  static const Color lightCircleFill = Color(0xFFF9F9FF);

  // ---------------------------------------------------------------------------
  // Glow Accents (Radial halos)
  // ---------------------------------------------------------------------------
  static const Color darkBudgetBlueGlow = Color(0x734F8EF7); // rgba(79, 142, 247, 0.45)
  static const Color darkHabitsIndigoGlow = Color(0x73675DF9); // rgba(103, 93, 249, 0.45)
  static const Color darkGreenGlow = Color(0x6656D49A); // rgba(86, 212, 154, 0.40)

  // ---------------------------------------------------------------------------
  // Habits Categories (20 Immutable Category Colors)
  // ---------------------------------------------------------------------------
  static const List<Color> habitsCategories = [
    Color(0xFFEF4444), // 1. Health & Fitness
    Color(0xFF3B82F6), // 2. Study & Learning
    Color(0xFF8B5CF6), // 3. Work & Career
    Color(0xFFF59E0B), // 4. Morning Routine
    Color(0xFFF97316), // 5. Evening Routine
    Color(0xFF14B8A6), // 6. Meditation
    Color(0xFF22C55E), // 7. Nutrition & Diet
    Color(0xFF6366F1), // 8. Sleep & Rest
    Color(0xFFA16207), // 9. Reading & Books
    Color(0xFF84CC16), // 10. Finance
    Color(0xFFEC4899), // 11. Social & Family
    Color(0xFFF43F5E), // 12. Creativity
    Color(0xFF06B6D4), // 13. Sports
    Color(0xFF64748B), // 14. Hygiene
    Color(0xFF0EA5E9), // 15. Hydration
    Color(0xFFD97706), // 16. Journaling
    Color(0xFF4ADE80), // 17. Digital Detox
    Color(0xFFA855F7), // 18. Skill Development
    Color(0xFFEAB308), // 19. Gratitude & Positivity
    Color(0xFFFB7185), // 20. Weekend Planning
  ];

  /// Get color scheme based on current brightness
  static AppColorScheme of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkScheme : lightScheme;
  }

  static const AppColorScheme darkScheme = AppColorScheme(
    isDark: true,
    bg: darkBg,
    surface: darkSurface,
    surface2: darkSurface2,
    border: darkBorder,
    text: darkText,
    muted: darkMuted,
    text3: darkText3,
    budgetBlue: darkBudgetBlue,
    budgetGreen: darkBudgetGreen,
    habitsIndigo: darkHabitsIndigo,
    habitsAccent: darkHabitsAccent,
    danger: darkDanger,
    success: darkSuccess,
    circleFill: darkCircleFill,
  );

  static const AppColorScheme lightScheme = AppColorScheme(
    isDark: false,
    bg: lightBg,
    surface: lightSurface,
    surface2: lightSurface2,
    border: lightBorder,
    text: lightText,
    muted: lightMuted,
    text3: lightText3,
    budgetBlue: lightBudgetBlue,
    budgetGreen: lightBudgetGreen,
    habitsIndigo: lightHabitsIndigo,
    habitsAccent: lightHabitsAccent,
    danger: lightDanger,
    success: lightSuccess,
    circleFill: lightCircleFill,
  );
}

/// Immutable ColorScheme container tailored to Level Up tokens.
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  final bool isDark;
  final Color bg;
  final Color surface;
  final Color surface2;
  final Color border;
  final Color text;
  final Color muted;
  final Color text3;
  final Color budgetBlue;
  final Color budgetGreen;
  final Color habitsIndigo;
  final Color habitsAccent;
  final Color danger;
  final Color success;
  final Color circleFill;

  const AppColorScheme({
    required this.isDark,
    required this.bg,
    required this.surface,
    required this.surface2,
    required this.border,
    required this.text,
    required this.muted,
    required this.text3,
    required this.budgetBlue,
    required this.budgetGreen,
    required this.habitsIndigo,
    required this.habitsAccent,
    required this.danger,
    required this.success,
    required this.circleFill,
  });

  @override
  ThemeExtension<AppColorScheme> copyWith({
    bool? isDark,
    Color? bg,
    Color? surface,
    Color? surface2,
    Color? border,
    Color? text,
    Color? muted,
    Color? text3,
    Color? budgetBlue,
    Color? budgetGreen,
    Color? habitsIndigo,
    Color? habitsAccent,
    Color? danger,
    Color? success,
    Color? circleFill,
  }) {
    return AppColorScheme(
      isDark: isDark ?? this.isDark,
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surface2: surface2 ?? this.surface2,
      border: border ?? this.border,
      text: text ?? this.text,
      muted: muted ?? this.muted,
      text3: text3 ?? this.text3,
      budgetBlue: budgetBlue ?? this.budgetBlue,
      budgetGreen: budgetGreen ?? this.budgetGreen,
      habitsIndigo: habitsIndigo ?? this.habitsIndigo,
      habitsAccent: habitsAccent ?? this.habitsAccent,
      danger: danger ?? this.danger,
      success: success ?? this.success,
      circleFill: circleFill ?? this.circleFill,
    );
  }

  @override
  ThemeExtension<AppColorScheme> lerp(ThemeExtension<AppColorScheme>? other, double t) {
    if (other is! AppColorScheme) return this;
    return AppColorScheme(
      isDark: t < 0.5 ? isDark : other.isDark,
      bg: Color.lerp(bg, other.bg, t) ?? bg,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      surface2: Color.lerp(surface2, other.surface2, t) ?? surface2,
      border: Color.lerp(border, other.border, t) ?? border,
      text: Color.lerp(text, other.text, t) ?? text,
      muted: Color.lerp(muted, other.muted, t) ?? muted,
      text3: Color.lerp(text3, other.text3, t) ?? text3,
      budgetBlue: Color.lerp(budgetBlue, other.budgetBlue, t) ?? budgetBlue,
      budgetGreen: Color.lerp(budgetGreen, other.budgetGreen, t) ?? budgetGreen,
      habitsIndigo: Color.lerp(habitsIndigo, other.habitsIndigo, t) ?? habitsIndigo,
      habitsAccent: Color.lerp(habitsAccent, other.habitsAccent, t) ?? habitsAccent,
      danger: Color.lerp(danger, other.danger, t) ?? danger,
      success: Color.lerp(success, other.success, t) ?? success,
      circleFill: Color.lerp(circleFill, other.circleFill, t) ?? circleFill,
    );
  }
}
