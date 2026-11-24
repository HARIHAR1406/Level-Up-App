// =============================================================================
// Habits - Daily Reset Service
// =============================================================================
// Midnight reset logic that clears habit completion status for a new day.
// =============================================================================

import '../models/habit_state.dart';

/// Service managing the daily automatic reset cycle for habits.
///
/// The reset is anchored to the user's **local calendar day boundary**
/// (midnight, 00:00:00), not a rolling 24-hour window.
///
/// How it works:
/// - [HabitState.lastResetDate] stores the YYYYMMDD integer of the local date
///   on which the most recent daily reset was performed.
/// - Every second, the provider calls [checkAndReset]. If today's local date
///   is different from (greater than) [lastResetDate], all habits' [done]
///   status is set to `false` and [lastResetDate] is updated to today.
/// - The countdown timer shows the time remaining until the next local
///   midnight, ensuring users see an accurate indication of when their
///   progress will refresh.
///
/// This design correctly handles:
/// - Different device time zones (always uses device-local time).
/// - Travel across time zones (midnight recalculates based on the new zone).
/// - App being closed over midnight and reopened later.
/// - Multiple missed days (the date comparison is `!=`, not `+1`).
/// - No premature resets (strict date comparison, not duration arithmetic).
/// - No duplicate resets (once [lastResetDate] equals today, no further reset
///   until tomorrow).
class ResetService {
  /// Checks whether a new local calendar day has begun since the last reset.
  ///
  /// If the local date today (YYYYMMDD) differs from [state.lastResetDate],
  /// all habits' [done] status is reset to `false` and [lastResetDate] is
  /// updated to today's date.
  ///
  /// Returns the updated [HabitState], or `null` if no reset was triggered.
  HabitState? checkAndReset(HabitState state) {
    final today = HabitState.todayDateInt();

    if (today != state.lastResetDate) {
      final uncheckedHabits =
          state.habits.map((h) => h.copyWith(done: false)).toList();
      return state.copyWith(
        habits: uncheckedHabits,
        lastResetDate: today,
      );
    }
    return null;
  }

  /// Calculates the [Duration] remaining until the next local midnight.
  Duration timeUntilReset() {
    final now = DateTime.now();
    // Next midnight: today's date + 1 day, at 00:00:00 local time.
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final diff = tomorrow.difference(now);
    return diff.isNegative ? Duration.zero : diff;
  }

  /// Format countdown as "Resets in 08h 32m 14s" matching the design spec.
  String formatCountdown(Duration duration) {
    final totalSeconds = duration.inSeconds;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    final hStr = hours.toString().padLeft(2, '0');
    final mStr = minutes.toString().padLeft(2, '0');
    final sStr = seconds.toString().padLeft(2, '0');

    return 'Resets in ${hStr}h ${mStr}m ${sStr}s';
  }

  /// Compact format "08h 32m" for compact spaces.
  String formatCountdownShort(Duration duration) {
    final totalSeconds = duration.inSeconds;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;

    final hStr = hours.toString().padLeft(2, '0');
    final mStr = minutes.toString().padLeft(2, '0');

    return '${hStr}h ${mStr}m';
  }
}
