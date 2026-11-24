// =============================================================================
// BudgetSplit - Category Model
// =============================================================================
// Budget category data model with preset categories, icons, and percentage allocation.
// =============================================================================

import 'dart:convert';

/// Representation of a single budget category item.
/// Each category includes an icon, standard or custom name, and percentage allocation.
class BudgetCategory {
  final String id;
  final String name;
  final String icon;
  final String pct; // Stored as string to preserve user keystrokes (e.g., "20", "33.33")
  final String? customName;

  const BudgetCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.pct,
    this.customName,
  });

  /// 22 Standard Preset Category Options from specification
  static const List<Map<String, String>> presetCategories = [
    {'name': 'Savings', 'icon': '🏦'},
    {'name': 'Personal', 'icon': '👤'},
    {'name': 'Business', 'icon': '💼'},
    {'name': 'Transport', 'icon': '🚌'},
    {'name': 'Food', 'icon': '🍱'},
    {'name': 'Groceries', 'icon': '🛒'},
    {'name': 'Rent / EMI', 'icon': '🏠'},
    {'name': 'Mobile / Internet', 'icon': '📱'},
    {'name': 'Electricity', 'icon': '💡'},
    {'name': 'Medical', 'icon': '💊'},
    {'name': 'Education', 'icon': '📚'},
    {'name': 'Entertainment', 'icon': '🎬'},
    {'name': 'Clothing', 'icon': '👕'},
    {'name': 'Fuel', 'icon': '⛽'},
    {'name': 'Travel', 'icon': '✈️'},
    {'name': 'Gym / Health', 'icon': '🏋️'},
    {'name': 'Insurance', 'icon': '🛡️'},
    {'name': 'Gifts', 'icon': '🎁'},
    {'name': 'Household', 'icon': '🧹'},
    {'name': 'Emergency Fund', 'icon': '🆘'},
    {'name': 'Investments', 'icon': '📈'},
    {'name': 'Custom', 'icon': '✏️'},
  ];

  /// Creates default initial category list with blank percentage allocations
  static List<BudgetCategory> defaultCategories() {
    final now = DateTime.now().millisecondsSinceEpoch;
    return [
      BudgetCategory(id: '${now}_1', name: 'Savings', icon: '🏦', pct: ''),
      BudgetCategory(id: '${now}_2', name: 'Personal', icon: '👤', pct: ''),
      BudgetCategory(id: '${now}_3', name: 'Business', icon: '💼', pct: ''),
      BudgetCategory(id: '${now}_4', name: 'Transport', icon: '🚌', pct: ''),
    ];
  }

  /// Initial empty state categories (all blank percentages)
  static List<BudgetCategory> emptyInitialCategories() {
    final now = DateTime.now().millisecondsSinceEpoch;
    return [
      BudgetCategory(id: '${now}_1', name: 'Savings', icon: '🏦', pct: ''),
      BudgetCategory(id: '${now}_2', name: 'Personal', icon: '👤', pct: ''),
      BudgetCategory(id: '${now}_3', name: 'Business', icon: '💼', pct: ''),
      BudgetCategory(id: '${now}_4', name: 'Transport', icon: '🚌', pct: ''),
    ];
  }

  /// User-facing display name, resolving Custom name if specified
  String get displayName {
    if (name == 'Custom' && customName != null && customName!.trim().isNotEmpty) {
      return customName!.trim();
    }
    return name;
  }

  /// Parses percentage string to numerical double value
  double get percentageValue {
    if (pct.trim().isEmpty) return 0.0;
    final parsed = double.tryParse(pct.trim().replaceAll('%', ''));
    if (parsed == null || parsed.isNaN || parsed.isInfinite) return 0.0;
    return parsed < 0 ? 0.0 : parsed;
  }

  BudgetCategory copyWith({
    String? id,
    String? name,
    String? icon,
    String? pct,
    String? customName,
  }) {
    return BudgetCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      pct: pct ?? this.pct,
      customName: customName ?? this.customName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'pct': pct,
      'customName': customName,
    };
  }

  factory BudgetCategory.fromMap(Map<dynamic, dynamic> map) {
    return BudgetCategory(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      icon: map['icon']?.toString() ?? '🏷️',
      pct: map['pct']?.toString() ?? '',
      customName: map['customName']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory BudgetCategory.fromJson(String source) =>
      BudgetCategory.fromMap(json.decode(source) as Map<dynamic, dynamic>);
}
