// =============================================================================
// BudgetSplit Widget - Breakdown Summary
// =============================================================================
// Live category breakdown table showing percentages, amounts, and totals.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../models/budget_category.dart';
import '../utils/budget_calculator.dart';

/// Structured breakdown table showing active categories with icons,
/// percentages, resolved rupee totals, and final summary metrics.
class BreakdownSummary extends StatelessWidget {
  final List<BudgetCategory> categories;
  final double totalBudget;
  final double totalAllocatedPct;
  final double totalAllocatedAmount;
  final bool isOverBudget;

  const BreakdownSummary({
    Key? key,
    required this.categories,
    required this.totalBudget,
    required this.totalAllocatedPct,
    required this.totalAllocatedAmount,
    required this.isOverBudget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Only show categories that have a non-zero percentage
    final activeCategories =
        categories.where((c) => c.percentageValue > 0).toList();

    if (activeCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = AppColors.of(context);
    final ratioColor = isOverBudget ? colors.danger : colors.budgetGreen;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spaceMd),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusCard),
        border: Border.all(
          color: colors.border.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: "Budget Breakdown" & "Dynamic Summary"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 18,
                    color: colors.budgetBlue,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Budget Breakdown',
                    style: AppTypography.headlineSm(color: colors.text),
                  ),
                ],
              ),
              Text(
                'DYNAMIC SUMMARY',
                style: AppTypography.codeBadge(color: colors.muted),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Categories Breakdown Table
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activeCategories.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final cat = activeCategories[index];
              final amount = BudgetCalculator.calculateCategoryAmount(
                totalBudget,
                cat.percentageValue,
              );

              return Row(
                children: [
                  // Icon + Category Name
                  Expanded(
                    child: Row(
                      children: [
                        Text(cat.icon, style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            cat.displayName,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodyMd(color: colors.text),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Percentage
                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 44),
                    child: Text(
                      BudgetCalculator.formatPercentage(cat.percentageValue),
                      textAlign: TextAlign.right,
                      style: AppTypography.metricSm(color: colors.muted),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Amount
                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 72),
                    child: Text(
                      totalBudget <= 0
                          ? '—'
                          : BudgetCalculator.formatCurrency(amount),
                      textAlign: TextAlign.right,
                      style: AppTypography.metricSm(color: colors.text),
                    ),
                  ),
                ],
              );
            },
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(
              color: colors.border.withOpacity(0.4),
              height: 1,
            ),
          ),

          // Summary Totals Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Allocated Ratio
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ALLOCATED RATIO',
                    style: AppTypography.codeBadge(color: colors.muted),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    BudgetCalculator.formatPercentage(totalAllocatedPct),
                    style: AppTypography.metricMd(color: ratioColor),
                  ),
                ],
              ),

              // Total Allocated Rupees
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'TOTAL ALLOCATED',
                    style: AppTypography.codeBadge(color: colors.muted),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    totalBudget <= 0 && totalAllocatedAmount <= 0
                        ? '—'
                        : BudgetCalculator.formatCurrency(totalAllocatedAmount),
                    style: AppTypography.metricMd(color: colors.text),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
