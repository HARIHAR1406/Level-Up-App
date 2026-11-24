// =============================================================================
// BudgetSplit - Hive Storage Service
// =============================================================================
// CRUD operations for saving and loading budget plans in Hive local storage.
// =============================================================================

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/storage_keys.dart';
import '../models/budget_plan.dart';

/// Service handling persistent Hive storage operations for BudgetSplit.
/// Operates on Hive box 'bs_plans' without external network dependencies.
class BudgetStorage {
  static const String _plansKey = StorageKeys.budgetPlansListKey;

  /// Ensures the Hive box is open and returns the Box reference
  Future<Box> _getBox() async {
    if (Hive.isBoxOpen(StorageKeys.budgetSplitBox)) {
      return Hive.box(StorageKeys.budgetSplitBox);
    }
    return await Hive.openBox(StorageKeys.budgetSplitBox);
  }

  /// Retrieves all saved budget plans sorted newest first
  Future<List<BudgetPlan>> getSavedPlans() async {
    try {
      final box = await _getBox();
      final rawData = box.get(_plansKey);

      List<BudgetPlan> plans = [];

      if (rawData is List) {
        for (final item in rawData) {
          if (item is Map) {
            plans.add(BudgetPlan.fromMap(item));
          } else if (item is String) {
            plans.add(BudgetPlan.fromJson(item));
          }
        }
      } else if (rawData is String && rawData.isNotEmpty) {
        final decoded = json.decode(rawData);
        if (decoded is List) {
          plans = decoded.map((e) => BudgetPlan.fromMap(e as Map)).toList();
        }
      } else {
        // Fallback: check if plans are stored by individual keys in the box
        for (final key in box.keys) {
          if (key != _plansKey) {
            final val = box.get(key);
            if (val is Map) {
              plans.add(BudgetPlan.fromMap(val));
            } else if (val is String) {
              try {
                plans.add(BudgetPlan.fromJson(val));
              } catch (_) {}
            }
          }
        }
      }

      // Sort plans newest first (by id timestamp if numerical, or preserve order)
      return plans;
    } catch (e) {
      debugPrint('Error reading saved budget plans: $e');
      return [];
    }
  }

  /// Saves a new plan or updates an existing plan by ID
  Future<void> savePlan(BudgetPlan plan) async {
    try {
      final box = await _getBox();
      final existingPlans = await getSavedPlans();

      final index = existingPlans.indexWhere((p) => p.id == plan.id);
      if (index >= 0) {
        existingPlans[index] = plan;
      } else {
        existingPlans.insert(0, plan);
      }

      final serializable = existingPlans.map((p) => p.toMap()).toList();
      await box.put(_plansKey, serializable);
    } catch (e) {
      debugPrint('Error saving budget plan: $e');
      rethrow;
    }
  }

  /// Deletes a plan by ID
  Future<void> deletePlan(String id) async {
    try {
      final box = await _getBox();
      final existingPlans = await getSavedPlans();
      existingPlans.removeWhere((p) => p.id == id);

      final serializable = existingPlans.map((p) => p.toMap()).toList();
      await box.put(_plansKey, serializable);

      // Also clean up direct key if present
      if (box.containsKey(id)) {
        await box.delete(id);
      }
    } catch (e) {
      debugPrint('Error deleting budget plan $id: $e');
      rethrow;
    }
  }

  /// Returns the next sequential plan number for auto-naming (e.g. Plan 1, Plan 2)
  Future<int> getNextPlanNumber() async {
    final plans = await getSavedPlans();
    return plans.length + 1;
  }

  /// Clears all plans in local storage
  Future<void> clearAllPlans() async {
    try {
      final box = await _getBox();
      await box.clear();
    } catch (e) {
      debugPrint('Error clearing budget plans: $e');
    }
  }
}
