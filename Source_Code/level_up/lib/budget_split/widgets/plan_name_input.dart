// =============================================================================
// BudgetSplit Widget - Plan Name Input
// =============================================================================
// Text field for naming budget plans with icon prefix.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';

/// Plan name input field with edit icon and placeholder.
class PlanNameInput extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const PlanNameInput({
    Key? key,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<PlanNameInput> createState() => _PlanNameInputState();
}

class _PlanNameInputState extends State<PlanNameInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant PlanNameInput oldWidget) {
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
        Text(
          'PLAN NAME',
          style: AppTypography.codeBadge(color: colors.muted),
        ),
        const SizedBox(height: 6),
        // Plan Name input following Habits at Percentage design pattern
        TextField(
          controller: _controller,
          textAlignVertical: TextAlignVertical.center,
          style: AppTypography.bodyLg(color: colors.text),
          cursorColor: colors.budgetBlue,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 14, right: 8),
              child: Icon(
                Icons.edit_note,
                size: 20,
                color: colors.muted,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            hintText: 'Enter plan name (e.g. November Salary)',
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
