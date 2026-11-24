// =============================================================================
// Design System - Theme Provider
// =============================================================================
// ChangeNotifier for dark/light mode toggling with Hive persistence.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/storage_keys.dart';

/// Provider for managing app theme (Dark, Light, System) and persisting with Hive.
class ThemeProvider extends ChangeNotifier {
  late Box _box;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider() {
    _init();
  }

  ThemeMode get themeMode => _themeMode;

  /// Returns true if currently active mode is dark (evaluating system brightness if mode is system).
  bool isDark(BuildContext? context) {
    if (_themeMode == ThemeMode.dark) return true;
    if (_themeMode == ThemeMode.light) return false;
    if (context != null) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
  }

  void _init() {
    if (Hive.isBoxOpen(StorageKeys.themeBox)) {
      _box = Hive.box(StorageKeys.themeBox);
      _loadTheme();
    } else {
      // If box is opened asynchronously in main.dart
      _themeMode = ThemeMode.system;
    }
  }

  /// Initialize with an already opened box
  void attachBox(Box box) {
    _box = box;
    _loadTheme();
  }

  void _loadTheme() {
    final savedMode = _box.get(StorageKeys.themeModeKey) as String?;
    if (savedMode == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (savedMode == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  /// Set explicit ThemeMode ('system', 'light', 'dark')
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    if (Hive.isBoxOpen(StorageKeys.themeBox)) {
      final box = Hive.box(StorageKeys.themeBox);
      String value;
      switch (mode) {
        case ThemeMode.dark:
          value = 'dark';
          break;
        case ThemeMode.light:
          value = 'light';
          break;
        case ThemeMode.system:
          value = 'system';
          break;
      }
      await box.put(StorageKeys.themeModeKey, value);
    }
  }

  /// Toggle between Dark and Light mode
  Future<void> toggleTheme(BuildContext context) async {
    final currentlyDark = isDark(context);
    final nextMode = currentlyDark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(nextMode);
  }
}
