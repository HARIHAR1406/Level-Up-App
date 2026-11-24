// =============================================================================
// Habits Widget - Category Grid
// =============================================================================
// 20 selectable focus category chips with color badges.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../models/habit_category.dart';

/// 2-Column scrollable grid of selectable category chips.
class CategoryGridWidget extends StatelessWidget {
  final List<HabitCategory> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const CategoryGridWidget({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      constraints: const BoxConstraints(maxHeight: 280),
      decoration: BoxDecoration(
        color: colors.isDark ? colors.surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.border.withOpacity(colors.isDark ? 0.6 : 0.8),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: RawScrollbar(
        thumbVisibility: false,
        radius: const Radius.circular(4),
        thickness: 4,
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 3.2,
          ),
          itemBuilder: (context, index) {
            final cat = categories[index];
            final isSelected = index == selectedIndex;
            final catColor = cat.colorValue;

            // Background & text styling based on selection state
            final Color bgColor;
            final Color textColor;
            if (isSelected) {
              bgColor = colors.isDark
                  ? const Color(0xFF2C2852)
                  : const Color(0xFFE3DFFF);
              textColor = colors.isDark
                  ? const Color(0xFFE3DFFF)
                  : const Color(0xFF100069);
            } else {
              bgColor = colors.surface2;
              textColor = colors.text;
            }

            return Material(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () => onSelect(index),
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Row(
                    children: [
                      // Category Color Dot
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: catColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Category Label
                      Expanded(
                        child: Text(
                          cat.name,
                          style: AppTypography.bodySm(
                            color: textColor,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ).copyWith(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Selection Check Indicator
                      if (isSelected) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.check,
                          size: 16,
                          color: colors.habitsAccent,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
