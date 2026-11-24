// =============================================================================
// Core Utility - Number Formatter
// =============================================================================
// Indian rupee formatting and compact number display utilities.
// =============================================================================

import 'package:intl/intl.dart';

/// Formatter for numerical values, currencies, and percentages.
/// Specializes in Indian currency grouping (e.g. ₹1,00,000).
class NumberFormatter {
  NumberFormatter._();

  static final NumberFormat _indianCurrency = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final NumberFormat _indianCurrencyWithDecimals = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static final NumberFormat _indianNumber = NumberFormat.decimalPattern('en_IN');

  /// Formats amount in Indian numbering system with optional symbol and decimal places.
  /// Example: 100000 -> "₹1,00,000"
  static String formatCurrency(
    num amount, {
    bool showDecimals = false,
    String symbol = '₹',
  }) {
    final isNegative = amount < 0;
    final absAmount = amount.abs();

    String formatted;
    if (showDecimals) {
      formatted = _indianCurrencyWithDecimals.format(absAmount);
    } else {
      formatted = _indianCurrency.format(absAmount);
    }

    if (symbol != '₹') {
      formatted = formatted.replaceFirst('₹', symbol);
    }

    return isNegative ? '-$formatted' : formatted;
  }

  /// Formats raw number with Indian numbering grouping without currency symbol.
  /// Example: 100000 -> "1,00,000"
  static String formatIndianNumber(num amount) {
    return _indianNumber.format(amount);
  }

  /// Compact representation for tight spaces (e.g. ₹50k, ₹1.5L, ₹2.4Cr)
  static String formatCompactCurrency(num amount, {String symbol = '₹'}) {
    final absAmount = amount.abs();
    final isNegative = amount < 0;
    String prefix = isNegative ? '-$symbol' : symbol;

    if (absAmount >= 10000000) {
      final cr = absAmount / 10000000;
      return '$prefix${cr.toStringAsFixed(cr.truncateToDouble() == cr ? 0 : 1)}Cr';
    } else if (absAmount >= 100000) {
      final l = absAmount / 100000;
      return '$prefix${l.toStringAsFixed(l.truncateToDouble() == l ? 0 : 1)}L';
    } else if (absAmount >= 1000) {
      final k = absAmount / 1000;
      return '$prefix${k.toStringAsFixed(k.truncateToDouble() == k ? 0 : 1)}k';
    } else {
      return '$prefix$absAmount';
    }
  }

  /// Formats percentage value. Example: 62.4 -> "62%" or "62.4%"
  static String formatPercentage(double value, {int decimals = 0}) {
    if (decimals == 0) {
      return '${value.round()}%';
    }
    return '${value.toStringAsFixed(decimals)}%';
  }
}
