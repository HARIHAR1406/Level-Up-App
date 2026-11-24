// =============================================================================
// Habits - Hive Storage Service
// =============================================================================
// Read and write habit state to Hive local storage.
// =============================================================================

import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/storage_keys.dart';
import '../models/habit_state.dart';

/// Storage service persisting HabitState inside Hive box 'hab_state'.
class HabitsStorage {
  final Box _box;

  HabitsStorage({Box? box}) : _box = box ?? Hive.box(StorageKeys.habitsBox);

  /// Load state from Hive, falling back to initial state if not found.
  HabitState loadState() {
    try {
      final rawData = _box.get(StorageKeys.habitsDailyKey);
      if (rawData == null) {
        final initial = HabitState.initial();
        saveState(initial);
        return initial;
      }

      if (rawData is String) {
        final decoded = jsonDecode(rawData) as Map<String, dynamic>;
        return HabitState.fromMap(decoded);
      } else if (rawData is Map) {
        return HabitState.fromMap(rawData);
      }
    } catch (_) {
      // In case of parsing error, gracefully return initial state
    }
    return HabitState.initial();
  }

  /// Persist current HabitState to Hive.
  Future<void> saveState(HabitState state) async {
    final encoded = jsonEncode(state.toMap());
    await _box.put(StorageKeys.habitsDailyKey, encoded);
    await _box.put(StorageKeys.habitsResetAtKey, state.lastResetDate);
  }

  /// Clear stored habits state and reset to defaults.
  Future<HabitState> resetToDefault() async {
    final initial = HabitState.initial();
    await saveState(initial);
    return initial;
  }
}
