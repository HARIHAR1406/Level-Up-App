// =============================================================================
// Hub Widget - Module Circle
// =============================================================================
// Interactive module launcher with glow effects and telemetry badge.
// =============================================================================

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import '../../core/models/enums.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/circle_module_button.dart';

/// Module Circle widget for the Switchboard panel.
/// Displays a 124px animated circular module button (BudgetSplit or Habits)
/// and module title (15px semibold).
class ModuleCircle extends StatelessWidget {
  final AppModule module;
  final String title;
  final VoidCallback? onTap;
  final bool isPressed;

  const ModuleCircle({
    super.key,
    required this.module,
    required this.title,
    this.onTap,
    this.isPressed = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = colors.isDark;

    // Specific styling per module
    final isBudget = module == AppModule.budgetSplit;

    // Ring configuration:
    // BudgetSplit: 4px gradient ring from #4F8EF7 to #56D49A at 135 deg
    // Habits: 4px solid #675DF9 (or light #4D41DF)
    final Gradient? ringGradient = isBudget
        ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.budgetBlue, colors.budgetGreen],
          )
        : null;

    final Color? ringColor = isBudget ? null : colors.habitsIndigo;

    // Glowing shadows matching spec: 0 0 26px halo
    final List<BoxShadow> shadows = [
      BoxShadow(
        color: isBudget
            ? (isDark ? AppColors.darkBudgetBlueGlow : const Color(0x400059BA))
            : (isDark ? AppColors.darkHabitsIndigoGlow : const Color(0x404D41DF)),
        blurRadius: 26.0,
        spreadRadius: 0.0,
      ),
    ];

    final Widget iconWidget = isBudget
        ? CustomPaint(
            size: const Size(56, 56),
            painter: _BudgetSplitIconPainter(
              blueColor: colors.budgetBlue,
              greenColor: colors.budgetGreen,
              circleFillColor: colors.circleFill,
              trackColor: colors.text.withOpacity(0.12),
            ),
          )
        : CustomPaint(
            size: const Size(56, 56),
            painter: _HabitsDonutIconPainter(
              indigoColor: colors.habitsIndigo,
              trackColor: colors.text.withOpacity(0.22),
              textColor: colors.text,
            ),
          );

    return SizedBox(
      width: 140.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 124x124 Circular Interactive Module Button
          CircleModuleButton(
            size: AppConstants.moduleCircleSize,
            ringGradient: ringGradient,
            ringColor: ringColor,
            ringWidth: 4.0,
            shadows: shadows,
            innerFillColor: colors.circleFill,
            onTap: onTap,
            isPressed: isPressed,
            tooltip: title,
            child: iconWidget,
          ),

          const SizedBox(height: 12.0),

          // Module Title: 15px semibold, tight line height
          Text(
            title,
            style: AppTypography.titleSm(color: colors.text),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Custom painter for BudgetSplit's 56x56 vertically-split coin icon.
class _BudgetSplitIconPainter extends CustomPainter {
  final Color blueColor;
  final Color greenColor;
  final Color circleFillColor;
  final Color trackColor;

  _BudgetSplitIconPainter({
    required this.blueColor,
    required this.greenColor,
    required this.circleFillColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 22.0;

    // Subtle outer track ring
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, 24.0, trackPaint);

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Left half: Blue (sweep counter-clockwise or from -pi/2 to -pi)
    final bluePaint = Paint()
      ..color = blueColor
      ..style = PaintingStyle.fill;
    canvas.drawArc(rect, math.pi / 2, math.pi, true, bluePaint);

    // Right half: Green (from -pi/2 to pi/2)
    final greenPaint = Paint()
      ..color = greenColor
      ..style = PaintingStyle.fill;
    canvas.drawArc(rect, -math.pi / 2, math.pi, true, greenPaint);

    // Dividing center seam
    final seamPaint = Paint()
      ..color = circleFillColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      seamPaint,
    );

    // Center currency glyph ($ sign overlay)
    final dollarPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.75
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Vertical spine: M28 17 V39
    canvas.drawLine(
      const Offset(28.0, 17.0),
      const Offset(28.0, 39.0),
      dollarPaint,
    );

    // Dollar S-curve path:
    // M23 22.5 C23 20.5 25 19 28 19 C31 19 33 20.5 33 22.5 C33 25 30 26 28 27
    // C25.5 28 23 29.5 23 32 C23 34.5 25 36 28 36 C31 36 33 34.5 33 32.5
    final sPath = Path()
      ..moveTo(23.0, 22.5)
      ..cubicTo(23.0, 20.5, 25.0, 19.0, 28.0, 19.0)
      ..cubicTo(31.0, 19.0, 33.0, 20.5, 33.0, 22.5)
      ..cubicTo(33.0, 25.0, 30.0, 26.0, 28.0, 27.0)
      ..cubicTo(25.5, 28.0, 23.0, 29.5, 23.0, 32.0)
      ..cubicTo(23.0, 34.5, 25.0, 36.0, 28.0, 36.0)
      ..cubicTo(31.0, 36.0, 33.0, 34.5, 33.0, 32.5);

    canvas.drawPath(sPath, dollarPaint);
  }

  @override
  bool shouldRepaint(covariant _BudgetSplitIconPainter oldDelegate) {
    return oldDelegate.blueColor != blueColor ||
        oldDelegate.greenColor != greenColor ||
        oldDelegate.circleFillColor != circleFillColor ||
        oldDelegate.trackColor != trackColor;
  }
}

/// Custom painter for Habits' 56x56 donut chart icon (~62% filled in indigo).
class _HabitsDonutIconPainter extends CustomPainter {
  final Color indigoColor;
  final Color trackColor;
  final Color textColor;

  _HabitsDonutIconPainter({
    required this.indigoColor,
    required this.trackColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 20.0;
    const strokeWidth = 5.5;

    // Inactive grey track (full circle)
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    // Active progress stroke in Indigo (62% of circumference, start at top -pi/2)
    final progressPaint = Paint()
      ..color = indigoColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius);
    const sweepAngle = 2 * math.pi * 0.62;
    canvas.drawArc(rect, -math.pi / 2, sweepAngle, false, progressPaint);

    // Center percentage text: "62%" in DM Mono 12px bold (700)
    final textPainter = TextPainter(
      text: TextSpan(
        text: '62%',
        style: GoogleFonts.dmMono(
          fontSize: 12.0,
          fontWeight: FontWeight.w700,
          color: textColor,
          letterSpacing: -0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();
    final textOffset = Offset(
      center.dx - (textPainter.width / 2),
      center.dy - (textPainter.height / 2),
    );
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant _HabitsDonutIconPainter oldDelegate) {
    return oldDelegate.indigoColor != indigoColor ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.textColor != textColor;
  }
}
