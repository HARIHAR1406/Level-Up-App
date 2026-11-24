// =============================================================================
// Habits at Percentage Module - Main Screen
// =============================================================================
// A percentage-based daily habit tracking system with three tabs:
//   - Action: View, complete, and manage today's habits with progress cards
//   - Create: Add new habits with percentage weight, time window, and category
//   - Visual: Progress donut chart and category breakdown analytics
//
// Habits reset automatically at midnight via the daily reset mechanism.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/theme/theme_provider.dart';
import 'pages/action_page.dart';
import 'pages/create_page.dart';
import 'pages/visual_page.dart';
import 'providers/habits_provider.dart';
import 'widgets/bottom_nav_bar.dart';

/// HabitsScreen is the root container widget for Module 2: Habits at Percentage.
/// Manages the top app bar, tab switching (Action, Create, Visual), and bottom navigation.
class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide HabitsProvider locally if not registered at app root
    try {
      context.read<HabitsProvider>();
      return const _HabitsScreenContent();
    } catch (_) {
      return ChangeNotifierProvider<HabitsProvider>(
        create: (_) => HabitsProvider(),
        child: const _HabitsScreenContent(),
      );
    }
  }
}

class _HabitsScreenContent extends StatelessWidget {
  const _HabitsScreenContent();

  String _tabTitle(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return 'Action';
      case 1:
        return 'Create';
      case 2:
        return 'Visual';
      default:
        return 'Action';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final habitsProvider = context.watch<HabitsProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final currentTab = habitsProvider.currentTab;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: BoxDecoration(
            color: colors.isDark ? colors.surface : Colors.white,
            border: Border(
              bottom: BorderSide(
                color: colors.border.withOpacity(colors.isDark ? 0.6 : 0.8),
                width: 1,
              ),
            ),
            boxShadow: colors.isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 1),
                    ),
                  ],
          ),
          child: SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left: Back button to Hub + Module Logo + Title
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (Navigator.of(context).canPop()) {
                                Navigator.of(context).pop();
                              }
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '‹',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w400,
                                      color: colors.muted,
                                      height: 1.0,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Level Up',
                                    style: AppTypography.bodySm(
                                      color: colors.muted,
                                      fontWeight: FontWeight.w600,
                                    ).copyWith(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 1,
                            height: 20,
                            color: colors.border.withOpacity(0.6),
                          ),
                          const SizedBox(width: 10),

                          // Module Title Column
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'HABITS AT PERCENTAGE',
                                style: AppTypography.bodySm(
                                  color: colors.habitsAccent,
                                  fontWeight: FontWeight.w700,
                                ).copyWith(fontSize: 9, letterSpacing: 0.8),
                              ),
                              Text(
                                _tabTitle(currentTab),
                                style: AppTypography.headlineSm(
                                  color: colors.text,
                                ).copyWith(fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Right: Theme Toggle (shifted to far-right, profile avatar removed)
                      IconButton(
                        icon: Icon(
                          themeProvider.isDark(context)
                              ? Icons.light_mode_outlined
                              : Icons.dark_mode_outlined,
                          size: 20,
                          color: colors.muted,
                        ),
                        splashRadius: 18,
                        tooltip: 'Toggle Theme',
                        onPressed: () => themeProvider.toggleTheme(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: currentTab,
        children: const [
          ActionPage(),
          CreatePage(),
          VisualPage(),
        ],
      ),
      bottomNavigationBar: HabitsBottomNavBar(
        currentIndex: currentTab,
        onTabSelected: (tab) => habitsProvider.setCurrentTab(tab),
      ),
    );
  }
}
