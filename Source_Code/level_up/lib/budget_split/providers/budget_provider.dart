// =============================================================================
// BudgetSplit - State Management
// =============================================================================
// ChangeNotifier managing budget calculations, category CRUD, and storage operations.
// =============================================================================

import 'package:flutter/foundation.dart';
import '../models/budget_category.dart';
import '../models/budget_plan.dart';
import '../services/budget_storage.dart';
import '../utils/budget_calculator.dart';

/// Provider for BudgetSplit reactive state management.
/// Handles live recalculations on every keystroke, category manipulation,
/// local Hive persistence, and plan lifecycle operations.
class BudgetProvider extends ChangeNotifier {
  final BudgetStorage _storage;

  BudgetProvider({BudgetStorage? storage}) : _storage = storage ?? BudgetStorage() {
    _initDefaults();
    loadSavedPlans();
  }

  // --- State Variables ---
  String _totalBudgetInput = '';
  double _totalBudget = 0.0;
  String _planName = '';
  String? _loadedPlanId;
  List<BudgetCategory> _categories = [];
  List<BudgetPlan> _savedPlans = [];
  bool _isSavedPlansExpanded = true;
  bool _isLoadingPlans = false;

  // --- Getters ---
  String get totalBudgetInput => _totalBudgetInput;
  double get totalBudget => _totalBudget;
  String get planName => _planName;
  String? get loadedPlanId => _loadedPlanId;
  List<BudgetCategory> get categories => List.unmodifiable(_categories);
  List<BudgetPlan> get savedPlans => List.unmodifiable(_savedPlans);
  bool get isSavedPlansExpanded => _isSavedPlansExpanded;
  bool get isLoadingPlans => _isLoadingPlans;

  int get categoryCount => _categories.length;

  /// Sum of all category percentage allocations
  double get totalAllocatedPct =>
      BudgetCalculator.calculateTotalAllocatedPercentage(_categories);

  /// Sum of all category rupee allocations
  double get totalAllocatedAmount =>
      BudgetCalculator.calculateTotalAllocatedAmount(_totalBudget, _categories);

  /// Remaining amount in rupees (negative if over-budget)
  double get remainingAmount =>
      BudgetCalculator.calculateRemainingAmount(_totalBudget, totalAllocatedAmount);

  /// Whether the current allocation exceeds 100%
  bool get isOverBudget => BudgetCalculator.isOverBudget(totalAllocatedPct);

  /// Excess percentage over 100%
  double get overBudgetPct => isOverBudget ? (totalAllocatedPct - 100.0) : 0.0;

  /// Excess rupee amount over total budget
  double get overBudgetAmount =>
      isOverBudget ? (totalAllocatedAmount - _totalBudget) : 0.0;

  /// Progress bar fill fraction between 0.0 and 1.0
  double get progressBarFillFraction {
    if (totalAllocatedPct <= 0) return 0.0;
    if (totalAllocatedPct > 100.0) return 1.0;
    return totalAllocatedPct / 100.0;
  }

  /// Check if any category has a non-zero percentage
  bool get hasAllocatedCategories =>
      _categories.any((c) => c.percentageValue > 0);

  /// Check if the state is in an empty / fresh slate condition
  bool get isEmptyInitialState =>
      _totalBudget <= 0 && !hasAllocatedCategories && _planName.trim().isEmpty;

  // --- Initializer ---
  void _initDefaults() {
    _totalBudgetInput = '';
    _totalBudget = 0.0;
    _planName = '';
    _loadedPlanId = null;
    _categories = BudgetCategory.defaultCategories();
  }

  // --- Actions ---

  /// Refreshes saved plans from Hive storage
  Future<void> loadSavedPlans() async {
    _isLoadingPlans = true;
    notifyListeners();
    try {
      _savedPlans = await _storage.getSavedPlans();
    } catch (e) {
      debugPrint('Failed to load saved plans: $e');
    } finally {
      _isLoadingPlans = false;
      notifyListeners();
    }
  }

  /// Toggles visibility of saved plans accordion
  void toggleSavedPlansExpanded() {
    _isSavedPlansExpanded = !_isSavedPlansExpanded;
    notifyListeners();
  }

  /// Updates total budget from user input with live recalculation
  void setTotalBudget(String input) {
    _totalBudgetInput = input;
    _totalBudget = BudgetCalculator.parseBudgetInput(input);
    notifyListeners();
  }

  /// Updates plan name
  void setPlanName(String name) {
    _planName = name;
    notifyListeners();
  }

  /// Appends a new category card to the list
  void addCategory({String? name, String? icon, String? pct}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final id = '${now}_${_categories.length + 1}';
    
    // Choose an unused preset if possible, or fallback to Custom
    final usedNames = _categories.map((c) => c.name).toSet();
    Map<String, String>? nextPreset;
    for (final preset in BudgetCategory.presetCategories) {
      if (!usedNames.contains(preset['name']) && preset['name'] != 'Custom') {
        nextPreset = preset;
        break;
      }
    }

    final newCat = BudgetCategory(
      id: id,
      name: name ?? nextPreset?['name'] ?? 'Custom',
      icon: icon ?? nextPreset?['icon'] ?? '🏷️',
      pct: pct ?? '',
    );

    _categories = [..._categories, newCat];
    notifyListeners();
  }

  /// Updates properties of an existing category
  void updateCategory(
    String id, {
    String? name,
    String? icon,
    String? pct,
    String? customName,
  }) {
    final index = _categories.indexWhere((c) => c.id == id);
    if (index == -1) return;

    final current = _categories[index];
    _categories = List<BudgetCategory>.from(_categories);
    _categories[index] = current.copyWith(
      name: name,
      icon: icon,
      pct: pct,
      customName: customName,
    );
    notifyListeners();
  }

  /// Removes a category by its ID
  void removeCategory(String id) {
    _categories = _categories.where((c) => c.id != id).toList();
    notifyListeners();
  }

  /// Saves current plan to Hive storage.
  /// Returns a record with success status and user-facing message.
  Future<({bool success, String message})> savePlan() async {
    if (_totalBudget <= 0) {
      return (success: false, message: 'Enter total budget first');
    }

    if (!hasAllocatedCategories) {
      return (success: false, message: 'Add at least one % to save');
    }

    try {
      String effectiveName = _planName.trim();
      if (effectiveName.isEmpty) {
        final count = await _storage.getNextPlanNumber();
        effectiveName = 'Plan $count';
        _planName = effectiveName;
      }

      final planId = _loadedPlanId ?? DateTime.now().millisecondsSinceEpoch.toString();
      final plan = BudgetPlan(
        id: planId,
        name: effectiveName,
        total: _totalBudget,
        allocPct: totalAllocatedPct,
        allocAmt: totalAllocatedAmount,
        date: BudgetPlan.formatCurrentDate(),
        categories: _categories.map((c) => c.copyWith()).toList(),
      );

      await _storage.savePlan(plan);
      _loadedPlanId = plan.id;
      await loadSavedPlans();
      return (success: true, message: 'Plan saved successfully');
    } catch (e) {
      return (success: false, message: 'Failed to save plan: $e');
    }
  }

  /// Loads an existing saved plan into active editing state
  void loadPlan(BudgetPlan plan) {
    _loadedPlanId = plan.id;
    _planName = plan.name;
    _totalBudget = plan.total;
    _totalBudgetInput = BudgetCalculator.formatAmountOnly(plan.total);
    // Deep copy categories
    _categories = plan.categories.map((c) => c.copyWith()).toList();
    notifyListeners();
  }

  /// Deletes a saved plan by ID
  Future<void> deleteSavedPlan(String id) async {
    await _storage.deletePlan(id);
    if (_loadedPlanId == id) {
      _loadedPlanId = null;
    }
    await loadSavedPlans();
  }

  /// Resets all inputs and restores default initial state
  void discardPlan() {
    _initDefaults();
    notifyListeners();
  }
}
