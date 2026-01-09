import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/common/colors.dart';
class PatientCard extends StatelessWidget {
  final int index;
  final String name;
  final String treatment;
  final String date;
  final String staff;

  const PatientCard({
    super.key,
    required this.index,
    required this.name,
    required this.treatment,
    required this.date,
    required this.staff,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$index.",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),


                Text(
                  treatment.isNotEmpty ? treatment : "Not under treatment",
                  style: const TextStyle(
                    color: Pallette.primaryColor,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 6),


                Row(
                  children: [
                    const Icon(Icons.calendar_month,
                        size: 14, color: Colors.red),
                    const SizedBox(width: 4),
                    Text(date, style: const TextStyle(fontSize: 12)),

                    const SizedBox(width: 12),

                    const Icon(Icons.group,
                        size: 14, color: Colors.orange),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        staff,
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),


          const Divider(height: 1, thickness: 0.6),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: const [
                Expanded(
                  child: Text(
                    "View Booking details",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Pallette.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}







