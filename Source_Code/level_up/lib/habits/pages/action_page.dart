// =============================================================================
// Habits Page - Action
// =============================================================================
// Today's habits list with tap-to-complete circles, progress summary, and category filters.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../models/habit.dart';
import '../providers/habits_provider.dart';
import '../utils/habit_calculator.dart';
import '../widgets/habit_card.dart';
import '../widgets/reset_timer.dart';

/// Action Page: Daily management hub displaying Today's Habits, dual stat gauges,
/// category filters, habit cards with live progress bars, and edit modal bottom sheet.
class ActionPage extends StatelessWidget {
  const ActionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitsProvider>();
    final colors = AppColors.of(context);

    final habits = provider.filteredHabits;
    final categories = provider.categories;
    final completedPct = provider.completedPct;
    final remainingPct = provider.remainingPct;
    final completedCount = provider.completedCount;
    final pendingCount = provider.pendingCount;
    final totalCount = provider.totalCount;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Title Area
              Text(
                "Today's Habits",
                style: AppTypography.headlineLg(
                  color: colors.text,
                ).copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Stay consistent. Complete your daily goals.',
                style: AppTypography.bodyMd(
                  color: colors.muted,
                ),
              ),
              const SizedBox(height: 16),

              // 2. Dual Stat Gauges (Completed / Remaining)
              Row(
                children: [
                  // Completed Card
                  Expanded(
                    child: _MetricCard(
                      label: 'Completed',
                      pctText: HabitCalculator.formatPct(completedPct),
                      subtext: '$completedCount habits done',
                      accentColor: colors.habitsAccent,
                      iconWidget: SizedBox(
                        width: 28,
                        height: 28,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: (completedPct / 100).clamp(0.0, 1.0),
                              strokeWidth: 3,
                              backgroundColor: colors.surface2,
                              color: colors.habitsAccent,
                            ),
                            Icon(Icons.done, size: 14, color: colors.habitsAccent),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Remaining Card
                  Expanded(
                    child: _MetricCard(
                      label: 'Remaining',
                      pctText: HabitCalculator.formatPct(remainingPct),
                      subtext: '$pendingCount habits pending',
                      accentColor: const Color(0xFFB65C00),
                      iconWidget: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFFB785).withOpacity(0.25),
                        ),
                        child: const Icon(
                          Icons.pending_actions,
                          size: 16,
                          color: Color(0xFFB65C00),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 3. Reset Countdown Bar
              ResetTimerWidget(countdownText: provider.countdownString),
              const SizedBox(height: 18),

              // 4. Horizontal Category Filter Chips
              Text(
                'FILTER BY FOCUS',
                style: AppTypography.bodySm(
                  color: colors.muted,
                  fontWeight: FontWeight.w700,
                ).copyWith(
                  fontSize: 11,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    // "All" chip
                    _FilterChip(
                      label: 'All',
                      countText: '$totalCount',
                      isSelected: provider.selectedCategory == 'all',
                      onTap: () => provider.setCategoryFilter('all'),
                    ),
                    const SizedBox(width: 8),

                    // Active category chips
                    ...provider.activeFilterCategories.map((cat) {
                      final isSelected = provider.selectedCategory.toLowerCase() ==
                          cat.name.toLowerCase();
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _FilterChip(
                          label: cat.name,
                          colorDot: cat.colorValue,
                          isSelected: isSelected,
                          onTap: () => provider.setCategoryFilter(cat.name),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 5. Habit List Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Your Habits',
                        style: AppTypography.headlineSm(
                          color: colors.text,
                        ).copyWith(fontSize: 17, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: colors.surface2,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${habits.length}',
                          style: AppTypography.metricSm(
                            color: colors.muted,
                          ).copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  if (habits.isNotEmpty)
                    Text(
                      'Tap circle to mark complete',
                      style: AppTypography.bodySm(
                        color: colors.muted,
                      ).copyWith(fontSize: 11),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              if (habits.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(Icons.inbox_outlined, size: 48, color: colors.muted),
                      const SizedBox(height: 12),
                      Text(
                        provider.habits.isEmpty
                            ? 'No habits added yet'
                            : 'No habits found for this filter.',
                        style: AppTypography.headlineSm(color: colors.text).copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (provider.habits.isEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Tap Create below to define your daily habits and percentages.',
                          style: AppTypography.bodySm(color: colors.muted),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                )
              else
                ...habits.map((habit) {
                  final cat = (habit.catIdx >= 0 && habit.catIdx < categories.length)
                      ? categories[habit.catIdx]
                      : categories.first;

                  return HabitCardWidget(
                    habit: habit,
                    category: cat,
                    onToggle: () => provider.toggleHabit(habit.id),
                    onEdit: () => _openEditBottomSheet(context, habit),
                    onDelete: () => _confirmDeleteHabit(context, habit),
                  );
                }),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeleteHabit(BuildContext context, Habit habit) {
    final colors = AppColors.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text('Delete Habit', style: AppTypography.headlineSm(color: colors.text)),
        content: Text(
          'Are you sure you want to remove "${habit.name}"?',
          style: AppTypography.bodyMd(color: colors.muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: AppTypography.bodySm(color: colors.muted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: colors.danger),
            onPressed: () {
              context.read<HabitsProvider>().deleteHabit(habit.id);
              Navigator.of(ctx).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _openEditBottomSheet(BuildContext context, Habit habit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _EditHabitModal(habit: habit),
    );
  }
}

/// Dual Stat Metric Card
class _MetricCard extends StatelessWidget {
  final String label;
  final String pctText;
  final String subtext;
  final Color accentColor;
  final Widget iconWidget;

  const _MetricCard({
    required this.label,
    required this.pctText,
    required this.subtext,
    required this.accentColor,
    required this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.isDark ? colors.surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.border.withOpacity(colors.isDark ? 0.6 : 0.8),
          width: 1,
        ),
        boxShadow: colors.isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTypography.bodySm(
                  color: colors.muted,
                  fontWeight: FontWeight.w600,
                ).copyWith(fontSize: 13),
              ),
              iconWidget,
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                pctText,
                style: AppTypography.metricDisplay(
                  color: accentColor,
                ).copyWith(fontSize: 28, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtext,
            style: AppTypography.bodySm(
              color: colors.muted,
            ).copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

/// Category Filter Chip
class _FilterChip extends StatelessWidget {
  final String label;
  final String? countText;
  final Color? colorDot;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.countText,
    this.colorDot,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final Color bgColor = isSelected
        ? colors.habitsAccent
        : (colors.isDark ? colors.surface : Colors.white);
    final Color textColor = isSelected ? Colors.white : colors.text;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(9999),
      elevation: isSelected ? 1 : 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(
              color: isSelected
                  ? colors.habitsAccent
                  : colors.border.withOpacity(colors.isDark ? 0.6 : 0.8),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (colorDot != null) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorDot,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: AppTypography.bodySm(
                  color: textColor,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ).copyWith(fontSize: 13),
              ),
              if (countText != null) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    countText!,
                    style: AppTypography.metricSm(color: Colors.white)
                        .copyWith(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Modal Bottom Sheet for Editing a Habit
class _EditHabitModal extends StatefulWidget {
  final Habit habit;

  const _EditHabitModal({required this.habit});

  @override
  State<_EditHabitModal> createState() => _EditHabitModalState();
}

class _EditHabitModalState extends State<_EditHabitModal> {
  late TextEditingController _nameController;
  late TextEditingController _pctController;
  late TextEditingController _fromController;
  late TextEditingController _toController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit.name);
    _pctController = TextEditingController(
      text: HabitCalculator.formatPctNumber(widget.habit.pct),
    );
    _fromController = TextEditingController(text: widget.habit.from);
    _toController = TextEditingController(text: widget.habit.to);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pctController.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  Future<void> _pickTime(TextEditingController controller) async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: now,
    );
    if (picked != null) {
      if (!mounted) return;
      final formatted = picked.format(context);
      controller.text = formatted;
    }
  }

  void _saveChanges() {
    final name = _nameController.text.trim();
    final pct = double.tryParse(_pctController.text.trim()) ?? 0.0;
    final from = _fromController.text.trim();
    final to = _toController.text.trim();

    if (name.isEmpty || pct <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid name and positive percentage.')),
      );
      return;
    }

    context.read<HabitsProvider>().updateHabit(
          id: widget.habit.id,
          name: name,
          pct: pct,
          from: from.isEmpty ? widget.habit.from : from,
          to: to.isEmpty ? widget.habit.to : to,
        );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottomInset),
      decoration: BoxDecoration(
        color: colors.isDark ? colors.surface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sheet Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.border,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Sheet Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit Habit',
                        style: AppTypography.headlineSm(color: colors.text)
                            .copyWith(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Update execution specs and weight allocation',
                        style: AppTypography.bodySm(color: colors.muted),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: colors.muted),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Habit Name
              Text(
                'Habit Name',
                style: AppTypography.bodySm(color: colors.text, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                style: AppTypography.bodyMd(color: colors.text),
                decoration: InputDecoration(
                  fillColor: colors.surface2,
                  filled: true,
                  hintText: 'Enter habit name',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Percentage Weight
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Percentage Weight',
                    style: AppTypography.bodySm(color: colors.text, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Positive decimal',
                    style: AppTypography.bodySm(color: colors.muted).copyWith(fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _pctController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: AppTypography.metricMd(color: colors.text).copyWith(fontSize: 16),
                decoration: InputDecoration(
                  fillColor: colors.surface2,
                  filled: true,
                  suffixText: '%',
                  suffixStyle: AppTypography.metricSm(color: colors.habitsAccent)
                      .copyWith(fontWeight: FontWeight.w700),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Time Window Grid (From / To)
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'From',
                          style: AppTypography.bodySm(color: colors.text, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () => _pickTime(_fromController),
                          child: AbsorbPointer(
                            child: TextField(
                              controller: _fromController,
                              style: AppTypography.bodyMd(color: colors.text),
                              decoration: InputDecoration(
                                fillColor: colors.surface2,
                                filled: true,
                                suffixIcon: Icon(Icons.schedule, size: 16, color: colors.muted),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'To',
                          style: AppTypography.bodySm(color: colors.text, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () => _pickTime(_toController),
                          child: AbsorbPointer(
                            child: TextField(
                              controller: _toController,
                              style: AppTypography.bodyMd(color: colors.text),
                              decoration: InputDecoration(
                                fillColor: colors.surface2,
                                filled: true,
                                suffixIcon: Icon(Icons.schedule, size: 16, color: colors.muted),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // Action Buttons (Cancel & Save)
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: colors.surface2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Cancel',
                          style: AppTypography.bodySm(color: colors.text, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.habitsAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        onPressed: _saveChanges,
                        icon: const Icon(Icons.save, size: 18, color: Colors.white),
                        label: const Text(
                          'Save Changes',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
