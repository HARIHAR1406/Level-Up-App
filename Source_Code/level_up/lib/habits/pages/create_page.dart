// =============================================================================
// Habits Page - Create
// =============================================================================
// Form for adding and editing habits with name, percentage, time window, and category.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../models/habit_category.dart';
import '../providers/habits_provider.dart';
import '../widgets/category_grid.dart';

/// Create Page: Data entry module for defining habits, assigning percentages,
/// time windows, selecting from 20 default categories, and managing custom categories.
class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pctController = TextEditingController();
  final TextEditingController _fromController = TextEditingController(text: '05:00 PM');
  final TextEditingController _toController = TextEditingController(text: '09:00 PM');
  final TextEditingController _customCatController = TextEditingController();

  int _selectedCategoryIndex = 0; // Default to Health & Fitness
  String _selectedCustomColor = '#06B6D4';
  bool _showToast = false;
  String _toastMessage = 'Habit saved successfully! Added to Today.';

  static const List<String> _paletteColors = [
    '#06B6D4',
    '#6366F1',
    '#EC4899',
    '#10B981',
    '#F59E0B',
    '#8B5CF6',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _pctController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _customCatController.dispose();
    super.dispose();
  }

  void _triggerToast(String message) {
    setState(() {
      _toastMessage = message;
      _showToast = true;
    });

    Future.delayed(const Duration(milliseconds: 3200), () {
      if (mounted) {
        setState(() {
          _showToast = false;
        });
      }
    });
  }

  Future<void> _pickTime(TextEditingController controller) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      if (!mounted) return;
      controller.text = picked.format(context);
    }
  }

  Future<void> _handleSaveHabit() async {
    final name = _nameController.text.trim();
    final pct = double.tryParse(_pctController.text.trim()) ?? 0.0;
    final from = _fromController.text.trim();
    final to = _toController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a habit name.')),
      );
      return;
    }

    if (pct <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Percentage must be greater than 0.')),
      );
      return;
    }

    final provider = context.read<HabitsProvider>();
    final success = await provider.addHabit(
      name: name,
      pct: pct,
      from: from.isEmpty ? '06:00 AM' : from,
      to: to.isEmpty ? '07:00 AM' : to,
      catIdx: _selectedCategoryIndex,
    );

    if (success) {
      _nameController.clear();
      _pctController.clear();
      _triggerToast('Habit saved successfully! Added to Today.');
      // Switch to Action tab after brief delay so user sees their new habit
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          provider.setCurrentTab(0);
        }
      });
    }
  }

  Future<void> _addCustomCategory() async {
    final name = _customCatController.text.trim();
    if (name.isEmpty) return;

    final provider = context.read<HabitsProvider>();
    final added = await provider.addCustomCategory(name, _selectedCustomColor);
    if (added) {
      _customCatController.clear();
      _triggerToast('Custom category "$name" added.');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category name already exists or is invalid.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitsProvider>();
    final colors = AppColors.of(context);
    final categories = provider.categories;

    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Page Introduction Banner
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: colors.habitsAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'NEW ROUTINE ENTRY',
                        style: AppTypography.bodySm(
                          color: colors.habitsAccent,
                          fontWeight: FontWeight.w700,
                        ).copyWith(fontSize: 11, letterSpacing: 1.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Create Habit',
                    style: AppTypography.headlineLg(
                      color: colors.text,
                    ).copyWith(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Build your calculated daily routine, one deliberate percentage at a time.',
                    style: AppTypography.bodySm(color: colors.muted),
                  ),
                  const SizedBox(height: 18),

                  // 2. Main Habit Details Card
                  Container(
                    decoration: BoxDecoration(
                      color: colors.isDark ? colors.surface : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colors.border.withOpacity(colors.isDark ? 0.6 : 0.8),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Habit Name Input
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Habit Name',
                              style: AppTypography.bodySm(
                                color: colors.text,
                                fontWeight: FontWeight.w600,
                              ).copyWith(fontSize: 13),
                            ),
                            Text(
                              'Required',
                              style: AppTypography.bodySm(
                                color: colors.muted,
                              ).copyWith(fontSize: 11),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _nameController,
                          style: AppTypography.bodyMd(color: colors.text),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.edit_note, size: 20, color: colors.muted),
                            hintText: 'Enter your habit name',
                            fillColor: colors.surface2,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Percentage Allocation Input
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Percentage Value',
                              style: AppTypography.bodySm(
                                color: colors.text,
                                fontWeight: FontWeight.w600,
                              ).copyWith(fontSize: 13),
                            ),
                            Text(
                              'Max 100% Total Day',
                              style: AppTypography.bodySm(
                                color: colors.habitsAccent,
                                fontWeight: FontWeight.w600,
                              ).copyWith(fontSize: 11),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _pctController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: AppTypography.metricLg(color: colors.text).copyWith(fontSize: 20),
                          decoration: InputDecoration(
                            hintText: 'Enter your percentage',
                            hintStyle: AppTypography.bodyMd(color: colors.muted),
                            fillColor: colors.surface2,
                            filled: true,
                            suffixText: '%',
                            suffixStyle: AppTypography.metricMd(
                              color: colors.habitsAccent,
                            ).copyWith(fontWeight: FontWeight.w800, fontSize: 18),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.info_outline, size: 14, color: colors.muted),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Set the mathematical weight of this habit toward daily 100%.',
                                style: AppTypography.bodySm(color: colors.muted).copyWith(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Time Window (From & To)
                        Text(
                          'Time Window',
                          style: AppTypography.bodySm(
                            color: colors.text,
                            fontWeight: FontWeight.w600,
                          ).copyWith(fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            // From
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'From',
                                    style: AppTypography.bodySm(color: colors.muted).copyWith(fontSize: 11),
                                  ),
                                  const SizedBox(height: 4),
                                  GestureDetector(
                                    onTap: () => _pickTime(_fromController),
                                    child: AbsorbPointer(
                                      child: TextField(
                                        controller: _fromController,
                                        style: AppTypography.metricSm(color: colors.text)
                                            .copyWith(fontSize: 13),
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.schedule, size: 16, color: colors.muted),
                                          fillColor: colors.surface2,
                                          filled: true,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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

                            // To
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'To',
                                    style: AppTypography.bodySm(color: colors.muted).copyWith(fontSize: 11),
                                  ),
                                  const SizedBox(height: 4),
                                  GestureDetector(
                                    onTap: () => _pickTime(_toController),
                                    child: AbsorbPointer(
                                      child: TextField(
                                        controller: _toController,
                                        style: AppTypography.metricSm(color: colors.text)
                                            .copyWith(fontSize: 13),
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.timelapse, size: 16, color: colors.muted),
                                          fillColor: colors.surface2,
                                          filled: true,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. Category Selection Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Choose Category',
                        style: AppTypography.headlineSm(
                          color: colors.text,
                        ).copyWith(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '20 Core Presets',
                        style: AppTypography.bodySm(color: colors.muted).copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CategoryGridWidget(
                    categories: categories,
                    selectedIndex: _selectedCategoryIndex.clamp(0, categories.length - 1),
                    onSelect: (index) {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // 4. Custom Category Section
                  Container(
                    decoration: BoxDecoration(
                      color: colors.isDark ? colors.surface : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colors.border.withOpacity(colors.isDark ? 0.6 : 0.8),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Add Custom Category',
                              style: AppTypography.headlineSm(color: colors.text)
                                  .copyWith(fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Personalized',
                              style: AppTypography.bodySm(color: colors.muted).copyWith(fontSize: 11),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Inline Add Form
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _customCatController,
                                style: AppTypography.bodySm(color: colors.text),
                                decoration: InputDecoration(
                                  hintText: 'Category name (e.g. Deep Focus)',
                                  hintStyle: AppTypography.bodySm(color: colors.muted),
                                  fillColor: colors.surface2,
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.habitsAccent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                elevation: 0,
                              ),
                              onPressed: _addCustomCategory,
                              icon: const Icon(Icons.add, size: 16, color: Colors.white),
                              label: const Text('Add', style: TextStyle(color: Colors.white, fontSize: 13)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Color Dot Palette Picker
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Badge Color:',
                              style: AppTypography.bodySm(color: colors.muted).copyWith(fontSize: 12),
                            ),
                            Row(
                              children: _paletteColors.map((hex) {
                                final isSelected = _selectedCustomColor == hex;
                                final dotColor = HabitCategory(name: '', color: hex).colorValue;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedCustomColor = hex;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 6),
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: dotColor,
                                      border: isSelected
                                          ? Border.all(color: colors.text, width: 2)
                                          : null,
                                    ),
                                    child: isSelected
                                        ? const Center(
                                            child: Icon(Icons.check, size: 12, color: Colors.white),
                                          )
                                        : null,
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),

                        // List of user custom categories (if any)
                        if (categories.any((c) => c.custom)) ...[
                          const SizedBox(height: 16),
                          const Divider(height: 1),
                          const SizedBox(height: 12),
                          ...categories.asMap().entries.where((e) => e.value.custom).map((entry) {
                            final idx = entry.key;
                            final cat = entry.value;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: colors.surface2,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: cat.colorValue,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      cat.name,
                                      style: AppTypography.bodySm(
                                        color: colors.text,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: colors.muted.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'CUSTOM',
                                      style: AppTypography.bodySm(color: colors.muted)
                                          .copyWith(fontSize: 9, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline, size: 16, color: colors.danger),
                                    splashRadius: 16,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                    tooltip: 'Delete custom category',
                                    onPressed: () async {
                                      final deleted = await provider.deleteCustomCategory(idx);
                                      if (!deleted) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Cannot delete category currently in use by habits.'),
                                            ),
                                          );
                                        }
                                      } else {
                                        _triggerToast('Category removed.');
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 5. Save Habit CTA Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.habitsAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 1,
                      ),
                      onPressed: _handleSaveHabit,
                      icon: const Icon(Icons.save, size: 20, color: Colors.white),
                      label: const Text(
                        'Save Habit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),

        // Floating Toast Notification
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          top: _showToast ? 16 : -80,
          left: 20,
          right: 20,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 390),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: colors.isDark ? const Color(0xFF242736) : const Color(0xFF141B2B),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, size: 20, color: Color(0xFF4ADE80)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _toastMessage,
                        style: AppTypography.bodySm(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showToast = false;
                        });
                      },
                      child: const Icon(Icons.close, size: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
