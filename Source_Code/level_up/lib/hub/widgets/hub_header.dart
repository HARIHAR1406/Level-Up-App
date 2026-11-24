// =============================================================================
// Hub Widget - Header
// =============================================================================
// App title, rotating tagline, and theme toggle button.
// =============================================================================

import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/tagline_rotator.dart';
import '../../core/widgets/theme_toggle_button.dart';

/// Top header of the Hub screen.
/// Contains "Level Up" brand name (30px DM Sans bold), 4.5s rotating tagline
/// with 300ms fade transitions, and the theme toggle button.
class HubHeader extends StatefulWidget {
  const HubHeader({super.key});

  @override
  State<HubHeader> createState() => _HubHeaderState();
}

class _HubHeaderState extends State<HubHeader> {
  final TaglineRotator _rotator = TaglineRotator();
  Timer? _timer;
  double _taglineOpacity = 1.0;
  String _currentTagline = TaglineRotator.taglines[0];

  @override
  void initState() {
    super.initState();
    _currentTagline = TaglineRotator.taglines[0];
    _startTaglineRotation();
  }

  void _startTaglineRotation() {
    _timer?.cancel();
    _timer = Timer.periodic(AppConstants.durationTagline, (_) {
      _rotateTagline();
    });
  }

  void _rotateTagline() {
    if (!mounted) return;

    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduceMotion) {
      setState(() {
        _currentTagline = _rotator.next();
      });
      return;
    }

    // Fade out (300ms)
    setState(() => _taglineOpacity = 0.0);

    Future.delayed(AppConstants.durationTaglineFade, () {
      if (!mounted) return;
      setState(() {
        _currentTagline = _rotator.next();
        _taglineOpacity = 1.0;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _rotator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // App title and rotating tagline
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // "Level Up" - 30px DM Sans bold, letter-spacing -0.02em (-0.6px)
              Text(
                'Level Up',
                style: AppTypography.headlineXlMobile(color: colors.text),
              ),

              const SizedBox(height: 6.0),

              // Rotating tagline with 300ms fade
              SizedBox(
                height: 20.0,
                child: AnimatedOpacity(
                  opacity: reduceMotion ? 1.0 : _taglineOpacity,
                  duration: reduceMotion ? Duration.zero : AppConstants.durationTaglineFade,
                  child: Text(
                    _currentTagline,
                    style: AppTypography.tagline(color: colors.muted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 16.0),

        // Theme toggle button (top-right, matches Habits at Percentage design)
        const ThemeToggleButton(),
      ],
    );
  }
}
