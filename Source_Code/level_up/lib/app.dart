// =============================================================================
// Level Up - Root Application Widget
// =============================================================================
// Configures MaterialApp with light/dark theme support, theme mode from
// ThemeProvider, and HubScreen as the home screen.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'hub/hub_screen.dart';

/// Root application widget for Level Up.
class LevelUpApp extends StatelessWidget {
  const LevelUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'Level Up',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const HubScreen(),
    );
  }
}
