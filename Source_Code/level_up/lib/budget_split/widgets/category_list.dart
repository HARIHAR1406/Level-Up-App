// =============================================================================
// BudgetSplit Widget - Category List
// =============================================================================
// Scrollable list of category cards with Add field button.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../models/budget_category.dart';
import 'category_card.dart';

/// Container for the category cards list, with a header showing
/// category count and the "+ Add field" action button.
class CategoryList extends StatelessWidget {
  final List<BudgetCategory> categories;
  final double totalBudget;
  final void Function(BudgetCategory category) onPickIcon;
  final void Function(String id, String newName) onNameChanged;
  final void Function(String id, String customName) onCustomNameChanged;
  final void Function(String id, String newPct) onPctChanged;
  final void Function(String id) onDeleteCategory;
  final VoidCallback onAddCategory;

  const CategoryList({
    Key? key,
    required this.categories,
    required this.totalBudget,
    required this.onPickIcon,
    required this.onNameChanged,
    required this.onCustomNameChanged,
    required this.onPctChanged,
    required this.onDeleteCategory,
    required this.onAddCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Categories',
                  style: AppTypography.headlineMd(color: colors.text),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: colors.surface2,
                    borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                  ),
                  child: Text(
                    '(${categories.length})',
                    style: AppTypography.codeBadge(color: colors.muted),
                  ),
                ),
              ],
            ),

            // "+ Add field" Button
            InkWell(
              onTap: onAddCategory,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: colors.budgetBlue.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add,
                      size: 16,
                      color: colors.budgetBlue,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Add field',
                      style: AppTypography.titleSm(color: colors.budgetBlue),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Categories List or Empty Indicator
        if (categories.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppConstants.radiusCard),
              border: Border.all(
                color: colors.border.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.playlist_add,
                  size: 32,
                  color: colors.muted,
                ),
                const SizedBox(height: 8),
                Text(
                  'No categories added yet',
                  style: AppTypography.bodyMd(color: colors.muted),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap "+ Add field" above to allocate budget.',
                  style: AppTypography.bodySm(color: colors.muted.withOpacity(0.7)),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final cat = categories[index];
              return CategoryCard(
                key: ValueKey(cat.id),
                category: cat,
                totalBudget: totalBudget,
                onPickIcon: () => onPickIcon(cat),
                onNameChanged: (newName) => onNameChanged(cat.id, newName),
                onCustomNameChanged: (customName) =>
                    onCustomNameChanged(cat.id, customName),
                onPctChanged: (newPct) => onPctChanged(cat.id, newPct),
                onDelete: () => onDeleteCategory(cat.id),
              );
            },
          ),
      ],
    );
  }
}
