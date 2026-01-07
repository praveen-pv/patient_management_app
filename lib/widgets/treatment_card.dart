import 'package:flutter/material.dart';
import 'package:patient_management_app/widgets/selected_treatment.dart';

import '../core/common/colors.dart';

class TreatmentCard extends StatelessWidget {
  final int index;
  final SelectedTreatment treatment;
  final VoidCallback onRemove;

  const TreatmentCard({
    super.key,
    required this.index,
    required this.treatment,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Text("$index.", style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  treatment.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              GestureDetector(
                onTap: onRemove,
                child: const Icon(Icons.close, color: Colors.red),
              )
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              _countChip("Male", treatment.male),
              const SizedBox(width: 12),
              _countChip("Female", treatment.female),
              const Spacer(),
              const Icon(Icons.edit, color: Pallette.primaryColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _countChip(String label, int count) {
    return Row(
      children: [
        Text(label, style: const TextStyle(color: Pallette.primaryColor)),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Pallette.primaryColor),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text("$count"),
        ),
      ],
    );
  }
}
