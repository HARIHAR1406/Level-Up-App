// =============================================================================
// Core Widget - Toast Notification
// =============================================================================
// Custom snackbar notification component with icon and styled container.
// =============================================================================

import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Floating toast pill notification.
/// Automatically dismisses after 2.3 seconds (AppConstants.durationToast).
class ToastNotification extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Color? iconColor;

  const ToastNotification({
    super.key,
    required this.message,
    this.icon,
    this.iconColor,
  });

  /// Displays an ephemeral toast message in the current overlay.
  static void show(
    BuildContext context, {
    required String message,
    IconData? icon,
    Color? iconColor,
    Duration duration = AppConstants.durationToast,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (ctx) => _ToastOverlayWidget(
        message: message,
        icon: icon,
        iconColor: iconColor,
        duration: duration,
        onDismissed: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: colors.surface2,
        borderRadius: BorderRadius.circular(AppConstants.radiusPill),
        border: Border.all(color: colors.border, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 16.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: iconColor ?? colors.budgetBlue,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              message,
              style: AppTypography.bodySm(
                color: colors.text,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToastOverlayWidget extends StatefulWidget {
  final String message;
  final IconData? icon;
  final Color? iconColor;
  final Duration duration;
  final VoidCallback onDismissed;

  const _ToastOverlayWidget({
    required this.message,
    this.icon,
    this.iconColor,
    required this.duration,
    required this.onDismissed,
  });

  @override
  State<_ToastOverlayWidget> createState() => _ToastOverlayWidgetState();
}

class _ToastOverlayWidgetState extends State<_ToastOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _offset = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();

    Future.delayed(widget.duration, () async {
      if (mounted) {
        await _controller.reverse();
        widget.onDismissed();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40.0 + MediaQuery.paddingOf(context).bottom,
      left: 20.0,
      right: 20.0,
      child: Center(
        child: FadeTransition(
          opacity: _opacity,
          child: SlideTransition(
            position: _offset,
            child: Material(
              color: Colors.transparent,
              child: ToastNotification(
                message: widget.message,
                icon: widget.icon,
                iconColor: widget.iconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
