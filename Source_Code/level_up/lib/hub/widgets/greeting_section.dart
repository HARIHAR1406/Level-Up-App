// =============================================================================
// Hub Widget - Greeting Section
// =============================================================================
// Time-based contextual greeting text display.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/greeting_helper.dart';

/// Time-based contextual greeting section (15px, muted).
/// Evaluates hour of day to display appropriate salute.
class GreetingSection extends StatelessWidget {
  final DateTime? dateTime;

  const GreetingSection({
    super.key,
    this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final salute = GreetingHelper.getGreeting(dateTime);
    final greetingText = '$salute Pick a tool to work on today.';

    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 22.0, bottom: 8.0),
      child: Text(
        greetingText,
        style: AppTypography.titleSm(
          color: colors.muted,
        ).copyWith(
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
      ),
    );
  }
}
