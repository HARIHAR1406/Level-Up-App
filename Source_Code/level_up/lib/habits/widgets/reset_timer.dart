// =============================================================================
// Habits Widget - Reset Timer
// =============================================================================
// Countdown display showing time remaining until daily midnight reset.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Reset countdown indicator bar showing time remaining until 24-hour cycle reset.
class ResetTimerWidget extends StatefulWidget {
  final String countdownText;

  const ResetTimerWidget({
    super.key,
    required this.countdownText,
  });

  @override
  State<ResetTimerWidget> createState() => _ResetTimerWidgetState();
}

class _ResetTimerWidgetState extends State<ResetTimerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 1.0, end: 2.2).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.8, end: 0.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Animated Ping Dot + "Daily Reset" Label
          Row(
            children: [
              SizedBox(
                width: 14,
                height: 14,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _animController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.habitsAccent.withOpacity(_opacityAnimation.value,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.habitsAccent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'DAILY RESET',
                style: AppTypography.bodySm(
                  color: colors.text,
                  fontWeight: FontWeight.w700,
                ).copyWith(
                  fontSize: 11,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),

          // Right: Schedule Icon + Countdown String
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 15,
                color: colors.muted,
              ),
              const SizedBox(width: 5),
              Text(
                widget.countdownText,
                style: AppTypography.metricSm(
                  color: colors.text,
                ).copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
