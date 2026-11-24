// =============================================================================
// Hub Widget - Connecting Wire
// =============================================================================
// Animated wire/line connecting the two module circles.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';

/// 3px height gradient connecting line between module circles.
/// Features a continuous animated travelling light (36px wide radial gradient blob)
/// moving left to right on a 3.2s loop, disabled when reduced motion is active.
class ConnectingWire extends StatefulWidget {
  final double height;
  final double pulseWidth;
  final double pulseHeight;

  const ConnectingWire({
    super.key,
    this.height = AppConstants.wireThickness, // 3.0
    this.pulseWidth = 36.0,
    this.pulseHeight = 8.0,
  });

  @override
  State<ConnectingWire> createState() => _ConnectingWireState();
}

class _ConnectingWireState extends State<ConnectingWire>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppConstants.durationWirePulse, // 3200ms
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduceMotion) {
      _controller.stop();
    } else {
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;

        return SizedBox(
          height: widget.pulseHeight,
          width: totalWidth,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Base 3px gradient wire
              Container(
                height: widget.height,
                width: totalWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      colors.budgetBlue,
                      colors.budgetGreen,
                      colors.habitsIndigo,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),

              // Animated traveling photon light blob
              if (!reduceMotion && totalWidth > 0)
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final t = _controller.value;
                    // Moves from -15% to 115% of width
                    // Fade in from 0% to 15%, solid until 85%, fade out to 100%
                    final startX = -widget.pulseWidth;
                    final endX = totalWidth;
                    final currentX = startX + (endX - startX) * t;

                    double opacity = 1.0;
                    if (t < 0.15) {
                      opacity = t / 0.15;
                    } else if (t > 0.85) {
                      opacity = (1.0 - t) / 0.15;
                    }

                    return Positioned(
                      left: currentX,
                      top: (widget.pulseHeight - widget.pulseHeight) / 2,
                      child: Opacity(
                        opacity: opacity.clamp(0.0, 1.0),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    width: widget.pulseWidth,
                    height: widget.pulseHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                      gradient: const RadialGradient(
                        colors: [
                          Color(0xF2FFFFFF), // rgba(255, 255, 255, 0.95)
                          Color(0x00FFFFFF), // transparent
                        ],
                        stops: [0.0, 0.8],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
