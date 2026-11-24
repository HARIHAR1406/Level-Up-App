// =============================================================================
// Habits Widget - Donut Chart
// =============================================================================
// Animated progress circle with dynamic status badge (Today/In Progress/Done).
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../utils/chart_painter.dart';
import '../utils/habit_calculator.dart';

/// Donut chart widget wrapping ChartPainter with ambient halo and center typography dial.
class DonutChartWidget extends StatelessWidget {
  final List<CategoryBreakdown> breakdowns;
  final double grandTotal;
  final double completedPct;
  final int completedCount;
  final int totalCount;
  final double size;

  const DonutChartWidget({
    super.key,
    required this.breakdowns,
    required this.grandTotal,
    required this.completedPct,
    required this.completedCount,
    required this.totalCount,
    this.size = 230.0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final trackColor = colors.surface2;

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. Subtle Atmospheric Ambient Halo
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.habitsAccent.withOpacity(0.15),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFB65C00).withOpacity(0.12),
                ),
              ),
            ),

            // 2. Custom Painter Donut Arcs
            SizedBox(
              width: size,
              height: size,
              child: CustomPaint(
                painter: ChartPainter(
                  breakdowns: breakdowns,
                  grandTotal: grandTotal,
                  trackColor: trackColor,
                  strokeWidth: 22.0,
                ),
              ),
            ),

            // 3. Center Typography Dial
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Status Badge with Pulsing Dot
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: totalCount == 0
                        ? colors.surface2
                        : (completedCount == totalCount && totalCount > 0)
                            ? colors.success.withOpacity(0.12)
                            : colors.habitsAccent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: totalCount == 0
                              ? colors.muted
                              : (completedCount == totalCount && totalCount > 0)
                                  ? colors.success
                                  : colors.habitsAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        totalCount == 0
                            ? 'TODAY'
                            : (completedCount == totalCount && totalCount > 0)
                                ? 'DONE'
                                : 'IN PROGRESS',
                        style: AppTypography.bodySm(
                          color: totalCount == 0
                              ? colors.muted
                              : (completedCount == totalCount && totalCount > 0)
                                  ? colors.success
                                  : colors.habitsAccent,
                          fontWeight: FontWeight.w700,
                        ).copyWith(
                          fontSize: 10,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),

                // Center Metric Percentage (e.g. 30%)
                Text(
                  HabitCalculator.formatPct(completedPct),
                  style: AppTypography.metricDisplay(
                    color: colors.text,
                  ).copyWith(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.5,
                  ),
                ),

                // Sub-label (e.g. "2 of 5 completed" or "No habits added yet")
                Text(
                  totalCount == 0
                      ? 'No habits added yet'
                      : '$completedCount of $totalCount completed',
                  style: AppTypography.bodySm(
                    color: colors.muted,
                  ).copyWith(fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
