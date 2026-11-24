// =============================================================================
// BudgetSplit Widget - Emoji Picker
// =============================================================================
// Bottom sheet for selecting category icons from emoji grid.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';

/// Item representation for the 40 emoji icon picker
class EmojiItem {
  final String emoji;
  final String name;
  final String tag;

  const EmojiItem({
    required this.emoji,
    required this.name,
    required this.tag,
  });
}

/// Bottom sheet dialog presenting the 40 emoji icons in an 8-column grid.
/// Allows picking an icon with dynamic selection preview.
class EmojiPickerSheet extends StatefulWidget {
  final String currentEmoji;
  final ValueChanged<String> onEmojiSelected;

  const EmojiPickerSheet({
    Key? key,
    required this.currentEmoji,
    required this.onEmojiSelected,
  }) : super(key: key);

  /// 40 Exact Emoji options from the design specification (8 columns x 5 rows)
  static const List<EmojiItem> emojis = [
    EmojiItem(emoji: '🏦', name: 'Banking & Deposits', tag: '#FINANCE'),
    EmojiItem(emoji: '👤', name: 'Personal Profile', tag: '#INDIVIDUAL'),
    EmojiItem(emoji: '💼', name: 'Business & Career', tag: '#WORK'),
    EmojiItem(emoji: '🚌', name: 'Transit & Commute', tag: '#COMMUTE'),
    EmojiItem(emoji: '🍱', name: 'Meals & Dining', tag: '#FOOD'),
    EmojiItem(emoji: '🛒', name: 'Groceries & Market', tag: '#PANTRY'),
    EmojiItem(emoji: '🏠', name: 'Housing & Shelter', tag: '#HOME'),
    EmojiItem(emoji: '📱', name: 'Telecom & Mobile', tag: '#UTILITIES'),
    EmojiItem(emoji: '💡', name: 'Electric & Power', tag: '#UTILITIES'),
    EmojiItem(emoji: '💊', name: 'Health & Pharmacy', tag: '#MEDICAL'),
    EmojiItem(emoji: '📚', name: 'Books & Reading', tag: '#STUDY'),
    EmojiItem(emoji: '🎬', name: 'Cinema & Shows', tag: '#LEISURE'),
    EmojiItem(emoji: '👕', name: 'Apparel & Fashion', tag: '#STYLE'),
    EmojiItem(emoji: '⛽', name: 'Fuel & Gas', tag: '#AUTO'),
    EmojiItem(emoji: '✈️', name: 'Airfare & Travel', tag: '#TRIPS'),
    EmojiItem(emoji: '🏋️', name: 'Fitness & Gym', tag: '#WELLNESS'),
    EmojiItem(emoji: '🛡️', name: 'Insurance & Guard', tag: '#SAFETY'),
    EmojiItem(emoji: '🎁', name: 'Gifts & Celebrations', tag: '#EVENTS'),
    EmojiItem(emoji: '🧹', name: 'Cleaning & Upkeep', tag: '#MAINTENANCE'),
    EmojiItem(emoji: '🆘', name: 'Emergency Fund', tag: '#URGENT'),
    EmojiItem(emoji: '📈', name: 'Stock Market', tag: '#INVEST'),
    EmojiItem(emoji: '💻', name: 'Hardware & Tech', tag: '#GEAR'),
    EmojiItem(emoji: '☕', name: 'Coffee & Cafes', tag: '#DAILY'),
    EmojiItem(emoji: '🎮', name: 'Games & Gaming', tag: '#PLAY'),
    EmojiItem(emoji: '🎓', name: 'Tuition & Courses', tag: '#GROWTH'),
    EmojiItem(emoji: '🧾', name: 'Taxes & Invoices', tag: '#COMPLIANCE'),
    EmojiItem(emoji: '🏥', name: 'Hospital Care', tag: '#CLINIC'),
    EmojiItem(emoji: '🐾', name: 'Pets & Veterinary', tag: '#PETS'),
    EmojiItem(emoji: '🚗', name: 'Car Ownership', tag: '#VEHICLE'),
    EmojiItem(emoji: '🏡', name: 'Real Estate', tag: '#PROPERTY'),
    EmojiItem(emoji: '💰', name: 'Cash Reserves', tag: '#CASH'),
    EmojiItem(emoji: '📦', name: 'Deliveries & Postage', tag: '#SHIPPING'),
    EmojiItem(emoji: '💳', name: 'Card Payments', tag: '#CREDIT'),
    EmojiItem(emoji: '🪙', name: 'Coins & Pocket Change', tag: '#SPARE'),
    EmojiItem(emoji: '🛍️', name: 'Retail Shopping', tag: '#RETAIL'),
    EmojiItem(emoji: '🏖️', name: 'Vacation & Respite', tag: '#GETAWAY'),
    EmojiItem(emoji: '🎯', name: 'Financial Goals', tag: '#TARGETS'),
    EmojiItem(emoji: '🧰', name: 'Repairs & Tooling', tag: '#HARDWARE'),
    EmojiItem(emoji: '🌱', name: 'Sustainable & Green', tag: '#ECO'),
    EmojiItem(emoji: '✏️', name: 'Custom Notes', tag: '#EDIT'),
  ];

  /// Static helper to show the emoji picker bottom sheet
  static Future<String?> show(BuildContext context, String currentEmoji) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => EmojiPickerSheet(
        currentEmoji: currentEmoji,
        onEmojiSelected: (selected) => Navigator.of(ctx).pop(selected),
      ),
    );
  }

  @override
  State<EmojiPickerSheet> createState() => _EmojiPickerSheetState();
}

class _EmojiPickerSheetState extends State<EmojiPickerSheet> {
  late EmojiItem _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = EmojiPickerSheet.emojis.firstWhere(
      (e) => e.emoji == widget.currentEmoji,
      orElse: () => EmojiPickerSheet.emojis.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      constraints: const BoxConstraints(maxWidth: 430),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusBottomSheet),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 24,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.spaceMd),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 8),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.border.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header Row: Title & Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choose Category Icon',
                        style: AppTypography.headlineSm(color: colors.text),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Select an icon for your category',
                        style: AppTypography.bodySm(color: colors.muted),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: colors.surface2,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: colors.muted,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Dynamic Selection Preview Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: colors.surface2,
                  borderRadius: BorderRadius.circular(AppConstants.radiusCard),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              _selectedItem.emoji,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SELECTED SYMBOL',
                              style: AppTypography.codeBadge(color: colors.muted),
                            ),
                            Text(
                              _selectedItem.name,
                              style: AppTypography.titleSm(color: colors.text),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: colors.budgetBlue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(AppConstants.radiusPill),
                      ),
                      child: Text(
                        _selectedItem.tag,
                        style: AppTypography.codeBadge(color: colors.budgetBlue),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 8-Column Emoji Grid
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 280),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: EmojiPickerSheet.emojis.length,
                  itemBuilder: (context, index) {
                    final item = EmojiPickerSheet.emojis[index];
                    final isSelected = item.emoji == _selectedItem.emoji;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedItem = item;
                        });
                        widget.onEmojiSelected(item.emoji);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colors.budgetBlue.withOpacity(0.2)
                              : colors.surface2,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? colors.budgetBlue
                                : colors.border.withOpacity(0.3),
                            width: isSelected ? 2 : 0.8,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            item.emoji,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
