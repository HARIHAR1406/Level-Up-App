// =============================================================================
// BudgetSplit Widget - Category Card
// =============================================================================
// Individual category card with emoji icon, name dropdown, and percentage input.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../models/budget_category.dart';
import '../utils/budget_calculator.dart';

/// Individual category card widget.
/// Contains the emoji icon button, preset dropdown / custom name input,
/// percentage field, live resolved ₹ output, and remove button.
class CategoryCard extends StatefulWidget {
  final BudgetCategory category;
  final double totalBudget;
  final VoidCallback onPickIcon;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onCustomNameChanged;
  final ValueChanged<String> onPctChanged;
  final VoidCallback onDelete;

  const CategoryCard({
    Key? key,
    required this.category,
    required this.totalBudget,
    required this.onPickIcon,
    required this.onNameChanged,
    required this.onCustomNameChanged,
    required this.onPctChanged,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  late TextEditingController _pctController;
  late TextEditingController _customNameController;

  @override
  void initState() {
    super.initState();
    _pctController = TextEditingController(text: widget.category.pct);
    _customNameController =
        TextEditingController(text: widget.category.customName ?? '');
  }

  @override
  void didUpdateWidget(covariant CategoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category.pct != widget.category.pct &&
        widget.category.pct != _pctController.text) {
      _pctController.text = widget.category.pct;
    }
    if (oldWidget.category.customName != widget.category.customName &&
        (widget.category.customName ?? '') != _customNameController.text) {
      _customNameController.text = widget.category.customName ?? '';
    }
  }

  @override
  void dispose() {
    _pctController.dispose();
    _customNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final resolvedAmount = BudgetCalculator.calculateCategoryAmount(
      widget.totalBudget,
      widget.category.percentageValue,
    );

    final isCustom = widget.category.name == 'Custom';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusCard),
        border: Border.all(
          color: colors.border.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Icon button + Full Category Name Dropdown + Delete button
          Row(
            children: [
              // Icon button trigger
              InkWell(
                onTap: widget.onPickIcon,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: colors.surface2,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: colors.border.withOpacity(0.4),
                      width: 0.8,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.category.icon.isNotEmpty ? widget.category.icon : '🏷️',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Full Category Name Dropdown
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: BudgetCategory.presetCategories
                            .any((p) => p['name'] == widget.category.name)
                        ? widget.category.name
                        : 'Custom',
                    isExpanded: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: colors.muted,
                    ),
                    dropdownColor: colors.surface,
                    menuMaxHeight: 320,
                    selectedItemBuilder: (context) {
                      return BudgetCategory.presetCategories.map((item) {
                        final name = item['name']!;
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                            style: AppTypography.headlineSm(color: colors.text).copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList();
                    },
                    items: BudgetCategory.presetCategories.map((item) {
                      final name = item['name']!;
                      final icon = item['icon']!;
                      return DropdownMenuItem<String>(
                        value: name,
                        child: Row(
                          children: [
                            Text(icon, style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                name,
                                style: AppTypography.bodyMd(color: colors.text).copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        widget.onNameChanged(val);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Delete button (✕)
              InkWell(
                onTap: widget.onDelete,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colors.surface2.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: colors.muted,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Row 2: Percentage Allocation Input + Resolved Rupee Value Output
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colors.surface2.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left: Allocation Percentage Input
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Allocation:',
                      style: AppTypography.bodySm(color: colors.muted).copyWith(fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 32,
                      width: 64,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: colors.border.withOpacity(0.5),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _pctController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(decimal: true),
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              style: AppTypography.metricSm(color: colors.text).copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                              cursorColor: colors.budgetBlue,
                              decoration: InputDecoration(
                                hintText: '0',
                                hintStyle: AppTypography.metricSm(
                                  color: colors.muted.withOpacity(0.5),
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: widget.onPctChanged,
                            ),
                          ),
                          Text(
                            '%',
                            style: AppTypography.metricSm(color: colors.budgetBlue).copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Right: Resolved Rupee Value Output
                Text(
                  widget.totalBudget <= 0
                      ? '—'
                      : '= ${BudgetCalculator.formatCurrency(resolvedAmount)}',
                  style: AppTypography.metricSm(
                    color: colors.budgetGreen,
                  ).copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Custom Name text field if 'Custom' is selected (following Habits at Percentage pattern)
          if (isCustom) ...[
            const SizedBox(height: 10),
            TextField(
              controller: _customNameController,
              textAlignVertical: TextAlignVertical.center,
              style: AppTypography.bodyMd(color: colors.text),
              cursorColor: colors.budgetBlue,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 14, right: 8),
                  child: Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: colors.muted,
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                hintText: 'Enter custom category name',
                hintStyle: AppTypography.bodyMd(
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
              onChanged: widget.onCustomNameChanged,
            ),
            const SizedBox(height: 4),
          ],
        ],
      ),
    );
  }
}
