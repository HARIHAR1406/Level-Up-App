// =============================================================================
// BudgetSplit Widget - Action Buttons
// =============================================================================
// Save Plan, Export, and Discard action buttons row.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';

/// Primary action buttons:
/// - Save Plan (primary blue button with bookmark icon)
/// - Export (secondary green button with share icon)
/// - Discard / Reset (danger icon button with confirmation prompt)
class ActionButtons extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onExport;
  final VoidCallback onDiscard;

  const ActionButtons({
    Key? key,
    required this.onSave,
    required this.onExport,
    required this.onDiscard,
  }) : super(key: key);

  void _confirmDiscard(BuildContext context) {
    final colors = AppColors.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusCard),
          side: BorderSide(color: colors.border.withOpacity(0.5)),
        ),
        title: Text(
          'Discard Current Plan?',
          style: AppTypography.headlineSm(color: colors.text),
        ),
        content: Text(
          'Clear all fields and start fresh? This will reset all current category allocations.',
          style: AppTypography.bodyMd(color: colors.muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: AppTypography.titleSm(color: colors.muted),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.danger,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              onDiscard();
            },
            child: Text(
              'Clear All',
              style: AppTypography.titleSm(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Row(
      children: [
        // Save Plan Button
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: onSave,
              icon: const Icon(Icons.bookmark, size: 18),
              label: Text(
                'Save Plan',
                style: AppTypography.titleSm(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.budgetBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusCard),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Export Button
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: onExport,
              icon: const Icon(Icons.ios_share, size: 18),
              label: Text(
                'Export',
                style: AppTypography.titleSm(
                  color: colors.isDark ? AppColors.darkBg : Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.budgetGreen,
                foregroundColor: colors.isDark ? AppColors.darkBg : Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusCard),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Discard / Reset Button
        InkWell(
          onTap: () => _confirmDiscard(context),
          borderRadius: BorderRadius.circular(AppConstants.radiusCard),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppConstants.radiusCard),
              border: Border.all(
                color: colors.border.withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.delete_sweep,
                color: colors.danger,
                size: 22,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
