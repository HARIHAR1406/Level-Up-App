// =============================================================================
// Habits Utility - Chart Painter
// =============================================================================
// Custom painter for the donut/ring progress chart visualization.
// =============================================================================

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'habit_calculator.dart';

/// CustomPainter rendering the segmented SVG-style donut chart.
class ChartPainter extends CustomPainter {
  final List<CategoryBreakdown> breakdowns;
  final double grandTotal;
  final Color trackColor;
  final double strokeWidth;

  const ChartPainter({
    required this.breakdowns,
    required this.grandTotal,
    required this.trackColor,
    this.strokeWidth = 22.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;

    // 1. Draw Background Track Rail
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    canvas.drawCircle(center, radius, trackPaint);

    if (grandTotal <= 0 || breakdowns.isEmpty) {
      return;
    }

    // Normalizing denominator: 100.0 or grandTotal if grandTotal exceeds 100
    final double denominator = grandTotal > 100.0 ? grandTotal : 100.0;
    const double twoPi = 2 * math.pi;

    // Start at top (-90 degrees / 12 o'clock)
    double currentAngle = -math.pi / 2;

    for (final breakdown in breakdowns) {
      if (breakdown.totalPct <= 0) continue;

      final categoryColor = breakdown.category.colorValue;
      final double totalSweep = (breakdown.totalPct / denominator) * twoPi;

      // Small angular margin between category segments for crisp demarcation
      const double gapAngle = 0.015;
      final double actualSweep = math.max(0.0, totalSweep - gapAngle);

      if (breakdown.completedPct > 0 && breakdown.completedPct < breakdown.totalPct) {
        // Partially completed category: split into completed vibrant + pending faded
        final double completedSweep = (breakdown.completedPct / breakdown.totalPct) * actualSweep;
        final double pendingSweep = actualSweep - completedSweep;

        // Draw vibrant completed arc
        final completedPaint = Paint()
          ..color = categoryColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.butt;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          currentAngle,
          completedSweep,
          false,
          completedPaint,
        );

        // Draw faded pending arc
        final pendingPaint = Paint()
          ..color = categoryColor.withOpacity(0.32)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.butt;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          currentAngle + completedSweep,
          pendingSweep,
          false,
          pendingPaint,
        );
      } else {
        // Either fully completed or fully pending
        final bool isVibrant = breakdown.completedPct > 0;
        final arcPaint = Paint()
          ..color = isVibrant ? categoryColor : categoryColor.withOpacity(0.32)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.butt;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          currentAngle,
          actualSweep,
          false,
          arcPaint,
        );
      }

      currentAngle += totalSweep;
    }
  }

  @override
  bool shouldRepaint(covariant ChartPainter oldDelegate) {
    return oldDelegate.breakdowns != breakdowns ||
        oldDelegate.grandTotal != grandTotal ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
