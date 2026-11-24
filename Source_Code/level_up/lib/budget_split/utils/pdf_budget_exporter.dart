// =============================================================================
// BudgetSplit - PDF Export
// =============================================================================
// Generates styled PDF budget reports with header, distribution bar, and summary table.
// =============================================================================

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../models/budget_category.dart';
import 'budget_calculator.dart';

/// Professional visual PDF generator and exporter for BudgetSplit.
class PdfBudgetExporter {
  PdfBudgetExporter._();

  // Distinct category palette for the visual allocation bar
  static const List<PdfColor> _categoryColors = [
    PdfColor.fromInt(0xFF2563EB), // Blue
    PdfColor.fromInt(0xFF059669), // Emerald Green
    PdfColor.fromInt(0xFF7C3AED), // Violet
    PdfColor.fromInt(0xFFD97706), // Amber
    PdfColor.fromInt(0xFFDB2777), // Pink
    PdfColor.fromInt(0xFF0D9488), // Teal
    PdfColor.fromInt(0xFFEA580C), // Orange
    PdfColor.fromInt(0xFF4F46E5), // Indigo
  ];

  /// Generates the complete, styled PDF binary bytes.
  static Future<Uint8List> generatePdfBytes({
    required String planName,
    required double totalBudget,
    required List<BudgetCategory> categories,
  }) async {
    final pdf = pw.Document();

    // Load bundled offline TrueType fonts supporting unicode Indian Rupee (₹)
    final regularFontData =
        await rootBundle.load('assets/fonts/roboto-regular.ttf');
    final boldFontData = await rootBundle.load('assets/fonts/roboto-bold.ttf');
    final ttfRegular = pw.Font.ttf(regularFontData.buffer.asByteData());
    final ttfBold = pw.Font.ttf(boldFontData.buffer.asByteData());

    final now = DateTime.now();
    final dateStr = DateFormat('dd MMM yyyy').format(now);
    final timeStr = DateFormat('hh:mm a').format(now);
    final monthStr = DateFormat('MMMM yyyy').format(now);

    final effectivePlanName =
        planName.trim().isEmpty ? 'Budget Plan' : planName.trim();

    // Calculations
    final totalAllocatedPct =
        BudgetCalculator.calculateTotalAllocatedPercentage(categories);
    final totalAllocatedAmount =
        BudgetCalculator.calculateTotalAllocatedAmount(totalBudget, categories);
    final remainingAmount =
        BudgetCalculator.calculateRemainingAmount(totalBudget, totalAllocatedAmount);
    final isOverBudget = BudgetCalculator.isOverBudget(totalAllocatedPct);

    // Active categories with allocation > 0
    final activeCategories =
        categories.where((c) => c.percentageValue > 0).toList();

    // Color definitions
    const primaryColor = PdfColor.fromInt(0xFF2563EB);
    const successColor = PdfColor.fromInt(0xFF059669);
    const warningColor = PdfColor.fromInt(0xFFDC2626);
    const surfaceColor = PdfColor.fromInt(0xFFF8FAFC);
    const borderColor = PdfColor.fromInt(0xFFE2E8F0);
    const textDark = PdfColor.fromInt(0xFF0F172A);
    const textMuted = PdfColor.fromInt(0xFF64748B);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        theme: pw.ThemeData.withFont(
          base: ttfRegular,
          bold: ttfBold,
        ),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // -------------------------------------------------------------
              // 1. TOP HEADER: BRANDING (LEFT) & TIMESTAMP INFO (TOP-RIGHT)
              // -------------------------------------------------------------
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Left: Branding and Plan Title
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: pw.BoxDecoration(
                          color: primaryColor,
                          borderRadius: pw.BorderRadius.circular(4),
                        ),
                        child: pw.Text(
                          'LEVEL UP • BUDGETSPLIT',
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 9,
                            fontWeight: pw.FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        'Budget Breakdown Report',
                        style: pw.TextStyle(
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Text(
                        'Plan: $effectivePlanName',
                        style: pw.TextStyle(
                          fontSize: 13,
                          fontWeight: pw.FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),

                  // Top-Right Corner: Structured Timestamp Details Box
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: pw.BoxDecoration(
                      color: surfaceColor,
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(color: borderColor, width: 1),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'EXPORT TIMESTAMP',
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                            color: textMuted,
                            letterSpacing: 0.5,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Date: $dateStr',
                          style: pw.TextStyle(
                            fontSize: 9.5,
                            fontWeight: pw.FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'Time: $timeStr',
                          style: pw.TextStyle(
                            fontSize: 9,
                            color: textMuted,
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'Month: $monthStr',
                          style: pw.TextStyle(
                            fontSize: 9,
                            color: textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 16),
              pw.Divider(color: borderColor, thickness: 1),
              pw.SizedBox(height: 14),

              // -------------------------------------------------------------
              // 2. HERO SUMMARY CARDS: TOTAL BUDGET, ALLOCATED, REMAINING
              // -------------------------------------------------------------
              pw.Row(
                children: [
                  // Total Budget
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(12),
                      decoration: pw.BoxDecoration(
                        color: surfaceColor,
                        borderRadius: pw.BorderRadius.circular(8),
                        border: pw.Border.all(color: borderColor, width: 1),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'TOTAL BUDGET',
                            style: pw.TextStyle(
                              fontSize: 8.5,
                              fontWeight: pw.FontWeight.bold,
                              color: textMuted,
                              letterSpacing: 0.5,
                            ),
                          ),
                          pw.SizedBox(height: 6),
                          pw.Text(
                            '₹ ${BudgetCalculator.formatAmountOnly(totalBudget)}',
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          pw.SizedBox(height: 3),
                          pw.Text(
                            'Base planned amount',
                            style: pw.TextStyle(fontSize: 8, color: textMuted),
                          ),
                        ],
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 10),

                  // Total Allocated
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(12),
                      decoration: pw.BoxDecoration(
                        color: surfaceColor,
                        borderRadius: pw.BorderRadius.circular(8),
                        border: pw.Border.all(color: borderColor, width: 1),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'ALLOCATED (${BudgetCalculator.formatPercentage(totalAllocatedPct)})',
                            style: pw.TextStyle(
                              fontSize: 8.5,
                              fontWeight: pw.FontWeight.bold,
                              color: isOverBudget ? warningColor : successColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                          pw.SizedBox(height: 6),
                          pw.Text(
                            '₹ ${BudgetCalculator.formatAmountOnly(totalAllocatedAmount)}',
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                              color: isOverBudget ? warningColor : successColor,
                            ),
                          ),
                          pw.SizedBox(height: 3),
                          pw.Text(
                            isOverBudget ? 'Exceeds 100% budget' : 'Distributed funds',
                            style: pw.TextStyle(
                              fontSize: 8,
                              color: isOverBudget ? warningColor : textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 10),

                  // Remaining Balance
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(12),
                      decoration: pw.BoxDecoration(
                        color: surfaceColor,
                        borderRadius: pw.BorderRadius.circular(8),
                        border: pw.Border.all(color: borderColor, width: 1),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'REMAINING',
                            style: pw.TextStyle(
                              fontSize: 8.5,
                              fontWeight: pw.FontWeight.bold,
                              color: textMuted,
                              letterSpacing: 0.5,
                            ),
                          ),
                          pw.SizedBox(height: 6),
                          pw.Text(
                            '₹ ${BudgetCalculator.formatAmountOnly(remainingAmount > 0 ? remainingAmount : 0.0)}',
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                              color: remainingAmount < 0 ? warningColor : textDark,
                            ),
                          ),
                          pw.SizedBox(height: 3),
                          pw.Text(
                            totalAllocatedPct >= 99.99 && totalAllocatedPct <= 100.01
                                ? 'Balanced 100%'
                                : (remainingAmount < 0 ? 'Overallocated' : 'Unallocated balance'),
                            style: pw.TextStyle(fontSize: 8, color: textMuted),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 18),

              // -------------------------------------------------------------
              // 3. VISUAL ALLOCATION PROPORTION BAR & LEGEND
              // -------------------------------------------------------------
              if (activeCategories.isNotEmpty) ...[
                pw.Text(
                  'Visual Budget Distribution',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: textDark,
                  ),
                ),
                pw.SizedBox(height: 8),

                // Multi-colored segmented allocation bar
                pw.Container(
                  height: 14,
                  width: double.infinity,
                  decoration: pw.BoxDecoration(
                    color: const PdfColor.fromInt(0xFFE2E8F0),
                    borderRadius: pw.BorderRadius.circular(7),
                  ),
                  child: pw.ClipRRect(
                    horizontalRadius: 7,
                    verticalRadius: 7,
                    child: pw.Row(
                      children: [
                        for (int i = 0; i < activeCategories.length; i++)
                          pw.Expanded(
                            flex: (activeCategories[i].percentageValue * 10).toInt(),
                            child: pw.Container(
                              color: _categoryColors[i % _categoryColors.length],
                            ),
                          ),
                        if (totalAllocatedPct < 100)
                          pw.Expanded(
                            flex: ((100 - totalAllocatedPct) * 10).toInt(),
                            child: pw.Container(
                              color: const PdfColor.fromInt(0xFFE2E8F0),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(height: 8),

                // Category Legend Row
                pw.Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    for (int i = 0; i < activeCategories.length; i++)
                      pw.Row(
                        mainAxisSize: pw.MainAxisSize.min,
                        children: [
                          pw.Container(
                            width: 8,
                            height: 8,
                            decoration: pw.BoxDecoration(
                              shape: pw.BoxShape.circle,
                              color: _categoryColors[i % _categoryColors.length],
                            ),
                          ),
                          pw.SizedBox(width: 4),
                          pw.Text(
                            '${activeCategories[i].displayName} (${BudgetCalculator.formatPercentage(activeCategories[i].percentageValue)})',
                            style: pw.TextStyle(fontSize: 8.5, color: textDark),
                          ),
                        ],
                      ),
                  ],
                ),
                pw.SizedBox(height: 18),
              ],

              // -------------------------------------------------------------
              // 4. DETAILED CATEGORY ALLOCATIONS TABLE
              // -------------------------------------------------------------
              pw.Text(
                'Category Breakdown Summary',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: textDark,
                ),
              ),
              pw.SizedBox(height: 8),

              pw.Table(
                border: pw.TableBorder.all(color: borderColor, width: 0.8),
                columnWidths: {
                  0: const pw.FlexColumnWidth(3.5),
                  1: const pw.FlexColumnWidth(1.5),
                  2: const pw.FlexColumnWidth(2.5),
                },
                children: [
                  // Table Header
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColor.fromInt(0xFFF1F5F9),
                    ),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: pw.Text(
                          'Category',
                          style: pw.TextStyle(
                            fontSize: 9.5,
                            fontWeight: pw.FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: pw.Text(
                          'Percentage',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            fontSize: 9.5,
                            fontWeight: pw.FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: pw.Text(
                          'Allocated Amount',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            fontSize: 9.5,
                            fontWeight: pw.FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Data Rows for each category
                  for (final cat in categories)
                    if (cat.percentageValue > 0 || categories.length <= 4)
                      pw.TableRow(
                        decoration: pw.BoxDecoration(
                          color: cat.percentageValue <= 0
                              ? const PdfColor.fromInt(0xFFFAFAFA)
                              : PdfColors.white,
                        ),
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: pw.Text(
                              cat.displayName,
                              style: pw.TextStyle(
                                fontSize: 9.5,
                                color: cat.percentageValue > 0 ? textDark : textMuted,
                                fontWeight: cat.percentageValue > 0
                                    ? pw.FontWeight.bold
                                    : pw.FontWeight.normal,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: pw.Text(
                              cat.percentageValue > 0
                                  ? BudgetCalculator.formatPercentage(
                                      cat.percentageValue)
                                  : '0%',
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(
                                fontSize: 9.5,
                                color: cat.percentageValue > 0 ? textDark : textMuted,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: pw.Text(
                              '₹ ${BudgetCalculator.formatAmountOnly(BudgetCalculator.calculateCategoryAmount(totalBudget, cat.percentageValue))}',
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(
                                fontSize: 9.5,
                                fontWeight: pw.FontWeight.bold,
                                color: cat.percentageValue > 0 ? primaryColor : textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),

                  // Total Row
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColor.fromInt(0xFFF1F5F9),
                    ),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(
                            horizontal: 12, vertical: 9),
                        child: pw.Text(
                          'Total Allocated',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: textDark,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(
                            horizontal: 12, vertical: 9),
                        child: pw.Text(
                          BudgetCalculator.formatPercentage(totalAllocatedPct),
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: isOverBudget ? warningColor : successColor,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(
                            horizontal: 12, vertical: 9),
                        child: pw.Text(
                          '₹ ${BudgetCalculator.formatAmountOnly(totalAllocatedAmount)}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: isOverBudget ? warningColor : successColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              pw.Spacer(),

              // -------------------------------------------------------------
              // 5. FOOTER & AUDIT TRAIL
              // -------------------------------------------------------------
              pw.Divider(color: borderColor, thickness: 0.8),
              pw.SizedBox(height: 6),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Generated by Level Up • BudgetSplit (Offline Financial Toolkit)',
                    style: pw.TextStyle(fontSize: 8, color: textMuted),
                  ),
                  pw.Text(
                    'Device-Local Export • Confidential',
                    style: pw.TextStyle(fontSize: 8, color: textMuted),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Generates the PDF file with the user's Plan Name and triggers the mobile share sheet.
  static Future<void> exportAndSharePdf({
    required String planName,
    required double totalBudget,
    required List<BudgetCategory> categories,
  }) async {
    // Generate PDF bytes
    final pdfBytes = await generatePdfBytes(
      planName: planName,
      totalBudget: totalBudget,
      categories: categories,
    );

    // Sanitize plan name for safe file naming on mobile storage
    final trimmedPlanName = planName.trim();
    final sanitizedBaseName = trimmedPlanName.isEmpty
        ? 'Budget Plan'
        : trimmedPlanName.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    final fileName = '$sanitizedBaseName.pdf';

    // Write to app's temporary cache directory
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(pdfBytes, flush: true);

    // Share via mobile system share sheet
    await Share.shareXFiles(
      [
        XFile(
          filePath,
          mimeType: 'application/pdf',
          name: fileName,
        ),
      ],
      subject: 'BudgetSplit — $sanitizedBaseName',
      text: 'Budget Breakdown Summary for $sanitizedBaseName',
    );
  }
}
