// =============================================================================
// Habits - State Management
// =============================================================================
// ChangeNotifier managing habit CRUD, completion toggling, and daily reset logic.
// =============================================================================

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/habit.dart';
import '../models/habit_category.dart';
import '../models/habit_state.dart';
import '../services/habits_storage.dart';
import '../services/reset_service.dart';
import '../utils/habit_calculator.dart';

/// Central state management for the Habits At Percentage module.
class HabitsProvider extends ChangeNotifier {
  final HabitsStorage _storage;
  final ResetService _resetService;

  late HabitState _state;
  String _selectedCategory = 'all';
  int _currentTab = 0; // 0: Action, 1: Create, 2: Visual
  Timer? _tickerTimer;

  HabitsProvider({
    HabitsStorage? storage,
    ResetService? resetService,
  })  : _storage = storage ?? HabitsStorage(),
        _resetService = resetService ?? ResetService() {
    _state = _storage.loadState();
    _checkReset();
    _startTicker();
  }

  // ---------------------------------------------------------------------------
  // Getters
  // ---------------------------------------------------------------------------
  HabitState get state => _state;
  List<Habit> get habits => _state.habits;
  List<HabitCategory> get categories => _state.categories;
  int get resetAt => _state.lastResetDate;
  String get selectedCategory => _selectedCategory;
  int get currentTab => _currentTab;

  /// Habits filtered by active category filter, sorted by createdAt ascending
  List<Habit> get filteredHabits {
    final sorted = List<Habit>.from(_state.habits)
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    if (_selectedCategory == 'all') {
      return sorted;
    }

    return sorted.where((h) {
      if (h.catIdx >= 0 && h.catIdx < _state.categories.length) {
        final cat = _state.categories[h.catIdx];
        return cat.name.toLowerCase() == _selectedCategory.toLowerCase();
      }
      return false;
    }).toList();
  }

  /// Categories that have at least one assigned habit (for Action filter chips)
  List<HabitCategory> get activeFilterCategories {
    final Set<int> usedIndices = _state.habits.map((h) => h.catIdx).toSet();
    final List<HabitCategory> result = [];
    for (final idx in usedIndices) {
      if (idx >= 0 && idx < _state.categories.length) {
        result.add(_state.categories[idx]);
      }
    }
    return result;
  }

  double get completedPct => HabitCalculator.completedPercentage(_state.habits);
  double get remainingPct => HabitCalculator.remainingPercentage(_state.habits);
  double get totalPct => HabitCalculator.totalPercentage(_state.habits);

  int get completedCount => HabitCalculator.completedCount(_state.habits);
  int get pendingCount => HabitCalculator.pendingCount(_state.habits);
  int get totalCount => _state.habits.length;

  List<CategoryBreakdown> get categoryBreakdowns =>
      HabitCalculator.categoryBreakdowns(_state.habits, _state.categories);

  Duration get durationUntilReset => _resetService.timeUntilReset();
  String get countdownString => _resetService.formatCountdown(durationUntilReset);

  // ---------------------------------------------------------------------------
  // Reset Engine & Ticker
  // ---------------------------------------------------------------------------
  void _startTicker() {
    _tickerTimer?.cancel();
    _tickerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final changed = _checkReset();
      if (!changed) {
        notifyListeners(); // Refresh countdown string every second
      }
    });
  }

  bool _checkReset() {
    final updated = _resetService.checkAndReset(_state);
    if (updated != null) {
      _state = updated;
      _storage.saveState(_state);
      notifyListeners();
      return true;
    }
    return false;
  }

  // ---------------------------------------------------------------------------
  // Navigation & Filtering
  // ---------------------------------------------------------------------------
  void setCurrentTab(int tab) {
    if (_currentTab != tab) {
      _currentTab = tab;
      notifyListeners();
    }
  }

  void setCategoryFilter(String categoryName) {
    _selectedCategory = categoryName;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Habit CRUD Actions
  // ---------------------------------------------------------------------------
  Future<void> toggleHabit(int id) async {
    final updatedList = _state.habits.map((h) {
      if (h.id == id) {
        return h.copyWith(done: !h.done);
      }
      return h;
    }).toList();

    _state = _state.copyWith(habits: updatedList);
    await _storage.saveState(_state);
    notifyListeners();
  }

  Future<bool> addHabit({
    required String name,
    required double pct,
    required String from,
    required String to,
    required int catIdx,
  }) async {
    if (name.trim().isEmpty || pct <= 0) return false;

    final newHabit = Habit(
      id: _state.nextId,
      name: name.trim(),
      pct: pct,
      from: from,
      to: to,
      catIdx: catIdx,
      done: false,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    final updatedHabits = List<Habit>.from(_state.habits)..add(newHabit);
    _state = _state.copyWith(
      habits: updatedHabits,
      nextId: _state.nextId + 1,
    );

    await _storage.saveState(_state);
    notifyListeners();
    return true;
  }

  Future<bool> updateHabit({
    required int id,
    required String name,
    required double pct,
    required String from,
    required String to,
    int? catIdx,
  }) async {
    if (name.trim().isEmpty || pct <= 0) return false;

    final updatedHabits = _state.habits.map((h) {
      if (h.id == id) {
        return h.copyWith(
          name: name.trim(),
          pct: pct,
          from: from,
          to: to,
          catIdx: catIdx ?? h.catIdx,
        );
      }
      return h;
    }).toList();

    _state = _state.copyWith(habits: updatedHabits);
    await _storage.saveState(_state);
    notifyListeners();
    return true;
  }

  Future<void> deleteHabit(int id) async {
    final updatedHabits = _state.habits.where((h) => h.id != id).toList();
    _state = _state.copyWith(habits: updatedHabits);
    await _storage.saveState(_state);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Category CRUD Actions
  // ---------------------------------------------------------------------------
  Future<bool> addCustomCategory(String name, String color) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return false;

    // Check if category name already exists
    if (_state.categories.any((c) => c.name.toLowerCase() == trimmed.toLowerCase())) {
      return false;
    }

    final newCat = HabitCategory(
      name: trimmed,
      color: color,
      custom: true,
    );

    final updatedCategories = List<HabitCategory>.from(_state.categories)..add(newCat);
    _state = _state.copyWith(categories: updatedCategories);
    await _storage.saveState(_state);
    notifyListeners();
    return true;
  }

  Future<bool> updateCategory(int index, String name, String color) async {
    if (index < 0 || index >= _state.categories.length) return false;
    final trimmed = name.trim();
    if (trimmed.isEmpty) return false;

    final updatedList = List<HabitCategory>.from(_state.categories);
    final existing = updatedList[index];
    updatedList[index] = existing.copyWith(
      name: trimmed,
      color: color,
    );

    _state = _state.copyWith(categories: updatedList);
    await _storage.saveState(_state);
    notifyListeners();
    return true;
  }

  /// Delete a custom category if no habits are currently assigned to it.
  /// If assigned, returns false (or error condition).
  Future<bool> deleteCustomCategory(int index) async {
    if (index < 0 || index >= _state.categories.length) return false;
    final target = _state.categories[index];
    if (!target.custom) return false; // Cannot delete 20 core presets

    // Check if any habit uses this category index
    final hasHabits = _state.habits.any((h) => h.catIdx == index);
    if (hasHabits) {
      return false; // Constraint: cannot delete category in use
    }

    // Remove category and shift down catIdx of habits referring to indices above it
    final updatedCategories = List<HabitCategory>.from(_state.categories)..removeAt(index);
    final updatedHabits = _state.habits.map((h) {
      if (h.catIdx > index) {
        return h.copyWith(catIdx: h.catIdx - 1);
      }
      return h;
    }).toList();

    _state = _state.copyWith(
      categories: updatedCategories,
      habits: updatedHabits,
    );
    await _storage.saveState(_state);
    notifyListeners();
    return true;
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    super.dispose();
  }
}
