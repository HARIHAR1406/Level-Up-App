// =============================================================================
// BudgetSplit Widget - Total Budget Input
// =============================================================================
// Rupee currency input field with prefix icon and auto-calculation support.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';

/// Interactive total budget input card.
/// Provides a prominent ₹ prefix, formatted numerical entry,
/// and instant recalculation on every keystroke.
class TotalBudgetInput extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const TotalBudgetInput({
    Key? key,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<TotalBudgetInput> createState() => _TotalBudgetInputState();
}

class _TotalBudgetInputState extends State<TotalBudgetInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant TotalBudgetInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label Row: "TOTAL BUDGET" and "Auto-calc" badge
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'TOTAL BUDGET',
              style: AppTypography.codeBadge(color: colors.muted),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: colors.surface2,
                borderRadius: BorderRadius.circular(AppConstants.radiusPill),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_reset,
                    size: 13,
                    color: colors.budgetGreen,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Auto-calc',
                    style: AppTypography.codeBadge(color: colors.budgetGreen),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Rupee prefix + Large numeric input following Habits at Percentage design pattern
        TextField(
          controller: _controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textAlignVertical: TextAlignVertical.center,
          style: AppTypography.metricMd(color: colors.text).copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          cursorColor: colors.budgetBlue,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 14, right: 8),
              child: Text(
                '₹',
                style: AppTypography.metricMd(color: colors.muted).copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            hintText: 'Enter total budget',
            hintStyle: AppTypography.bodyLg(
              color: colors.muted.withOpacity(0.5),
            ),
            fillColor: colors.surface2,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusInput),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
