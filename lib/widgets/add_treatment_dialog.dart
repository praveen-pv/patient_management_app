import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../core/common/colors.dart';
import '../providers/registerProvider/register_provider.dart';
import 'custom_button.dart';
import 'custom_dropdown.dart';
import 'selected_treatment.dart';

class AddTreatmentDialog extends StatefulWidget {
  const AddTreatmentDialog({super.key});

  @override
  State<AddTreatmentDialog> createState() => _AddTreatmentDialogState();
}

class _AddTreatmentDialogState extends State<AddTreatmentDialog> {
  int male = 0;
  int female = 0;

  int? selectedTreatmentId;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Consumer<RegisterProvider>(
            builder: (context, provider, _) {

              if (provider.isTreatmentLoading) {
                return const SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  const Text(
                    "Choose Treatment",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  DropdownButtonFormField<int>(
                    value: selectedTreatmentId,
                    isExpanded: true, // ✅ IMPORTANT
                    hint: const Text("Choose preferred treatment"),
                    items: provider.treatmentReportList.map((t) {
                      return DropdownMenuItem<int>(
                        value: t.id,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            t.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() => selectedTreatmentId = val);
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                  ),


                  SizedBox(height: 20.h),

                  const Text(
                    "Add Patients",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  _patientRow(
                    label: "Male",
                    value: male,
                    onMinus: () => setState(() {
                      if (male > 0) male--;
                    }),
                    onPlus: () => setState(() => male++),
                  ),

                  SizedBox(height: 12.h),

                  _patientRow(
                    label: "Female",
                    value: female,
                    onMinus: () => setState(() {
                      if (female > 0) female--;
                    }),
                    onPlus: () => setState(() => female++),
                  ),

                  SizedBox(height: 24.h),


                  CustomButton(
                    text: "Save",
                    onTap: () {
                      if (selectedTreatmentId == null) return;

                      final selectedTreatment =
                      provider.treatmentReportList.firstWhere(
                            (e) => e.id == selectedTreatmentId,
                      );

                      Navigator.pop(
                        context,
                        SelectedTreatment(
                          id: selectedTreatment.id,
                          name: selectedTreatment.name,
                          male: male,
                          female: female,
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// 🔹 SAME OLD DESIGN (UNCHANGED)
  Widget _patientRow({
    required String label,
    required int value,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            height: 44,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(label),
          ),
        ),

        SizedBox(width: 12),

        _circleButton(icon: Icons.remove, onTap: onMinus),

        SizedBox(width: 10),

        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            "$value",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),

        SizedBox(width: 10),

        _circleButton(icon: Icons.add, onTap: onPlus),
      ],
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: Pallette.primaryColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

