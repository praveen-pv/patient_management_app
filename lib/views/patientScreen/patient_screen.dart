import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient_management_app/views/registerScreen/register_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/common/utils.dart';
import '../../providers/patientProvider/patient_provider.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/patient_card.dart';
import '../../core/common/colors.dart';
import '../loginScreen/login_screen.dart';


class PatientScreen extends StatefulWidget {
  const PatientScreen({super.key});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  DateTime? selectedDate;
  final TextEditingController searchCtrl = TextEditingController();

  String get dateText {
    if (selectedDate == null) {
      return "Date";
    }
    final day = selectedDate!.day.toString().padLeft(2, '0');
    final month = selectedDate!.month.toString().padLeft(2, '0');
    final year = selectedDate!.year;

    return "Date : $day/$month/$year";
  }
  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PatientProvider>().getPatientList();
    });
  }
  // @override
  // void initState() {
  //   super.initState();
  //   Future.microtask(() {
  //     context.read<PatientProvider>().getPatientList();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: const CustomAppBar(title: "Patients"),
      appBar: CustomAppBar(
        title: "Home Screen",
        isHome: true,
        onNotification: () {
          // notification action
        },
        onLogout: () async {
          bool confirmation = await myalert(
            context,
            "Do you want to logout?",
          );

          if (!confirmation) return;

          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
          );
        },

      ),


      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
        
              const SizedBox(height: 10),
        
        
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, size: 18, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: searchCtrl,
                              decoration: const InputDecoration(
                                hintText: "Search for treatments",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
        
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Pallette.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        context
                            .read<PatientProvider>()
                            .filterByTreatment(searchCtrl.text.trim());
                      },
        
                      child: const Text("Search",style: TextStyle( color: Colors.white),),
                    ),
                  ),
                ],
              ),
        
              const SizedBox(height: 12),
        
        
              Row(
                children: [
                  const Text("Sort by :", style: TextStyle(fontSize: 13)),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
        
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                        context.read<PatientProvider>().filterByDate(picked);
                      }
        
                    },
        
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Text(dateText, style: const TextStyle(fontSize: 13)),
                          const SizedBox(width: 6),
                          const Icon(Icons.keyboard_arrow_down, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
        
              const SizedBox(height: 12),
        
        
              Consumer<PatientProvider>(
                builder: (context, provider, _) {
        
                  if (provider.isLoading && provider.patientList.isEmpty) {
                    return const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
        
                  if (provider.filteredList.isEmpty) {
                    return const Expanded(
                      child: Center(child: Text("No patients found")),
                    );
                  }
        
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await context.read<PatientProvider>().getPatientList();
                      },
                      child: ListView.builder(
                        itemCount: provider.filteredList.length,
                        itemBuilder: (context, index) {
                          final patient = provider.filteredList[index];
                      
                          final treatmentNamesList = patient.patientDetails
                              .map((e) => e.treatmentName.trim())
                              .where((name) => name.isNotEmpty)
                              .toList();
                      
                          final treatmentNames = treatmentNamesList.isNotEmpty
                              ? treatmentNamesList.join(", ")
                              : "Not under treatment";
                      
                          return PatientCard(
                            index: index + 1,
                            name: patient.name,
                            treatment: treatmentNames,
                            date:
                            "${patient.dateAndTime.day.toString().padLeft(2, '0')}/"
                                "${patient.dateAndTime.month.toString().padLeft(2, '0')}/"
                                "${patient.dateAndTime.year}",
                            staff: patient.user,
                          );
                        },
                      ),
                    ),
                  );
                },
              )
        
        
        
            ],
          ),
        ),
      ),


      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: CustomButton(
          text: "Register Now",
          onTap: () {

            Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
          },
        ),
      ),
    );
  }
}



