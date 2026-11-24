// =============================================================================
// BudgetSplit - Plan Model
// =============================================================================
// Saved budget plan with serialization for Hive local storage persistence.
// =============================================================================

import 'dart:convert';
import 'package:intl/intl.dart';
import 'budget_category.dart';

/// Representation of a saved budget plan.
/// Contains the complete allocation snapshot, including total budget, categories,
/// calculated percentages, and persistent timestamp.
class BudgetPlan {
  final String id;
  final String name;
  final double total;
  final double allocPct;
  final double allocAmt;
  final String date;
  final List<BudgetCategory> categories;

  const BudgetPlan({
    required this.id,
    required this.name,
    required this.total,
    required this.allocPct,
    required this.allocAmt,
    required this.date,
    required this.categories,
  });

  /// Formatted date string for new plans (e.g. "12 Nov 2026")
  static String formatCurrentDate() {
    return DateFormat('dd MMM yyyy').format(DateTime.now());
  }

  /// Calculates remaining unallocated rupees
  double get remainingAmount => total - allocAmt;

  /// Whether the plan exceeds 100% total allocation
  bool get isOverBudget => allocPct > 100.0001;

  BudgetPlan copyWith({
    String? id,
    String? name,
    double? total,
    double? allocPct,
    double? allocAmt,
    String? date,
    List<BudgetCategory>? categories,
  }) {
    return BudgetPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      total: total ?? this.total,
      allocPct: allocPct ?? this.allocPct,
      allocAmt: allocAmt ?? this.allocAmt,
      date: date ?? this.date,
      categories: categories ?? this.categories,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'total': total,
      'allocPct': allocPct,
      'allocAmt': allocAmt,
      'date': date,
      'cats': categories.map((c) => c.toMap()).toList(),
    };
  }

  factory BudgetPlan.fromMap(Map<dynamic, dynamic> map) {
    final rawCats = map['cats'] ?? map['categories'];
    List<BudgetCategory> catsList = [];
    if (rawCats is List) {
      catsList = rawCats
          .map((item) => item is Map
              ? BudgetCategory.fromMap(item)
              : BudgetCategory.fromJson(item.toString()))
          .toList();
    }

    return BudgetPlan(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? 'Plan',
      total: (map['total'] as num?)?.toDouble() ?? 0.0,
      allocPct: (map['allocPct'] as num?)?.toDouble() ?? 0.0,
      allocAmt: (map['allocAmt'] as num?)?.toDouble() ?? 0.0,
      date: map['date']?.toString() ?? '',
      categories: catsList,
    );
  }

  String toJson() => json.encode(toMap());

  factory BudgetPlan.fromJson(String source) =>
      BudgetPlan.fromMap(json.decode(source) as Map<dynamic, dynamic>);
}
