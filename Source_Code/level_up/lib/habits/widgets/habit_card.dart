// =============================================================================
// Habits Widget - Habit Card
// =============================================================================
// Individual habit card with completion circle, progress bar, edit, and delete.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../models/habit.dart';
import '../models/habit_category.dart';
import '../utils/habit_calculator.dart';

/// Interactive habit card component representing a single habit item.
class HabitCardWidget extends StatelessWidget {
  final Habit habit;
  final HabitCategory category;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const HabitCardWidget({
    super.key,
    required this.habit,
    required this.category,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDone = habit.done;
    final catColor = category.colorValue;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: colors.isDark ? colors.surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.border.withOpacity(colors.isDark ? 0.6 : 0.8),
          width: 1,
        ),
        boxShadow: colors.isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Left Color Accent Tag Strip
              Container(
                width: 4,
                height: 44,
                decoration: BoxDecoration(
                  color: catColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),

              // 2. Custom Circular Completion Checkbox
              GestureDetector(
                onTap: onToggle,
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone ? colors.habitsAccent : colors.surface2,
                    border: Border.all(
                      color: isDone ? colors.habitsAccent : colors.border,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: isDone
                        ? const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // 3. Habit Details Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + Percentage Weight Pill
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            habit.name,
                            style: AppTypography.headlineSm(
                              color: isDone ? colors.muted : colors.text,
                            ).copyWith(
                              decoration: isDone ? TextDecoration.lineThrough : null,
                              decorationColor: colors.muted,
                              fontWeight: isDone ? FontWeight.w500 : FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: colors.surface2,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            HabitCalculator.formatPct(habit.pct),
                            style: AppTypography.metricSm(
                              color: isDone ? colors.muted : colors.text,
                            ).copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Category Pill + Time Window
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        // Category Pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: catColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: catColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                category.name,
                                style: AppTypography.bodySm(
                                  color: catColor,
                                  fontWeight: FontWeight.w600,
                                ).copyWith(fontSize: 11),
                              ),
                            ],
                          ),
                        ),

                        // Time Window
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 13,
                              color: colors.muted,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${habit.from} – ${habit.to}',
                              style: AppTypography.bodySm(
                                color: colors.muted,
                              ).copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 4. Action Buttons (Edit & Delete)
              const SizedBox(width: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit_outlined, size: 18, color: colors.muted),
                    splashRadius: 18,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    tooltip: 'Edit Habit',
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline, size: 18, color: colors.danger),
                    splashRadius: 18,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    tooltip: 'Delete Habit',
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 5. 100% Progress Bar Track
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: Container(
              height: 5,
              width: double.infinity,
              color: colors.surface2,
              child: AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 300),
                alignment: Alignment.centerLeft,
                widthFactor: isDone ? 1.0 : 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.habitsAccent,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
