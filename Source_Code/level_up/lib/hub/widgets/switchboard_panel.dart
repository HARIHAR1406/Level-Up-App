// =============================================================================
// Hub Widget - Switchboard Panel
// =============================================================================
// Glass-morphism container housing the two module launcher circles.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/models/enums.dart';
import '../../core/theme/app_colors.dart';
import 'connecting_wire.dart';
import 'module_circle.dart';

/// The central 28px rounded rectangle switchboard console.
/// Houses two interactive module launcher circles and the gradient connecting
/// wire with travelling photon pulse.
class SwitchboardPanel extends StatelessWidget {
  final ValueChanged<AppModule> onModuleTap;
  final AppModule? pressedModule;

  const SwitchboardPanel({
    super.key,
    required this.onModuleTap,
    this.pressedModule,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusSwitchboard),
        border: Border.all(
          color: colors.border,
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          // Circle diameter is 124. Center is 62px from top of circle.
          const double circleDiameter = AppConstants.moduleCircleSize;
          const double wireCenterY = circleDiameter / 2;

          return SizedBox(
            width: availableWidth,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // Connecting wire positioned behind circle buttons
                Positioned(
                  top: wireCenterY - (AppConstants.wireThickness / 2),
                  left: availableWidth * 0.18,
                  right: availableWidth * 0.18,
                  child: const ConnectingWire(),
                ),

                // Two Module Circles
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Module 1: BudgetSplit
                    ModuleCircle(
                      module: AppModule.budgetSplit,
                      title: 'BudgetSplit',
                      onTap: () => onModuleTap(AppModule.budgetSplit),
                      isPressed: pressedModule == AppModule.budgetSplit,
                    ),

                    // Module 2: Habits at Percentage
                    ModuleCircle(
                      module: AppModule.habitsAtPercentage,
                      title: 'Habits at Percentage',
                      onTap: () => onModuleTap(AppModule.habitsAtPercentage),
                      isPressed: pressedModule == AppModule.habitsAtPercentage,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
