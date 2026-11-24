// =============================================================================
// Level Up - Storage Keys
// =============================================================================
// Hive box names and key constants for persistent local storage.
// Boxes: lv_theme (settings), bs_plans (budgets), hab_state (habits).
// =============================================================================

/// Storage box names and keys for Hive persistence across Level Up.
class StorageKeys {
  StorageKeys._();

  // ---------------------------------------------------------------------------
  // Hive Box Names
  // ---------------------------------------------------------------------------
  /// Box name for app theme and settings
  static const String themeBox = 'lv_theme';

  /// Box name for BudgetSplit saved plans and state
  static const String budgetSplitBox = 'bs_plans';

  /// Box name for Habits At Percentage state, streaks and daily logs
  static const String habitsBox = 'hab_state';

  // ---------------------------------------------------------------------------
  // Keys inside boxes
  // ---------------------------------------------------------------------------
  /// Theme mode string key ('dark', 'light', 'system')
  static const String themeModeKey = 'theme_mode';

  /// High contrast mode boolean
  static const String highContrastKey = 'high_contrast';

  /// Reduced motion boolean
  static const String reducedMotionKey = 'reduced_motion';

  /// Plans list key in bs_plans
  static const String budgetPlansListKey = 'plans_list';

  /// Habits state key in hab_state
  static const String habitsDailyKey = 'habits_daily';

  /// Habits reset timestamp
  static const String habitsResetAtKey = 'reset_at';
}
