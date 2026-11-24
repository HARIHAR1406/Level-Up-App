// =============================================================================
// Habits - State Model
// =============================================================================
// Serializable daily habit state for Hive persistence including habits list and reset date.
// =============================================================================

import 'habit.dart';
import 'habit_category.dart';

/// Complete persistent state for the Habits At Percentage module.
class HabitState {
  final List<Habit> habits;
  final List<HabitCategory> categories;
  final String theme;

  /// The local calendar date (YYYYMMDD integer) on which the last daily reset
  /// was performed. Used to determine whether a new calendar day has begun.
  /// Example: November 13, 2026 → 20261113.
  final int lastResetDate;

  final int nextId;

  const HabitState({
    required this.habits,
    required this.categories,
    required this.theme,
    required this.lastResetDate,
    required this.nextId,
  });

  /// Converts a [DateTime] to a YYYYMMDD integer in the device's local time zone.
  static int dateToInt(DateTime dt) {
    final local = dt.toLocal();
    return local.year * 10000 + local.month * 100 + local.day;
  }

  /// Returns today's local date as a YYYYMMDD integer.
  static int todayDateInt() => dateToInt(DateTime.now());

  /// Factory providing default starting state for a fresh installation.
  /// Starts with zero habits and zero reminders, allowing users to create
  /// their own routine from a clean slate.
  factory HabitState.initial() {
    final today = HabitState.todayDateInt();

    return HabitState(
      habits: const <Habit>[],
      categories: HabitCategory.defaultCategories,
      theme: 'light',
      lastResetDate: today,
      nextId: 1,
    );
  }

  HabitState copyWith({
    List<Habit>? habits,
    List<HabitCategory>? categories,
    String? theme,
    int? lastResetDate,
    int? nextId,
  }) {
    return HabitState(
      habits: habits ?? this.habits,
      categories: categories ?? this.categories,
      theme: theme ?? this.theme,
      lastResetDate: lastResetDate ?? this.lastResetDate,
      nextId: nextId ?? this.nextId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'habits': habits.map((h) => h.toMap()).toList(),
      'categories': categories.map((c) => c.toMap()).toList(),
      'theme': theme,
      'lastResetDate': lastResetDate,
      'nextId': nextId,
    };
  }

  factory HabitState.fromMap(Map<dynamic, dynamic> map) {
    final habitsRaw = map['habits'] as List<dynamic>? ?? [];
    final habits = habitsRaw
        .whereType<Map<dynamic, dynamic>>()
        .map((h) => Habit.fromMap(h))
        .toList();

    final categoriesRaw = map['categories'] as List<dynamic>? ?? [];
    final categories = categoriesRaw.isEmpty
        ? HabitCategory.defaultCategories
        : categoriesRaw
            .whereType<Map<dynamic, dynamic>>()
            .map((c) => HabitCategory.fromMap(c))
            .toList();

    // Migration: support old 'resetAt' (epoch millis) field for backward
    // compatibility. If 'lastResetDate' is absent but 'resetAt' exists,
    // derive the last reset date from the old value (the day before the
    // scheduled reset). Otherwise fall back to today's date.
    int lastResetDate;
    if (map.containsKey('lastResetDate') && map['lastResetDate'] != null) {
      lastResetDate = (map['lastResetDate'] as num).toInt();
    } else if (map.containsKey('resetAt') && map['resetAt'] != null) {
      // Old format: resetAt was the next scheduled epoch-millis reset.
      // The last reset happened roughly 24h before that.
      final oldResetAt = (map['resetAt'] as num).toInt();
      final oldResetDateTime = DateTime.fromMillisecondsSinceEpoch(
        oldResetAt - 86400000,
        isUtc: false,
      );
      lastResetDate = HabitState.dateToInt(oldResetDateTime);
    } else {
      lastResetDate = HabitState.todayDateInt();
    }

    return HabitState(
      habits: habits,
      categories: categories,
      theme: map['theme'] as String? ?? 'light',
      lastResetDate: lastResetDate,
      nextId: (map['nextId'] as num?)?.toInt() ?? (habits.length + 1),
    );
  }
}
