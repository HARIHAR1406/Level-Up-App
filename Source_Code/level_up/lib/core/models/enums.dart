// =============================================================================
// Core Models - Enumerations
// =============================================================================
// App module enum definitions (BudgetSplit, HabitsAtPercentage).
// =============================================================================

/// Enumeration of tools/modules hosted within the Level Up launcher.
enum AppModule {
  /// BudgetSplit - Group expense splitter and financial planner
  budgetSplit,

  /// Habits At Percentage - Calibrated daily percentage-weighted habits tracker
  habitsAtPercentage,
}

extension AppModuleExtension on AppModule {
  String get displayName {
    switch (this) {
      case AppModule.budgetSplit:
        return 'BudgetSplit';
      case AppModule.habitsAtPercentage:
        return 'Habits @ %';
    }
  }

  String get description {
    switch (this) {
      case AppModule.budgetSplit:
        return 'Plan the money. Group expense splitting and budget allocation.';
      case AppModule.habitsAtPercentage:
        return 'Track the habits. 100% daily calibrated habit engine.';
    }
  }

  String get routePath {
    switch (this) {
      case AppModule.budgetSplit:
        return '/budget-split';
      case AppModule.habitsAtPercentage:
        return '/habits';
    }
  }
}
