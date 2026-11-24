// =============================================================================
// Level Up - Application Entry Point
// =============================================================================
// Initializes Hive local storage, registers providers for theme, budget, and
// habits modules, then launches the root LevelUpApp widget.
//
// All data is stored locally on the device using Hive boxes and is
// automatically deleted when the app is uninstalled (Android internal storage).
// =============================================================================

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'budget_split/providers/budget_provider.dart';
import 'core/constants/storage_keys.dart';
import 'core/theme/theme_provider.dart';
import 'habits/providers/habits_provider.dart';

/// Application entry point: initializes storage and state management providers.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive local storage
  await Hive.initFlutter();

  // Register type adapters here as models are introduced
  // Hive.registerAdapter(...);

  // Open core boxes for persistent state across modules
  final themeBox = await Hive.openBox(StorageKeys.themeBox);
  await Hive.openBox(StorageKeys.budgetSplitBox);
  await Hive.openBox(StorageKeys.habitsBox);

  // Initialize theme provider with persisted preferences
  final themeProvider = ThemeProvider()..attachBox(themeBox);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ChangeNotifierProvider<BudgetProvider>(create: (_) => BudgetProvider()),
        ChangeNotifierProvider<HabitsProvider>(create: (_) => HabitsProvider()),
      ],
      child: const LevelUpApp(),
    ),
  );
}
