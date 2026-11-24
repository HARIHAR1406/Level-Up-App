// =============================================================================
// Core Widget - Module Circle Button
// =============================================================================
// Animated circular button used in the hub module launcher.
// =============================================================================

import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';

/// Reusable interactive circular button for module launchers.
/// Implements 4px ring (gradient or solid), radial glow halo, inner circle fill,
/// and spring scale micro-interactions (1.05 hover, 0.93 press, 180ms).
class CircleModuleButton extends StatefulWidget {
  final double size;
  final Gradient? ringGradient;
  final Color? ringColor;
  final double ringWidth;
  final List<BoxShadow>? shadows;
  final Color? innerFillColor;
  final Widget child;
  final VoidCallback? onTap;
  final String? tooltip;
  final bool isPressed;

  const CircleModuleButton({
    super.key,
    this.size = AppConstants.moduleCircleSize,
    this.ringGradient,
    this.ringColor,
    this.ringWidth = 4.0,
    this.shadows,
    this.innerFillColor,
    required this.child,
    this.onTap,
    this.tooltip,
    this.isPressed = false,
  });

  @override
  State<CircleModuleButton> createState() => _CircleModuleButtonState();
}

class _CircleModuleButtonState extends State<CircleModuleButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPointerDown = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    // Target scale calculation:
    // When pressed: 0.93
    // When hovered: 1.05
    // Default rest: 1.0
    double targetScale = 1.0;
    if (_isPointerDown || widget.isPressed) {
      targetScale = 0.93;
    } else if (_isHovered) {
      targetScale = 1.05;
    }

    Widget content = AnimatedScale(
      scale: reduceMotion ? 1.0 : targetScale,
      duration: reduceMotion ? Duration.zero : AppConstants.durationCircleScale,
      curve: const Cubic(0.34, 1.56, 0.64, 1.0), // spring curve from CSS cubic-bezier(0.34, 1.56, 0.64, 1)
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: widget.ringGradient,
          color: widget.ringGradient == null ? (widget.ringColor ?? colors.border) : null,
          boxShadow: widget.shadows,
        ),
        padding: EdgeInsets.all(widget.ringWidth),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.innerFillColor ?? colors.circleFill,
          ),
          alignment: Alignment.center,
          child: widget.child,
        ),
      ),
    );

    if (widget.tooltip != null && widget.tooltip!.isNotEmpty) {
      content = Tooltip(
        message: widget.tooltip!,
        child: content,
      );
    }

    return MouseRegion(
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPointerDown = true),
        onTapUp: (_) => setState(() => _isPointerDown = false),
        onTapCancel: () => setState(() => _isPointerDown = false),
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      ),
    );
  }
}
