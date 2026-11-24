// =============================================================================
// Level Up Design System - Constants
// =============================================================================
// Spacing grid (4px base), border radii, animation durations, curves,
// dimensions, and touch targets used consistently throughout the app.
// =============================================================================

import 'package:flutter/material.dart';

/// Design system constants including spacing, radii, animation timings, and dimensions.
class AppConstants {
  AppConstants._();

  // ---------------------------------------------------------------------------
  // Spacing (4px Base Grid)
  // ---------------------------------------------------------------------------
  static const double space2xs = 2.0;
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 24.0;
  static const double spaceXl = 32.0;
  static const double space2xl = 40.0;
  static const double space3xl = 48.0;

  // ---------------------------------------------------------------------------
  // Border Radii
  // ---------------------------------------------------------------------------
  /// Switchboard main frame container radius
  static const double radiusSwitchboard = 28.0;

  /// Standard content cards, ledgers, summary blocks
  static const double radiusCard = 16.0;

  /// Buttons, interactive elements
  static const double radiusButton = 12.0;

  /// Form inputs, text fields, chips
  static const double radiusInput = 10.0;
  static const double radiusInputSm = 8.0;

  /// Modal bottom sheets top corners
  static const double radiusBottomSheet = 22.0;

  /// Status badges, pills, circles
  static const double radiusPill = 9999.0;

  // BorderRadius objects for convenience
  static const BorderRadius borderRadiusSwitchboard = BorderRadius.all(Radius.circular(radiusSwitchboard));
  static const BorderRadius borderRadiusCard = BorderRadius.all(Radius.circular(radiusCard));
  static const BorderRadius borderRadiusInput = BorderRadius.all(Radius.circular(radiusInput));
  static const BorderRadius borderRadiusBottomSheet = BorderRadius.vertical(top: Radius.circular(radiusBottomSheet));
  static const BorderRadius borderRadiusPill = BorderRadius.all(Radius.circular(radiusPill));

  // ---------------------------------------------------------------------------
  // Animation Durations & Curves
  // ---------------------------------------------------------------------------
  /// Module transition / screen opening
  static const Duration durationModuleOpen = Duration(milliseconds: 450);

  /// Circle button scale on press/hover
  static const Duration durationCircleScale = Duration(milliseconds: 180);

  /// Tagline rotation cycle
  static const Duration durationTagline = Duration(milliseconds: 4500);

  /// Tagline text fade in/out
  static const Duration durationTaglineFade = Duration(milliseconds: 300);

  /// Connecting wire travelling pulse loop
  static const Duration durationWirePulse = Duration(milliseconds: 3200);

  /// Toast display visibility duration
  static const Duration durationToast = Duration(milliseconds: 2300);

  /// Standard micro-interaction curve
  static const Curve curveSpring = Curves.easeOutBack;
  static const Curve curveSmooth = Curves.easeInOut;

  // ---------------------------------------------------------------------------
  // Dimensions & Touch Targets
  // ---------------------------------------------------------------------------
  /// Minimum accessible touch target (42px)
  static const double minTouchTarget = 42.0;

  /// Primary CTA height
  static const double ctaHeight = 48.0;

  /// Module circular button outer diameter
  static const double moduleCircleSize = 124.0;

  /// Connecting wire thickness
  static const double wireThickness = 3.0;

  /// Constrained mobile width on larger displays
  static const double maxViewportWidth = 430.0;
}
