import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/common/colors.dart';
import '../../core/common/images.dart';
import '../../widgets/selected_treatment.dart';


class ReceiptPreviewScreen extends StatelessWidget {
  final Map<String, dynamic> registerData;
  final List<SelectedTreatment> treatments;
  final String branchName;

  const ReceiptPreviewScreen({
    super.key,
    required this.registerData,
    required this.treatments,
    required this.branchName,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("PDF treatments count: ${treatments.length}");
    debugPrint("PDF treatments data: $treatments");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Patient Receipt",style: TextStyle(color: Colors.white),),
        backgroundColor: Pallette.primaryColor,
      ),
      body: Stack(

        children:[
          _backgroundWatermark(),
          SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const Divider(thickness: 1),

              SizedBox(height: 12.h),
              _patientDetails(),

              _dottedDivider(),

              SizedBox(height: 12.h),
              _treatmentTable(),

              _dottedDivider(),

              SizedBox(height: 12.h),
              _summarySection(),

              SizedBox(height: 60.h),
              _thankYouSection(),
            ],
          ),
        ),
      ]),
    );
  }
  Widget _backgroundWatermark() {
    return Center(
      child: Opacity(
        opacity: 0.05,
        child: Image.asset(
          Images.applogo,
          width: 260,
          height: 260,
          fit: BoxFit.contain,
        ),
      ),
    );
  }


  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          Images.applogo,
          width: 60,
          height: 60,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                branchName.toUpperCase(),
                style: TextStyle(
                    fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                "Cheepunkal P.O, Kumarakom, Kottayam, Kerala - 686563",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 11.sp),
              ),
              Text(
                "Mob : +91 9876543210 | e-mail : unknown@gmail.com",
                style: TextStyle(fontSize: 11.sp),
              ),
              Text(
                "GST No : 32AABCU9603RTZW",
                style: TextStyle(fontSize: 11.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _patientDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Patient Details",
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 8.h),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LEFT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow("Name", registerData["name"]),
                  _infoRow("Address", registerData["address"]),
                  _infoRow("WhatsApp Number", registerData["phone"]),
                ],
              ),
            ),

            // RIGHT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow("Booked On", _today()),
                  _infoRow("Treatment Date", _dateOnly()),
                  _infoRow("Treatment Time", _timeOnly()),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 12.sp, color: Colors.black),
          children: [
            TextSpan(
                text: "$label : ",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }




  Widget _treatmentTable() {
    if (treatments.isEmpty) {
      return const Text(
        "No treatments selected",
        style: TextStyle(color: Colors.red),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Treatment",
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 8.h),

        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
          },
          children: [
            _tableHeaderRow(),

            // ✅ IMPORTANT: toList()
            ...treatments.map((t) {
              final int total = (t.male + t.female) * 230;

              return _tableDataRow(
                t.name,
                "₹230",
                t.male.toString(),
                t.female.toString(),
                "₹$total",
              );
            }).toList(),
          ],
        ),
      ],
    );
  }

  TableRow _tableHeaderRow() {
    return TableRow(
      children: [
        _tableCell("Treatment", bold: true),
        _tableCell("Price", bold: true),
        _tableCell("Male", bold: true),
        _tableCell("Female", bold: true),
        _tableCell("Total", bold: true),
      ],
    );
  }

  TableRow _tableDataRow(
      String t, String p, String m, String f, String total) {
    return TableRow(
      children: [
        _tableCell(t),
        _tableCell(p),
        _tableCell(m),
        _tableCell(f),
        _tableCell(total),
      ],
    );
  }

  Widget _tableCell(String text, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }


  Widget _summarySection() {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _summaryRow("Total Amount", registerData["total_amount"]),
          _summaryRow("Discount", registerData["discount_amount"]),
          _summaryRow("Advance", registerData["advance_amount"]),
          SizedBox(height: 6),
          _summaryRow(
            "Balance",
            registerData["balance_amount"],
            bold: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, dynamic value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: TextStyle(
                    fontWeight:
                    bold ? FontWeight.bold : FontWeight.normal)),
          ),
          Text("₹$value",
              style: TextStyle(
                  fontWeight:
                  bold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }


  Widget _thankYouSection() {
    return Column(
      children: [
        Text(
          "Thank you for choosing us",
          style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp),
        ),
        SizedBox(height: 120),
        const Divider(),
        SizedBox(height: 10),
        Text(
          "Booking amount is non-refundable, and it is important to arrive on the allotted time for your treatment",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10.sp, color: Colors.grey),
        ),
      ],
    );
  }


  Widget _dottedDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: List.generate(
          60,
              (index) => Expanded(
            child: Container(
              height: 1,
              color: index % 2 == 0 ? Colors.grey : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }

  String _today() => "31/01/2024 | 12:12 pm";

  String _dateOnly() =>
      registerData["date_nd_time"].toString().split('-').first;

  String _timeOnly() =>
      registerData["date_nd_time"].toString().split('-').last;
}

