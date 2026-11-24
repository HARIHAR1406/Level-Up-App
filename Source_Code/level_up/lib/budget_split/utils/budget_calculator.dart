// =============================================================================
// BudgetSplit - Calculator Utilities
// =============================================================================
// Budget math: percentage allocation, remaining amounts, over-budget detection.
// =============================================================================

import 'package:intl/intl.dart';
import '../models/budget_category.dart';

/// Calculation engine for BudgetSplit.
/// Implements exact arithmetic formulas, Indian currency number formatting,
/// edge cases, and allocation percentages as defined in the specification.
class BudgetCalculator {
  BudgetCalculator._();

  static final NumberFormat _inFormatWithDecimals = NumberFormat('#,##,##0.##', 'en_IN');
  static final NumberFormat _inFormatInteger = NumberFormat('#,##,##0', 'en_IN');

  /// Computes the exact rupee amount for a given category percentage and total budget.
  /// Category Amount = (Category % / 100) * Total Budget
  static double calculateCategoryAmount(double totalBudget, double percentage) {
    if (totalBudget <= 0 || percentage <= 0) return 0.0;
    final amount = (percentage / 100.0) * totalBudget;
    return (amount * 100).roundToDouble() / 100.0;
  }

  /// Sum of all category percentage values
  static double calculateTotalAllocatedPercentage(List<BudgetCategory> categories) {
    double totalPct = 0.0;
    for (final cat in categories) {
      totalPct += cat.percentageValue;
    }
    return (totalPct * 100).roundToDouble() / 100.0;
  }

  /// Sum of all category resolved rupee amounts
  static double calculateTotalAllocatedAmount(
    double totalBudget,
    List<BudgetCategory> categories,
  ) {
    if (totalBudget <= 0) return 0.0;
    double totalAmt = 0.0;
    for (final cat in categories) {
      totalAmt += calculateCategoryAmount(totalBudget, cat.percentageValue);
    }
    return (totalAmt * 100).roundToDouble() / 100.0;
  }

  /// Calculates remaining unallocated rupees. Can be negative when over-budget.
  static double calculateRemainingAmount(double totalBudget, double totalAllocatedAmount) {
    final remaining = totalBudget - totalAllocatedAmount;
    return (remaining * 100).roundToDouble() / 100.0;
  }

  /// Returns true when total percentage exceeds 100%
  static bool isOverBudget(double totalAllocatedPercentage) {
    return totalAllocatedPercentage > 100.0001;
  }

  /// Formats amount in Indian Rupee format (e.g. ₹30,000 or ₹14,998.50)
  /// Trims trailing zeroes (.00 -> "")
  static String formatCurrency(double amount) {
    final rounded = (amount * 100).roundToDouble() / 100.0;
    if (rounded % 1 == 0) {
      return '₹${_inFormatInteger.format(rounded.toInt())}';
    } else {
      return '₹${_inFormatWithDecimals.format(rounded)}';
    }
  }

  /// Formats amount without the ₹ prefix
  static String formatAmountOnly(double amount) {
    final rounded = (amount * 100).roundToDouble() / 100.0;
    if (rounded % 1 == 0) {
      return _inFormatInteger.format(rounded.toInt());
    } else {
      return _inFormatWithDecimals.format(rounded);
    }
  }

  /// Formats percentage value (e.g. 20 -> "20%", 33.33 -> "33.33%")
  static String formatPercentage(double pct) {
    final rounded = (pct * 100).roundToDouble() / 100.0;
    if (rounded % 1 == 0) {
      return '${rounded.toInt()}%';
    } else {
      return '${rounded.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '')}%';
    }
  }

  /// Parses numerical total budget string, removing commas, spaces, currency symbols
  static double parseBudgetInput(String text) {
    if (text.trim().isEmpty) return 0.0;
    final cleaned = text.replaceAll(RegExp(r'[^0-9.]'), '');
    final parsed = double.tryParse(cleaned);
    if (parsed == null || parsed.isNaN || parsed.isInfinite) return 0.0;
    return parsed < 0 ? 0.0 : parsed;
  }
}
