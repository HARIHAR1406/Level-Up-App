// =============================================================================
// Hub Widget - Error Panel
// =============================================================================
// Error state display with message and retry button.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Error state presentation view (matching State 7 in design specifications).
/// Displays alert icon in red-tinted circle, error explanation, and blue "Try again" CTA.
class ErrorPanel extends StatefulWidget {
  final String errorMessage;
  final VoidCallback onTryAgain;

  const ErrorPanel({
    super.key,
    required this.errorMessage,
    required this.onTryAgain,
  });

  @override
  State<ErrorPanel> createState() => _ErrorPanelState();
}

class _ErrorPanelState extends State<ErrorPanel> {
  bool _isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      color: colors.bg,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 48x48 Red-tinted circular icon container
            Container(
              width: 48.0,
              height: 48.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.danger.withOpacity(0.10),
                border: Border.all(
                  color: colors.danger.withOpacity(0.30),
                  width: 1.0,
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.error_outline_rounded,
                size: 24.0,
                color: colors.danger,
              ),
            ),

            const SizedBox(height: 16.0),

            // Centred error explanation: 15px font-normal
            Text(
              widget.errorMessage,
              style: AppTypography.titleSm(
                color: colors.text,
              ).copyWith(
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24.0),

            // Blue "Try again" CTA button (42px height, 12px radius)
            GestureDetector(
              onTapDown: (_) => setState(() => _isButtonPressed = true),
              onTapUp: (_) => setState(() => _isButtonPressed = false),
              onTapCancel: () => setState(() => _isButtonPressed = false),
              onTap: widget.onTryAgain,
              child: AnimatedScale(
                scale: _isButtonPressed ? 0.95 : 1.0,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
                child: Container(
                  height: AppConstants.minTouchTarget, // 42.0
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  decoration: BoxDecoration(
                    color: colors.budgetBlue,
                    borderRadius: BorderRadius.circular(AppConstants.radiusButton),
                    boxShadow: [
                      BoxShadow(
                        color: colors.budgetBlue.withOpacity(0.30),
                        blurRadius: 12.0,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Try again',
                    style: AppTypography.titleSm(color: Colors.white).copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
