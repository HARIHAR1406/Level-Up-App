// =============================================================================
// Core Widget - Theme Toggle
// =============================================================================
// Dark/light mode toggle icon button.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/theme_provider.dart';

/// Dark / Light mode toggle button matching the Habits at Percentage design.
///
/// Uses clean vector outline icons ([Icons.dark_mode_outlined] in light mode,
/// [Icons.light_mode_outlined] in dark mode) colored with [AppColors.muted],
/// providing seamless tactile switching without bulky borders or emoji glyphs.
class ThemeToggleButton extends StatelessWidget {
  final double iconSize;

  const ThemeToggleButton({
    super.key,
    this.iconSize = 22.0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDark(context);

    return IconButton(
      icon: Icon(
        isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
        size: iconSize,
        color: colors.muted,
      ),
      splashRadius: 20,
      tooltip: isDark ? 'Switch to Light mode' : 'Switch to Dark mode',
      onPressed: () => themeProvider.toggleTheme(context),
    );
  }
}
