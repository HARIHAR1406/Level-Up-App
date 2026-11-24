// =============================================================================
// Core Models - Module Configuration
// =============================================================================
// Module metadata and configuration data model.
// =============================================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'enums.dart';

/// Callback signature for dynamic telemetry badge readers
typedef BadgeReader = FutureOr<String> Function();

/// Configuration and routing descriptors for a Level Up switchboard module.
class ModuleConfig {
  /// Module identifier
  final AppModule module;

  /// Display title shown in launcher switchboard
  final String title;

  /// Subtitle or short tagline
  final String subtitle;

  /// Asynchronous or synchronous telemetry badge resolver
  final BadgeReader badgeReader;

  /// Builder for navigating into the target module screen
  final WidgetBuilder? screenBuilder;

  /// Primary accent color for module halos and rings
  final Color? accentColor;

  const ModuleConfig({
    required this.module,
    required this.title,
    this.subtitle = '',
    required this.badgeReader,
    this.screenBuilder,
    this.accentColor,
  });
}
