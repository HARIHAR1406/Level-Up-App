// =============================================================================
// Hub Widget - Footer
// =============================================================================
// Offline privacy notice shown at the bottom of the hub screen.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Bottom footer for the Hub screen.
/// Displays offline privacy assurance: "Works offline · Your data stays on this device".
class HubFooter extends StatelessWidget {
  const HubFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      alignment: Alignment.center,
      child: Text(
        'Works offline · Your data stays on this device',
        style: AppTypography.bodySm(color: colors.muted),
        textAlign: TextAlign.center,
      ),
    );
  }
}
