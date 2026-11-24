// =============================================================================
// Core Utility - Tagline Rotator
// =============================================================================
// Rotating motivational taglines for the hub header section.
// =============================================================================

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';

/// Rotates between inspirational brand taglines at configured intervals.
class TaglineRotator {
  static const List<String> taglines = [
    'Small tools. Steady progress.',
    'Plan the money. Track the habits.',
    'One step up at a time.',
  ];

  int _currentIndex = 0;
  Timer? _timer;
  final ValueNotifier<String> currentTagline = ValueNotifier<String>(taglines[0]);

  int get currentIndex => _currentIndex;

  /// Starts the automatic rotation timer (defaults to 4500ms).
  void start({Duration duration = AppConstants.durationTagline}) {
    stop();
    _timer = Timer.periodic(duration, (_) {
      next();
    });
  }

  /// Manually advance to the next tagline.
  String next() {
    _currentIndex = (_currentIndex + 1) % taglines.length;
    final nextText = taglines[_currentIndex];
    currentTagline.value = nextText;
    return nextText;
  }

  /// Cancels the rotation timer.
  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  /// Clean up resources
  void dispose() {
    stop();
    currentTagline.dispose();
  }

  /// Get tagline by index
  static String getTagline(int index) {
    return taglines[index % taglines.length];
  }
}
