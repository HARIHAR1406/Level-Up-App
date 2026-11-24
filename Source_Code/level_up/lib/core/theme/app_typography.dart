// =============================================================================
// Design System - Typography
// =============================================================================
// Text style factory methods using Google Fonts (Roboto, Inter).
// =============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized Typography system for Level Up.
/// Uses DM Sans for human-scale text and DM Mono / JetBrains Mono / Space Mono for data/badges.
class AppTypography {
  AppTypography._();

  // ---------------------------------------------------------------------------
  // Headings & Display (DM Sans)
  // ---------------------------------------------------------------------------
  static TextStyle headlineXl({Color? color}) => GoogleFonts.dmSans(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 48 / 40,
        letterSpacing: -1.2, // -0.03em
        color: color,
      );

  static TextStyle headlineXlMobile({Color? color}) => GoogleFonts.dmSans(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        height: 38 / 30,
        letterSpacing: -0.6, // -0.02em
        color: color,
      );

  static TextStyle headlineLg({Color? color}) => GoogleFonts.dmSans(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 36 / 28,
        letterSpacing: -0.56,
        color: color,
      );

  static TextStyle headlineMd({Color? color}) => GoogleFonts.dmSans(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 28 / 22,
        letterSpacing: -0.33,
        color: color,
      );

  static TextStyle headlineSm({Color? color}) => GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 22 / 16,
        letterSpacing: -0.16,
        color: color,
      );

  static TextStyle titleSm({Color? color}) => GoogleFonts.dmSans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 20 / 15,
        letterSpacing: -0.15,
        color: color,
      );

  // ---------------------------------------------------------------------------
  // Body Text (DM Sans)
  // ---------------------------------------------------------------------------
  static TextStyle bodyLg({Color? color, FontWeight fontWeight = FontWeight.w400}) => GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: fontWeight,
        height: 24 / 16,
        color: color,
      );

  static TextStyle bodyMd({Color? color, FontWeight fontWeight = FontWeight.w400}) => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: fontWeight,
        height: 20 / 14,
        color: color,
      );

  static TextStyle bodySm({Color? color, FontWeight fontWeight = FontWeight.w400}) => GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: fontWeight,
        height: 16 / 12,
        color: color,
      );

  static TextStyle bodyXs({Color? color, FontWeight fontWeight = FontWeight.w400}) => GoogleFonts.dmSans(
        fontSize: 10,
        fontWeight: fontWeight,
        height: 14 / 10,
        letterSpacing: 0.4,
        color: color,
      );

  static TextStyle tagline({Color? color}) => GoogleFonts.dmSans(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        height: 18 / 13,
        color: color,
      );

  // ---------------------------------------------------------------------------
  // Monospaced Numbers & Metrics (JetBrains Mono & DM Mono)
  // ---------------------------------------------------------------------------
  static TextStyle metricDisplay({Color? color}) => GoogleFonts.jetBrainsMono(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 40 / 36,
        letterSpacing: -1.0,
        color: color,
      );

  static TextStyle metricLg({Color? color}) => GoogleFonts.jetBrainsMono(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 34 / 28,
        letterSpacing: -0.84,
        color: color,
      );

  static TextStyle metricMd({Color? color}) => GoogleFonts.jetBrainsMono(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 26 / 20,
        letterSpacing: -0.4,
        color: color,
      );

  static TextStyle metricSm({Color? color}) => GoogleFonts.jetBrainsMono(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 18 / 14,
        color: color,
      );

  // ---------------------------------------------------------------------------
  // Badges & Telemetry (JetBrains Mono / DM Mono)
  // ---------------------------------------------------------------------------
  static TextStyle codeBadge({Color? color}) => GoogleFonts.jetBrainsMono(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 14 / 11,
        letterSpacing: 0.55,
        color: color,
      );

  static TextStyle labelMono({Color? color, FontWeight fontWeight = FontWeight.w500}) => GoogleFonts.dmMono(
        fontSize: 12,
        fontWeight: fontWeight,
        height: 16 / 12,
        letterSpacing: 0.24,
        color: color,
      );

  static TextStyle statusBadge({Color? color}) => GoogleFonts.dmMono(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 15 / 12,
        letterSpacing: 0.2,
        color: color,
      );

  /// Generates TextTheme for Flutter ThemeData
  static TextTheme createTextTheme(Color defaultTextColor, Color mutedTextColor) {
    return TextTheme(
      displayLarge: headlineXl(color: defaultTextColor),
      displayMedium: headlineXlMobile(color: defaultTextColor),
      displaySmall: headlineLg(color: defaultTextColor),
      headlineMedium: headlineMd(color: defaultTextColor),
      headlineSmall: headlineSm(color: defaultTextColor),
      titleMedium: titleSm(color: defaultTextColor),
      bodyLarge: bodyLg(color: defaultTextColor),
      bodyMedium: bodyMd(color: defaultTextColor),
      bodySmall: bodySm(color: mutedTextColor),
      labelMedium: labelMono(color: mutedTextColor),
      labelSmall: codeBadge(color: mutedTextColor),
    );
  }
}
