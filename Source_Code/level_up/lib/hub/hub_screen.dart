// =============================================================================
// Level Up Hub - Main Switchboard Screen
// =============================================================================
// The primary home screen displaying:
//   - App header with rotating taglines and theme toggle
//   - Time-based contextual greeting (Good morning / afternoon / evening)
//   - Interactive module launcher circles (BudgetSplit & Habits at Percentage)
//   - Connecting wire animation between module circles
//   - Offline privacy notice footer
// =============================================================================

import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../core/models/enums.dart';
import '../core/theme/app_colors.dart';
import 'hub_controller.dart';
import 'widgets/error_panel.dart';
import 'widgets/greeting_section.dart';
import 'widgets/hub_footer.dart';
import 'widgets/hub_header.dart';
import 'widgets/switchboard_panel.dart';

/// The primary Hub / Switchboard screen of Level Up.
/// Hosts the master header with tagline rotator, contextual time greeting,
/// encapsulated 28px switchboard panel with interactive module launcher circles,
/// and offline telemetry footer.
class HubScreen extends StatefulWidget {
  const HubScreen({super.key});

  @override
  State<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends State<HubScreen> {
  late final HubController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HubController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onModuleSelected(AppModule module) {
    _controller.openModule(context, module);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.bg,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          // If error state is active, display ErrorPanel (State 7)
          if (_controller.errorMessage != null) {
            return SafeArea(
              child: ErrorPanel(
                errorMessage: _controller.errorMessage!,
                onTryAgain: () => _controller.refreshBadges(),
              ),
            );
          }

          return SafeArea(
            top: true,
            bottom: true,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppConstants.maxViewportWidth, // 430px
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 12.0),

                      // SECTION A: Top Header (App title, tagline rotator, theme toggle)
                      const HubHeader(),

                      // SECTION B: Time-based contextual greeting
                      const GreetingSection(),

                      const SizedBox(height: 4.0),

                      // SECTION C: Main Switchboard Console
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: SwitchboardPanel(
                              onModuleTap: _onModuleSelected,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8.0),

                      // SECTION D: Footer (Offline privacy notice)
                      const HubFooter(),

                      const SizedBox(height: 8.0),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
