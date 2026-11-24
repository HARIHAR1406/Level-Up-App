// =============================================================================
// BudgetSplit Module - Main Screen
// =============================================================================
// A complete financial planning tool that enables users to:
//   - Enter a total budget with auto-calculation
//   - Name and organize budget plans
//   - Add categories with percentage-based allocation
//   - View real-time breakdown summary with dynamic calculations
//   - Save, load, and manage multiple plans via Hive local storage
//   - Export budget breakdowns as PDF, plaintext, or clipboard copy
// =============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import 'models/budget_category.dart';
import 'providers/budget_provider.dart';
import 'widgets/action_buttons.dart';
import 'widgets/breakdown_summary.dart';
import 'widgets/budget_header.dart';
import 'widgets/category_list.dart';
import 'widgets/emoji_picker_sheet.dart';
import 'widgets/export_sheet.dart';
import 'widgets/plan_name_input.dart';
import 'widgets/progress_tracker.dart';
import 'widgets/saved_plans_panel.dart';
import 'widgets/total_budget_input.dart';

/// Complete integrated screen for Module 1: BudgetSplit.
/// Pixel-perfect conversion of the web application design references,
/// centered within a max-width 430px mobile viewport container.
class BudgetSplitScreen extends StatelessWidget {
  const BudgetSplitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide BudgetProvider locally if not registered at app root
    try {
      context.read<BudgetProvider>();
      return const _BudgetSplitContent();
    } catch (_) {
      return ChangeNotifierProvider<BudgetProvider>(
        create: (_) => BudgetProvider(),
        child: const _BudgetSplitContent(),
      );
    }
  }
}

class _BudgetSplitContent extends StatelessWidget {
  const _BudgetSplitContent({Key? key}) : super(key: key);

  void _showToast(BuildContext context, String message, {bool isError = false}) {
    final colors = AppColors.of(context);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle,
              color: isError ? colors.danger : colors.budgetGreen,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodyMd(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: colors.surface2,
        duration: const Duration(milliseconds: 2300),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusCard),
          side: BorderSide(
            color: (isError ? colors.danger : colors.budgetGreen).withOpacity(0.4),
          ),
        ),
      ),
    );
  }

  void _onPickIcon(BuildContext context, BudgetProvider provider, BudgetCategory category) async {
    final selected = await EmojiPickerSheet.show(context, category.icon);
    if (selected != null) {
      provider.updateCategory(category.id, icon: selected);
    }
  }

  void _handleSave(BuildContext context, BudgetProvider provider) async {
    final result = await provider.savePlan();
    if (context.mounted) {
      _showToast(context, result.message, isError: !result.success);
    }
  }

  void _handleExport(BuildContext context, BudgetProvider provider) {
    if (provider.totalBudget <= 0 || !provider.hasAllocatedCategories) {
      _showToast(context, 'Enter budget and at least one % first', isError: true);
      return;
    }

    ExportSheet.show(
      context,
      planName: provider.planName,
      totalBudget: provider.totalBudget,
      categories: provider.categories,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final provider = context.watch<BudgetProvider>();

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              children: [
                // Fixed Header with back navigation, branding, and OFFLINE pill
                BudgetHeader(
                  onBack: () => Navigator.of(context).maybePop(),
                ),

                // Main Scrollable Body
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spaceMd,
                      vertical: AppConstants.spaceMd,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Fresh Slate Onboarding Banner (if empty initial state)
                        if (provider.isEmptyInitialState) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius: BorderRadius.circular(AppConstants.radiusCard),
                              border: Border.all(
                                color: colors.border.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: colors.surface2,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.lightbulb_outline,
                                      size: 18,
                                      color: colors.budgetBlue,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Fresh Slate Ready',
                                        style: AppTypography.headlineSm(color: colors.text),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Enter your monthly budget and allocate percentages across categories to begin.',
                                        style: AppTypography.bodySm(color: colors.muted),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Total Budget Hero Card (inputs + progress bar)
                        Container(
                          padding: const EdgeInsets.all(AppConstants.spaceMd),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(AppConstants.radiusCard),
                            border: Border.all(
                              color: colors.border.withOpacity(0.4),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Rupee input
                              TotalBudgetInput(
                                initialValue: provider.totalBudgetInput,
                                onChanged: provider.setTotalBudget,
                              ),
                              const SizedBox(height: 14),

                              // Plan Name input
                              PlanNameInput(
                                initialValue: provider.planName,
                                onChanged: provider.setPlanName,
                              ),
                              const SizedBox(height: 16),

                              // Live Progress Tracker & Over-Budget Detection
                              ProgressTracker(
                                totalBudget: provider.totalBudget,
                                totalAllocatedPct: provider.totalAllocatedPct,
                                totalAllocatedAmount: provider.totalAllocatedAmount,
                                remainingAmount: provider.remainingAmount,
                                isOverBudget: provider.isOverBudget,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Categories Section
                        CategoryList(
                          categories: provider.categories,
                          totalBudget: provider.totalBudget,
                          onPickIcon: (cat) => _onPickIcon(context, provider, cat),
                          onNameChanged: (id, newName) {
                            // Find matching preset icon if standard preset chosen
                            final preset = BudgetCategory.presetCategories.firstWhere(
                              (p) => p['name'] == newName,
                              orElse: () => {'name': newName, 'icon': '🏷️'},
                            );
                            provider.updateCategory(
                              id,
                              name: newName,
                              icon: preset['icon'],
                            );
                          },
                          onCustomNameChanged: (id, customName) {
                            provider.updateCategory(id, customName: customName);
                          },
                          onPctChanged: (id, newPct) {
                            provider.updateCategory(id, pct: newPct);
                          },
                          onDeleteCategory: (id) {
                            provider.removeCategory(id);
                          },
                          onAddCategory: () {
                            provider.addCategory();
                          },
                        ),
                        const SizedBox(height: 20),

                        // Dynamic Breakdown Summary Table
                        BreakdownSummary(
                          categories: provider.categories,
                          totalBudget: provider.totalBudget,
                          totalAllocatedPct: provider.totalAllocatedPct,
                          totalAllocatedAmount: provider.totalAllocatedAmount,
                          isOverBudget: provider.isOverBudget,
                        ),
                        if (provider.hasAllocatedCategories)
                          const SizedBox(height: 20),

                        // Action Buttons: Save, Export, Discard
                        ActionButtons(
                          onSave: () => _handleSave(context, provider),
                          onExport: () => _handleExport(context, provider),
                          onDiscard: () {
                            provider.discardPlan();
                            _showToast(context, 'Reset to fresh state');
                          },
                        ),
                        const SizedBox(height: 24),

                        // Saved Plans Panel (Hive Local Storage)
                        SavedPlansPanel(
                          plans: provider.savedPlans,
                          activePlanId: provider.loadedPlanId,
                          isExpanded: provider.isSavedPlansExpanded,
                          onToggleExpanded: provider.toggleSavedPlansExpanded,
                          onLoadPlan: (plan) {
                            provider.loadPlan(plan);
                            _showToast(context, 'Loaded "${plan.name}"');
                          },
                          onDeletePlan: (id) async {
                            await provider.deleteSavedPlan(id);
                            if (context.mounted) {
                              _showToast(context, 'Plan deleted');
                            }
                          },
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
