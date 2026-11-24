// =============================================================================
// Habits - Category Model
// =============================================================================
// 20 predefined focus categories with unique badge colors for habit classification.
// =============================================================================

import 'package:flutter/material.dart';

/// Category model for habits grouping and chromatic identity.
class HabitCategory {
  final String name;
  final String color;
  final bool custom;

  const HabitCategory({
    required this.name,
    required this.color,
    this.custom = false,
  });

  /// Parse hex color string (e.g. "#EF4444" or "EF4444") to Flutter Color
  Color get colorValue {
    try {
      String hex = color.replaceAll('#', '').trim();
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return const Color(0xFF6C63FF);
    }
  }

  HabitCategory copyWith({
    String? name,
    String? color,
    bool? custom,
  }) {
    return HabitCategory(
      name: name ?? this.name,
      color: color ?? this.color,
      custom: custom ?? this.custom,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'color': color,
      'custom': custom,
    };
  }

  factory HabitCategory.fromMap(Map<dynamic, dynamic> map) {
    return HabitCategory(
      name: map['name'] as String? ?? 'General',
      color: map['color'] as String? ?? '#6C63FF',
      custom: map['custom'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitCategory &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          color == other.color &&
          custom == other.custom;

  @override
  int get hashCode => Object.hash(name, color, custom);

  /// 20 Immutable Default Presets specified in Calibrated Precision design
  static const List<HabitCategory> defaultCategories = [
    HabitCategory(name: 'Health & Fitness', color: '#EF4444'),
    HabitCategory(name: 'Study & Learning', color: '#3B82F6'),
    HabitCategory(name: 'Work & Career', color: '#8B5CF6'),
    HabitCategory(name: 'Morning Routine', color: '#F59E0B'),
    HabitCategory(name: 'Evening Routine', color: '#F97316'),
    HabitCategory(name: 'Meditation', color: '#14B8A6'),
    HabitCategory(name: 'Nutrition & Diet', color: '#22C55E'),
    HabitCategory(name: 'Sleep & Rest', color: '#6366F1'),
    HabitCategory(name: 'Reading & Books', color: '#A16207'),
    HabitCategory(name: 'Finance', color: '#84CC16'),
    HabitCategory(name: 'Social & Family', color: '#EC4899'),
    HabitCategory(name: 'Creativity', color: '#F43F5E'),
    HabitCategory(name: 'Sports', color: '#06B6D4'),
    HabitCategory(name: 'Hygiene', color: '#64748B'),
    HabitCategory(name: 'Hydration', color: '#0EA5E9'),
    HabitCategory(name: 'Journaling', color: '#D97706'),
    HabitCategory(name: 'Digital Detox', color: '#4ADE80'),
    HabitCategory(name: 'Skill Development', color: '#A855F7'),
    HabitCategory(name: 'Gratitude & Positivity', color: '#EAB308'),
    HabitCategory(name: 'Weekend Planning', color: '#FB7185'),
  ];
}
