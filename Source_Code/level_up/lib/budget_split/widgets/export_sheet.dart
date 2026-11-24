// =============================================================================
// BudgetSplit Widget - Export Sheet
// =============================================================================
// Export bottom sheet with PDF, text share, and clipboard copy options.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../models/budget_category.dart';
import '../utils/export_formatter.dart';
import '../utils/pdf_budget_exporter.dart';

/// Bottom sheet dialog presenting the tabular plaintext export preview,
/// with one-tap clipboard copy and system share support.
class ExportSheet extends StatefulWidget {
  final String planName;
  final double totalBudget;
  final List<BudgetCategory> categories;

  const ExportSheet({
    Key? key,
    required this.planName,
    required this.totalBudget,
    required this.categories,
  }) : super(key: key);

  /// Helper to display the export bottom sheet
  static Future<void> show(
    BuildContext context, {
    required String planName,
    required double totalBudget,
    required List<BudgetCategory> categories,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ExportSheet(
        planName: planName,
        totalBudget: totalBudget,
        categories: categories,
      ),
    );
  }

  @override
  State<ExportSheet> createState() => _ExportSheetState();
}

class _ExportSheetState extends State<ExportSheet> {
  late String _exportText;
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _exportText = ExportFormatter.formatPlan(
      planName: widget.planName,
      totalBudget: widget.totalBudget,
      categories: widget.categories,
    );
  }

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: _exportText));
    setState(() {
      _copied = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.greenAccent, size: 18),
              SizedBox(width: 8),
              Text('Copied to clipboard'),
            ],
          ),
          duration: const Duration(milliseconds: 2300),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

      // Auto dismiss sheet after short delay as per spec 8.4
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          Navigator.of(context).maybePop();
        }
      });
    }
  }

  Future<void> _shareText() async {
    await Share.share(_exportText, subject: 'BudgetSplit — ${widget.planName}');
  }

  bool _isGeneratingPdf = false;

  Future<void> _exportPdf() async {
    if (_isGeneratingPdf) return;

    setState(() {
      _isGeneratingPdf = true;
    });

    try {
      await PdfBudgetExporter.exportAndSharePdf(
        planName: widget.planName,
        totalBudget: widget.totalBudget,
        categories: widget.categories,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text('Failed to export PDF: $e')),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGeneratingPdf = false;
        });
      }
    }
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

              // Sheet Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Export Budget Plan',
                        style: AppTypography.headlineSm(color: colors.text),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Your budget breakdown is ready to share.',
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

              // Terminal Plaintext Box
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colors.isDark ? const Color(0xFF0A0E14) : colors.surface2,
                  borderRadius: BorderRadius.circular(AppConstants.radiusCard),
                  border: Border.all(
                    color: colors.border.withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Micro header ribbon
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: colors.surface.withOpacity(0.5),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colors.budgetGreen,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'ASCII SUMMARY FORMAT',
                                style: AppTypography.codeBadge(color: colors.muted),
                              ),
                            ],
                          ),
                          Text(
                            'Plaintext',
                            style: AppTypography.codeBadge(color: colors.muted),
                          ),
                        ],
                      ),
                    ),

                    // Scrollable text preview
                    Container(
                      height: 180,
                      padding: const EdgeInsets.all(12),
                      child: SingleChildScrollView(
                        child: SelectableText(
                          _exportText,
                          style: AppTypography.codeBadge(color: colors.text).copyWith(
                            fontFamily: 'monospace',
                            height: 1.35,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 1. Featured Action: Export as PDF
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _isGeneratingPdf ? null : _exportPdf,
                  icon: _isGeneratingPdf
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.picture_as_pdf, size: 20),
                  label: Text(
                    _isGeneratingPdf ? 'Generating PDF...' : 'Export as PDF',
                    style: AppTypography.titleSm(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.budgetBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusCard),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // 2. Secondary Actions: Copy to Clipboard & Share as Text
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton.icon(
                        onPressed: _copyToClipboard,
                        icon: Icon(
                          _copied ? Icons.check : Icons.content_copy,
                          size: 16,
                        ),
                        label: Text(
                          _copied ? 'Copied' : 'Copy to Clipboard',
                          style: AppTypography.bodySm(
                            color: colors.isDark ? AppColors.darkBg : Colors.white,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.budgetGreen,
                          foregroundColor:
                              colors.isDark ? AppColors.darkBg : Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppConstants.radiusCard),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton.icon(
                        onPressed: _shareText,
                        icon: Icon(
                          Icons.share,
                          color: colors.budgetBlue,
                          size: 16,
                        ),
                        label: Text(
                          'Share as Text',
                          style: AppTypography.bodySm(
                            color: colors.text,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: colors.surface2,
                          side: BorderSide(
                            color: colors.border.withOpacity(0.5),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppConstants.radiusCard),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
