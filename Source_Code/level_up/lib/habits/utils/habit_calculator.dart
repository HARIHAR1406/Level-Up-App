// =============================================================================
// Habits Utility - Calculator
// =============================================================================
// Math utilities for habit progress percentage and weighted completion tracking.
// =============================================================================

import '../models/habit.dart';
import '../models/habit_category.dart';

/// Structured metrics summary for a specific category.
class CategoryBreakdown {
  final int catIdx;
  final HabitCategory category;
  final double totalPct;
  final double completedPct;
  final int totalCount;
  final int completedCount;

  const CategoryBreakdown({
    required this.catIdx,
    required this.category,
    required this.totalPct,
    required this.completedPct,
    required this.totalCount,
    required this.completedCount,
  });

  bool get isAllDone => totalCount > 0 && completedCount == totalCount;
  bool get hasAnyDone => completedPct > 0;
  double get pendingPct => (totalPct - completedPct).clamp(0.0, totalPct);
}

/// Mathematical computation engine for Habits at Percentage.
class HabitCalculator {
  HabitCalculator._();

  /// Sum of percentage values of all completed habits.
  static double completedPercentage(List<Habit> habits) {
    double sum = 0.0;
    for (final h in habits) {
      if (h.done) {
        sum += h.pct;
      }
    }
    return sum;
  }

  /// Sum of percentage values of all pending habits.
  static double remainingPercentage(List<Habit> habits) {
    double sum = 0.0;
    for (final h in habits) {
      if (!h.done) {
        sum += h.pct;
      }
    }
    return sum;
  }

  /// Total sum of all assigned habit percentages.
  static double totalPercentage(List<Habit> habits) {
    double sum = 0.0;
    for (final h in habits) {
      sum += h.pct;
    }
    return sum;
  }

  /// Count of completed habits.
  static int completedCount(List<Habit> habits) {
    return habits.where((h) => h.done).length;
  }

  /// Count of pending habits.
  static int pendingCount(List<Habit> habits) {
    return habits.where((h) => !h.done).length;
  }

  /// Computes category breakdown list for categories that have at least one habit.
  static List<CategoryBreakdown> categoryBreakdowns(
    List<Habit> habits,
    List<HabitCategory> categories,
  ) {
    final Map<int, List<Habit>> grouped = {};
    for (final habit in habits) {
      grouped.putIfAbsent(habit.catIdx, () => []).add(habit);
    }

    final List<CategoryBreakdown> list = [];
    for (final entry in grouped.entries) {
      final idx = entry.key;
      final groupHabits = entry.value;
      if (idx < 0 || idx >= categories.length) continue;

      final cat = categories[idx];
      double catTotal = 0.0;
      double catCompleted = 0.0;
      int doneCount = 0;

      for (final h in groupHabits) {
        catTotal += h.pct;
        if (h.done) {
          catCompleted += h.pct;
          doneCount++;
        }
      }

      list.add(
        CategoryBreakdown(
          catIdx: idx,
          category: cat,
          totalPct: catTotal,
          completedPct: catCompleted,
          totalCount: groupHabits.length,
          completedCount: doneCount,
        ),
      );
    }

    return list;
  }

  /// Format decimal percentage smoothly: 20 -> "20%", 0.5 -> "0.5%", 2.75 -> "2.75%".
  static String formatPct(double value) {
    if (value % 1 == 0) {
      return '${value.toInt()}%';
    } else {
      // Show up to 2 decimal places without trailing zeroes
      String s = value.toStringAsFixed(2);
      if (s.endsWith('0')) s = s.substring(0, s.length - 1);
      return '$s%';
    }
  }

  /// Format decimal percentage number only (without %): 20 -> "20", 0.5 -> "0.5".
  static String formatPctNumber(double value) {
    if (value % 1 == 0) {
      return '${value.toInt()}';
    } else {
      String s = value.toStringAsFixed(2);
      if (s.endsWith('0')) s = s.substring(0, s.length - 1);
      return s;
    }
  }
}
