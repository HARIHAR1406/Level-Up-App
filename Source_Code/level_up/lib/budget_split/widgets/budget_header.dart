// =============================================================================
// BudgetSplit Widget - Header
// =============================================================================
// App bar with back navigation, module branding, and theme toggle.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/theme_provider.dart';

/// Top header for BudgetSplit module.
/// Follows the exact header design structure, layout, alignment, and styling
/// from the Habits at Percentage module:
/// - "‹ Level Up" navigation button on the left with vertical separator
/// - Module Title Column ("BUDGET SPLITTER" / "BudgetSplit")
/// - Theme toggle button on the far right (outline vector icon, AppColors.muted)
class BudgetHeader extends StatelessWidget {
  final VoidCallback? onBack;

  const BudgetHeader({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final themeProvider = context.watch<ThemeProvider>();

    return Container(
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
                  // Left: Back button to Hub + Vertical Separator + Module Title
                  Row(
                    children: [
                      InkWell(
                        onTap: onBack ?? () {
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
                            'BUDGET SPLITTER',
                            style: AppTypography.bodySm(
                              color: colors.budgetBlue,
                              fontWeight: FontWeight.w700,
                            ).copyWith(fontSize: 9, letterSpacing: 0.8),
                          ),
                          Text(
                            'BudgetSplit',
                            style: AppTypography.headlineSm(
                              color: colors.text,
                            ).copyWith(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Right: Theme Toggle (matches Habits at Percentage)
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
    );
  }
}
