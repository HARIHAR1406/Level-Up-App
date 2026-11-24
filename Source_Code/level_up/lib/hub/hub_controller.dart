// =============================================================================
// Hub Controller - Business Logic for the Hub Screen
// =============================================================================
// Manages telemetry badge data (saved plan count, daily habit progress %),
// reads from Hive storage, and handles navigation to child modules.
// Automatically refreshes badge data when returning from any module.
// =============================================================================

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../core/constants/storage_keys.dart';
import '../core/models/enums.dart';
import '../budget_split/budget_split_screen.dart';
import '../habits/habits_screen.dart';

/// Controller managing telemetry badges, data synchronization, and navigation for the Hub screen.
class HubController extends ChangeNotifier {
  String _budgetBadge = 'No plans yet';
  String _habitsBadge = 'No habits yet';
  bool _isLoading = false;
  String? _errorMessage;

  String get budgetBadge => _budgetBadge;
  String get habitsBadge => _habitsBadge;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  HubController() {
    refreshBadges();
  }

  /// Refreshes telemetry badges from persistent Hive storage.
  Future<void> refreshBadges() async {
    _isLoading = true;
    notifyListeners();

    try {
      _budgetBadge = await readBudgetBadge();
      _habitsBadge = await readHabitsBadge();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Reads Hive 'bs_plans' box and counts saved plans.
  /// Formats: "No plans yet" / "1 saved plan" / "N saved plans"
  Future<String> readBudgetBadge() async {
    try {
      final box = Hive.isBoxOpen(StorageKeys.budgetSplitBox)
          ? Hive.box(StorageKeys.budgetSplitBox)
          : await Hive.openBox(StorageKeys.budgetSplitBox);

      int count = 0;
      final dynamic rawPlans = box.get(StorageKeys.budgetPlansListKey);
      if (rawPlans is List) {
        count = rawPlans.length;
      } else {
        // Fallback: check count of keys excluding metadata keys
        count = box.keys.where((k) => k != StorageKeys.budgetPlansListKey).length;
      }

      if (count <= 0) {
        return 'No plans yet';
      } else if (count == 1) {
        return '1 saved plan';
      } else {
        return '$count saved plans';
      }
    } catch (_) {
      return 'No plans yet';
    }
  }

  /// Reads Hive 'hab_state' box, checks lastResetDate expiry, and sums or averages done pct.
  /// Formats: "Done today: X%" / "No habits yet"
  Future<String> readHabitsBadge() async {
    try {
      final box = Hive.isBoxOpen(StorageKeys.habitsBox)
          ? Hive.box(StorageKeys.habitsBox)
          : await Hive.openBox(StorageKeys.habitsBox);

      // Check lastResetDate: if it's not today, habits have been reset
      final dynamic rawResetDate = box.get(StorageKeys.habitsResetAtKey);
      if (rawResetDate != null) {
        final now = DateTime.now();
        final todayInt = now.year * 10000 + now.month * 100 + now.day;

        if (rawResetDate is int) {
          // New format: YYYYMMDD integer
          if (rawResetDate < 30000000 && rawResetDate != todayInt) {
            // lastResetDate is a YYYYMMDD date and it's not today — habits are reset
            return 'Done today: 0%';
          }
          // Old format: epoch millis (very large int, > 30000000)
          if (rawResetDate > 30000000) {
            final resetTime = DateTime.fromMillisecondsSinceEpoch(rawResetDate);
            final startOfToday = DateTime(now.year, now.month, now.day);
            if (resetTime.isBefore(startOfToday)) {
              return 'Done today: 0%';
            }
          }
        } else {
          final resetTime = DateTime.tryParse(rawResetDate.toString());
          if (resetTime != null) {
            final startOfToday = DateTime(now.year, now.month, now.day);
            if (resetTime.isBefore(startOfToday)) {
              return 'Done today: 0%';
            }
          }
        }
      }

      final dynamic rawHabits = box.get(StorageKeys.habitsDailyKey);
      dynamic parsedData = rawHabits;
      if (rawHabits is String) {
        try {
          parsedData = jsonDecode(rawHabits);
        } catch (_) {
          parsedData = null;
        }
      }

      List<dynamic> habitsList = [];
      if (parsedData is Map && parsedData['habits'] is List) {
        habitsList = parsedData['habits'] as List<dynamic>;
      } else if (parsedData is List) {
        habitsList = parsedData;
      }

      if (habitsList.isEmpty) {
        return 'No habits yet';
      }

      double totalPct = 0.0;
      int activeHabits = 0;

      for (final item in habitsList) {
        if (item is Map) {
          activeHabits++;
          final isCompleted = item['done'] == true ||
              item['completed'] == true ||
              item['isCompleted'] == true;
          final weight = (item['pct'] as num?)?.toDouble() ??
              (item['weight'] as num?)?.toDouble() ??
              (item['percentage'] as num?)?.toDouble() ??
              (100.0 / habitsList.length);

          if (isCompleted) {
            totalPct += weight;
          }
        }
      }

      if (activeHabits == 0) return 'No habits yet';
      final rounded = totalPct.clamp(0.0, 100.0).round();
      return 'Done today: $rounded%';
    } catch (_) {
      return 'No habits yet';
    }
  }

  /// Navigation: pushes BudgetSplitScreen or HabitsScreen on circle tap.
  Future<void> openModule(BuildContext context, AppModule module) async {
    Widget targetScreen;
    switch (module) {
      case AppModule.budgetSplit:
        targetScreen = const BudgetSplitScreen();
        break;
      case AppModule.habitsAtPercentage:
        targetScreen = const HabitsScreen();
        break;
    }

    await Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        reverseTransitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: const Cubic(0.16, 1.0, 0.3, 1.0), // module-open-transition from CSS
          );
          return FadeTransition(
            opacity: curved,
            child: child,
          );
        },
      ),
    );

    // Refresh telemetry badges upon returning from module
    refreshBadges();
  }

  /// Sets error state (e.g. for error view testing / display)
  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// Clears active error state
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
