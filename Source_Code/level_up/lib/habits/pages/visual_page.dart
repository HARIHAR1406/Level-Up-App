// =============================================================================
// Habits Page - Visual
// =============================================================================
// Progress visualization with animated donut chart and category breakdown analytics.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../providers/habits_provider.dart';
import '../utils/habit_calculator.dart';
import '../widgets/donut_chart.dart';

/// Visual Page: Data visualisation and insight module with interactive circular donut chart,
/// category breakdowns, pending tasks with quick-check, and milestone celebration banner.
class VisualPage extends StatelessWidget {
  const VisualPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitsProvider>();
    final colors = AppColors.of(context);

    final habits = provider.habits;
    final categories = provider.categories;
    final breakdowns = provider.categoryBreakdowns;
    final completedPct = provider.completedPct;
    final remainingPct = provider.remainingPct;
    final totalPct = provider.totalPct;
    final completedCount = provider.completedCount;
    final totalCount = provider.totalCount;

    final pendingHabits = habits.where((h) => !h.done).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Subtle Page Header Intro
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Progress',
                    style: AppTypography.headlineLg(
                      color: colors.text,
                    ).copyWith(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'See how far you have come today.',
                    style: AppTypography.bodySm(color: colors.muted),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 2. Hero Visual Card: Donut Chart + Metric Summary
              Container(
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
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  children: [
                    DonutChartWidget(
                      breakdowns: breakdowns,
                      grandTotal: totalPct,
                      completedPct: completedPct,
                      completedCount: completedCount,
                      totalCount: totalCount,
                      size: 230,
                    ),
                    const SizedBox(height: 18),

                    // Quick Metric Fraction Footer
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: colors.surface2,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          // Completed
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'COMPLETED',
                                  style: AppTypography.bodySm(
                                    color: colors.muted,
                                    fontWeight: FontWeight.w700,
                                  ).copyWith(fontSize: 11, letterSpacing: 0.8),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  HabitCalculator.formatPct(completedPct),
                                  style: AppTypography.metricLg(
                                    color: const Color(0xFF059669),
                                  ).copyWith(fontSize: 20, fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 28,
                            color: colors.border.withOpacity(0.5),
                          ),
                          // Remaining
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'REMAINING',
                                  style: AppTypography.bodySm(
                                    color: colors.muted,
                                    fontWeight: FontWeight.w700,
                                  ).copyWith(fontSize: 11, letterSpacing: 0.8),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  HabitCalculator.formatPct(remainingPct),
                                  style: AppTypography.metricLg(
                                    color: colors.habitsAccent,
                                  ).copyWith(fontSize: 20, fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 3. Category Breakdown Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Category Breakdown',
                    style: AppTypography.headlineSm(
                      color: colors.text,
                    ).copyWith(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Weighted total ${HabitCalculator.formatPct(totalPct)}',
                    style: AppTypography.bodySm(color: colors.muted).copyWith(fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Container(
                decoration: BoxDecoration(
                  color: colors.isDark ? colors.surface : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colors.border.withOpacity(colors.isDark ? 0.6 : 0.8),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: breakdowns.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'No habits configured yet.',
                            style: AppTypography.bodyMd(color: colors.muted),
                          ),
                        ),
                      )
                    : Column(
                        children: breakdowns.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final b = entry.value;
                          final isLast = idx == breakdowns.length - 1;
                          final catColor = b.category.colorValue;
                          final isDone = b.isAllDone;

                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: catColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            b.category.name,
                                            style: AppTypography.bodySm(
                                              color: colors.text,
                                              fontWeight: FontWeight.w600,
                                            ).copyWith(fontSize: 13),
                                          ),
                                          Text(
                                            '${b.totalCount} habit${b.totalCount == 1 ? '' : 's'}',
                                            style: AppTypography.bodySm(
                                              color: colors.muted,
                                            ).copyWith(fontSize: 11),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${HabitCalculator.formatPct(b.completedPct)} / ${HabitCalculator.formatPct(b.totalPct)}',
                                          style: AppTypography.metricSm(
                                            color: isDone ? colors.text : colors.muted,
                                          ).copyWith(
                                            fontSize: 12,
                                            fontWeight: isDone ? FontWeight.w700 : FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: isDone
                                                ? const Color(0xFFD1FAE5)
                                                : const Color(0xFFFEF3C7),
                                            borderRadius: BorderRadius.circular(9999),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                isDone ? Icons.check : Icons.schedule,
                                                size: 11,
                                                color: isDone
                                                    ? const Color(0xFF047857)
                                                    : const Color(0xFFB45309),
                                              ),
                                              const SizedBox(width: 3),
                                              Text(
                                                isDone ? 'Done' : 'Pending',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                  color: isDone
                                                      ? const Color(0xFF047857)
                                                      : const Color(0xFFB45309),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (!isLast)
                                Divider(
                                  height: 1,
                                  color: colors.border.withOpacity(0.4),
                                ),
                            ],
                          );
                        }).toList(),
                      ),
              ),
              const SizedBox(height: 20),

              // 4. Pending Tasks Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pending Tasks (${pendingHabits.length})',
                    style: AppTypography.headlineSm(
                      color: colors.text,
                    ).copyWith(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '${HabitCalculator.formatPct(remainingPct)} remaining',
                    style: AppTypography.bodySm(
                      color: colors.habitsAccent,
                      fontWeight: FontWeight.w600,
                    ).copyWith(fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              if (habits.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colors.isDark ? colors.surface : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colors.border.withOpacity(colors.isDark ? 0.6 : 0.8),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.inbox_outlined, size: 36, color: colors.muted),
                      const SizedBox(height: 8),
                      Text(
                        'No habits yet',
                        style: AppTypography.headlineSm(color: colors.text)
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Create your first habit to track pending tasks here.',
                        style: AppTypography.bodySm(color: colors.muted),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else if (pendingHabits.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colors.isDark ? colors.surface : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colors.border.withOpacity(colors.isDark ? 0.6 : 0.8),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.celebration, size: 36, color: Color(0xFF10B981)),
                      const SizedBox(height: 8),
                      Text(
                        '🎉 All habits completed!',
                        style: AppTypography.headlineSm(color: colors.text)
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'You reached 100% of your scheduled routine for today.',
                        style: AppTypography.bodySm(color: colors.muted),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                ...pendingHabits.map((habit) {
                  final cat = (habit.catIdx >= 0 && habit.catIdx < categories.length)
                      ? categories[habit.catIdx]
                      : categories.first;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: colors.isDark ? colors.surface : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: colors.border.withOpacity(colors.isDark ? 0.6 : 0.8),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Left colored strip
                        Container(
                          width: 4,
                          height: 36,
                          decoration: BoxDecoration(
                            color: cat.colorValue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Title & Time
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                habit.name,
                                style: AppTypography.bodySm(
                                  color: colors.text,
                                  fontWeight: FontWeight.w700,
                                ).copyWith(fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(Icons.schedule, size: 12, color: colors.muted),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${habit.from} – ${habit.to}',
                                    style: AppTypography.bodySm(
                                      color: colors.muted,
                                    ).copyWith(fontSize: 11),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Weight Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: colors.surface2,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            HabitCalculator.formatPct(habit.pct),
                            style: AppTypography.metricSm(
                              color: colors.text,
                            ).copyWith(fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Quick Check Action Button
                        GestureDetector(
                          onTap: () => provider.toggleHabit(habit.id),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.surface2,
                            ),
                            child: Icon(
                              Icons.circle_outlined,
                              size: 18,
                              color: colors.muted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
