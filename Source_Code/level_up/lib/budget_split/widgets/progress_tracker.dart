// =============================================================================
// BudgetSplit Widget - Progress Tracker
// =============================================================================
// Live allocation progress bar with percentage and over-budget detection.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../utils/budget_calculator.dart';

/// Progress tracker widget showing live allocation stats,
/// remaining balance or over-budget warning, and the reactive progress bar.
class ProgressTracker extends StatelessWidget {
  final double totalBudget;
  final double totalAllocatedPct;
  final double totalAllocatedAmount;
  final double remainingAmount;
  final bool isOverBudget;

  const ProgressTracker({
    Key? key,
    required this.totalBudget,
    required this.totalAllocatedPct,
    required this.totalAllocatedAmount,
    required this.remainingAmount,
    required this.isOverBudget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final fillFraction = totalAllocatedPct <= 0
        ? 0.0
        : (totalAllocatedPct > 100.0 ? 1.0 : (totalAllocatedPct / 100.0));

    final statusColor = isOverBudget ? colors.danger : colors.budgetGreen;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Allocation Stats Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left: Allocation percentage
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isOverBudget ? Icons.warning_amber_rounded : Icons.pie_chart,
                  size: 16,
                  color: statusColor,
                ),
                const SizedBox(width: 6),
                Text(
                  'Allocated: ',
                  style: AppTypography.metricSm(color: statusColor),
                ),
                Text(
                  BudgetCalculator.formatPercentage(totalAllocatedPct),
                  style: AppTypography.metricSm(color: statusColor)
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),

            // Right: Remaining or Over budget rupees
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isOverBudget ? 'Over: ' : 'Remaining: ',
                  style: AppTypography.bodySm(color: colors.muted),
                ),
                Text(
                  totalBudget <= 0 && totalAllocatedAmount <= 0
                      ? '—'
                      : isOverBudget
                          ? BudgetCalculator.formatCurrency(remainingAmount.abs())
                          : BudgetCalculator.formatCurrency(remainingAmount),
                  style: AppTypography.metricSm(
                    color: isOverBudget ? colors.danger : colors.budgetBlue,
                  ).copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Progress Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.radiusPill),
          child: Container(
            height: 8,
            width: double.infinity,
            color: colors.surface2,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: fillFraction,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                ),
              ),
            ),
          ),
        ),

        // Over-Budget Alert Banner when exceeding 100%
        if (isOverBudget) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.danger.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppConstants.radiusCard),
              border: Border.all(
                color: colors.danger.withOpacity(0.35),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.warning_rounded,
                  color: colors.danger,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Allocation Limit Exceeded',
                            style: AppTypography.headlineSm(color: colors.danger),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colors.danger.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                            ),
                            child: Text(
                              '+${BudgetCalculator.formatPercentage(totalAllocatedPct - 100)} Over',
                              style: AppTypography.codeBadge(color: colors.danger),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your plan assigns ${BudgetCalculator.formatPercentage(totalAllocatedPct)} (${BudgetCalculator.formatCurrency(totalAllocatedAmount)}). Please trim ${BudgetCalculator.formatCurrency(remainingAmount.abs())} across categories to re-align your budget.',
                        style: AppTypography.bodySm(color: colors.text),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
