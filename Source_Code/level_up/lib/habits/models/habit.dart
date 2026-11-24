// =============================================================================
// Habits - Habit Model
// =============================================================================
// Single habit data model with name, percentage weight, time window, and category.
// =============================================================================

/// Habit item model representing a single task or habit.
class Habit {
  final int id;
  final String name;
  final double pct;
  final String from;
  final String to;
  final int catIdx;
  final bool done;
  final int createdAt;

  const Habit({
    required this.id,
    required this.name,
    required this.pct,
    required this.from,
    required this.to,
    required this.catIdx,
    this.done = false,
    required this.createdAt,
  });

  Habit copyWith({
    int? id,
    String? name,
    double? pct,
    String? from,
    String? to,
    int? catIdx,
    bool? done,
    int? createdAt,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      pct: pct ?? this.pct,
      from: from ?? this.from,
      to: to ?? this.to,
      catIdx: catIdx ?? this.catIdx,
      done: done ?? this.done,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'pct': pct,
      'from': from,
      'to': to,
      'catIdx': catIdx,
      'done': done,
      'createdAt': createdAt,
    };
  }

  factory Habit.fromMap(Map<dynamic, dynamic> map) {
    return Habit(
      id: (map['id'] as num?)?.toInt() ?? 0,
      name: map['name'] as String? ?? '',
      pct: (map['pct'] as num?)?.toDouble() ?? 0.0,
      from: map['from'] as String? ?? '06:00 AM',
      to: map['to'] as String? ?? '07:00 AM',
      catIdx: (map['catIdx'] as num?)?.toInt() ?? 0,
      done: map['done'] as bool? ?? false,
      createdAt: (map['createdAt'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Habit &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          pct == other.pct &&
          from == other.from &&
          to == other.to &&
          catIdx == other.catIdx &&
          done == other.done &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(id, name, pct, from, to, catIdx, done, createdAt);
}
