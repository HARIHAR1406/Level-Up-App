// =============================================================================
// Habits Widget - Bottom Navigation
// =============================================================================
// Action / Create / Visual tab switcher bar.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Fixed 64px bottom navigation bar for Habits at Percentage module.
class HabitsBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const HabitsBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.isDark ? colors.surface : Colors.white,
        border: Border(
          top: BorderSide(
            color: colors.border.withOpacity(colors.isDark ? 0.6 : 0.8),
            width: 1,
          ),
        ),
        boxShadow: colors.isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Row(
                children: [
                  _NavItem(
                    label: 'Action',
                    icon: Icons.check_box_outlined,
                    activeIcon: Icons.check_box,
                    isSelected: currentIndex == 0,
                    onTap: () => onTabSelected(0),
                  ),
                  _NavItem(
                    label: 'Create',
                    icon: Icons.add_circle_outline,
                    activeIcon: Icons.add_circle,
                    isSelected: currentIndex == 1,
                    onTap: () => onTabSelected(1),
                  ),
                  _NavItem(
                    label: 'Visual',
                    icon: Icons.pie_chart_outline,
                    activeIcon: Icons.pie_chart,
                    isSelected: currentIndex == 2,
                    onTap: () => onTabSelected(2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final activeColor = colors.habitsAccent;
    final inactiveColor = colors.muted;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: activeColor.withOpacity(0.1),
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 24,
              color: isSelected ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTypography.bodySm(
                color: isSelected ? activeColor : inactiveColor,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ).copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
