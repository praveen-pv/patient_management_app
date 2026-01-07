import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../core/common/colors.dart';
import '../../core/common/images.dart';
import '../../widgets/selected_treatment.dart';


class RegisterPdfPage extends StatelessWidget {
  final Map<String, dynamic> registerData;
  final List<SelectedTreatment> treatments;
  final String branchName;

  const RegisterPdfPage({
    super.key,
    required this.registerData,
    required this.treatments,
    required this.branchName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Receipt"),
        backgroundColor: Pallette.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _generateAndSharePdf,
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: _generateAndSharePdf,
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text("Generate PDF"),
        ),
      ),
    );
  }

  // ======================================================
  // 🔥 PDF GENERATION
  // ======================================================

  Future<void> _generateAndSharePdf() async {
    final pdf = pw.Document();

    final logoBytes = await rootBundle.load(Images.applogo);
    final logo = pw.MemoryImage(logoBytes.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (_) {
          return pw.Stack(
            children: [
              _backgroundWatermark(),
              pw.Padding(
                padding: const pw.EdgeInsets.all(24),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _header(logo),
                    pw.SizedBox(height: 16),
                    _patientDetails(),
                    pw.SizedBox(height: 16),
                    _treatmentTable(),
                    pw.SizedBox(height: 16),
                    _summaryBox(),
                    pw.SizedBox(height: 30),
                    pw.Center(
                      child: pw.Text(
                        "Thank you for choosing us",
                        style: pw.TextStyle(
                          color: PdfColors.green,
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/patient_receipt.pdf");
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles(
      [XFile(file.path)],
      text: "Patient treatment receipt",
    );
  }

  // ======================================================
  // 🔹 COMPONENTS
  // ======================================================

  pw.Widget _header(pw.ImageProvider logo) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Image(logo, width: 60),
        pw.SizedBox(width: 12),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(branchName,
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.Text("Kerala"),
              pw.Text("GST No : 32AABCU9603RTZW"),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _patientDetails() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: _detail("Name", registerData["name"]),
          ),
          pw.Expanded(
            child: _detail("Whatsapp", registerData["phone"]),
          ),
        ],
      ),
    );
  }

  pw.Widget _detail(String label, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label,
            style:
            pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
        pw.Text(value,
            style:
            pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  pw.Widget _treatmentTable() {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey),
      columnWidths: {
        0: const pw.FlexColumnWidth(3),
        1: const pw.FlexColumnWidth(1),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(1),
      },
      children: [
        _tableHeader(),
        ...treatments.map((e) {
          final total = (e.male + e.female) * 230;
          return pw.TableRow(
            children: [
              _cell(e.name),
              _cell("${e.male}"),
              _cell("${e.female}"),
              _cell("₹$total"),
            ],
          );
        }).toList(),
      ],
    );
  }

  pw.TableRow _tableHeader() {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.grey300),
      children: [
        _cell("Treatment", bold: true),
        _cell("Male", bold: true),
        _cell("Female", bold: true),
        _cell("Total", bold: true),
      ],
    );
  }

  pw.Widget _cell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        maxLines: 2,
        overflow: pw.TextOverflow.clip,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  pw.Widget _summaryBox() {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Container(
        width: 200,
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey),
          borderRadius: pw.BorderRadius.circular(8),
        ),
        child: pw.Column(
          children: [
            _summaryRow("Total", registerData["total_amount"]),
            _summaryRow("Discount", registerData["discount_amount"]),
            _summaryRow("Advance", registerData["advance_amount"]),
            pw.Divider(),
            _summaryRow("Balance", registerData["balance_amount"],
                bold: true),
          ],
        ),
      ),
    );
  }

  pw.Widget _summaryRow(String label, dynamic value,
      {bool bold = false}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label,
            style: pw.TextStyle(
                fontSize: 10,
                fontWeight:
                bold ? pw.FontWeight.bold : pw.FontWeight.normal)),
        pw.Text("₹$value",
            style: pw.TextStyle(
                fontSize: 10,
                fontWeight:
                bold ? pw.FontWeight.bold : pw.FontWeight.normal)),
      ],
    );
  }

  pw.Widget _backgroundWatermark() {
    return pw.Center(
      child: pw.Opacity(
        opacity: 0.05,
        child: pw.Text(
          "AYURVEDA",
          style: pw.TextStyle(
            fontSize: 100,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
