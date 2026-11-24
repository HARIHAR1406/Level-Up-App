// =============================================================================
// BudgetSplit Widget - Saved Plans
// =============================================================================
// Collapsible panel displaying locally stored budget plans.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../models/budget_plan.dart';
import '../utils/budget_calculator.dart';

/// Collapsible/expandable panel displaying saved plans from Hive.
/// Allows loading a plan into current workspace or permanently deleting it.
class SavedPlansPanel extends StatelessWidget {
  final List<BudgetPlan> plans;
  final String? activePlanId;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;
  final void Function(BudgetPlan plan) onLoadPlan;
  final void Function(String id) onDeletePlan;

  const SavedPlansPanel({
    Key? key,
    required this.plans,
    required this.activePlanId,
    required this.isExpanded,
    required this.onToggleExpanded,
    required this.onLoadPlan,
    required this.onDeletePlan,
  }) : super(key: key);

  void _confirmDelete(BuildContext context, BudgetPlan plan) {
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
          'Delete "${plan.name}"?',
          style: AppTypography.headlineSm(color: colors.text),
        ),
        content: Text(
          'This will permanently remove this plan from your device local storage.',
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
              onDeletePlan(plan.id);
            },
            child: Text(
              'Delete',
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

    if (plans.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row with accordion toggle
        InkWell(
          onTap: onToggleExpanded,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Saved Plans',
                      style: AppTypography.headlineMd(color: colors.text),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: colors.budgetBlue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                      ),
                      child: Text(
                        '${plans.length}',
                        style: AppTypography.codeBadge(color: colors.budgetBlue),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: colors.muted,
                      size: 20,
                    ),
                  ],
                ),

                // Local Storage Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colors.surface2,
                    borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.storage,
                        size: 12,
                        color: colors.budgetGreen,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Local Storage',
                        style: AppTypography.codeBadge(color: colors.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Collapsible List of Saved Plans
        if (isExpanded) ...[
          const SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: plans.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final plan = plans[index];
              final isActive = plan.id == activePlanId;
              final leadIcon = plan.categories.isNotEmpty &&
                      plan.categories.first.icon.isNotEmpty
                  ? plan.categories.first.icon
                  : '💼';

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isActive ? colors.surface2 : colors.surface,
                  borderRadius: BorderRadius.circular(AppConstants.radiusCard),
                  border: Border.all(
                    color: isActive
                        ? colors.budgetBlue.withOpacity(0.5)
                        : colors.border.withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    // Top row: Icon, Name, Date, Amount
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: colors.surface2,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(leadIcon, style: const TextStyle(fontSize: 18)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      plan.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.headlineSm(color: colors.text),
                                    ),
                                  ),
                                  if (isActive) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 1.5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colors.budgetGreen.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'LOADED',
                                        style: AppTypography.codeBadge(
                                          color: colors.budgetGreen,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Saved ${plan.date}',
                                style: AppTypography.bodySm(color: colors.muted),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          BudgetCalculator.formatCurrency(plan.total),
                          style: AppTypography.metricSm(color: colors.text)
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Bottom Row: stats & actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isActive
                                    ? colors.budgetGreen
                                    : colors.budgetBlue,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${plan.categories.length} categories • ${BudgetCalculator.formatPercentage(plan.allocPct)} allocated',
                              style: AppTypography.bodySm(color: colors.muted),
                            ),
                          ],
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isActive)
                              Container(
                                height: 32,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: colors.surface,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check,
                                      size: 14,
                                      color: colors.budgetGreen,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Active',
                                      style: AppTypography.titleSm(
                                        color: colors.budgetGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              InkWell(
                                onTap: () => onLoadPlan(plan),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  height: 32,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: colors.budgetBlue.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Load',
                                      style: AppTypography.titleSm(
                                        color: colors.budgetBlue,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(width: 6),
                            InkWell(
                              onTap: () => _confirmDelete(context, plan),
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.delete_outline,
                                    size: 18,
                                    color: colors.muted,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}
