



import 'package:flutter/material.dart';

import '../../models/patient_model.dart';
import '../../repositories/patientRepo/patient_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
class PatientProvider extends ChangeNotifier {
  final _patientrepository = PatientRepository();

  List<PatientModel> patientList = [];
  List<PatientModel> filteredList = [];

  bool isLoading = false;

  PatientProvider() {
    getPatientList();
  }

  Future<void> getPatientList() async {
    try {
      isLoading = true;
      notifyListeners();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await _patientrepository.fetch_PatientLists(
        prefs.getString("access_token") ?? "",
      );

      if (response != null) {
        patientList = response;
        filteredList = response;
      } else {
        patientList = [];
        filteredList = [];
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }


  void filterByTreatment(String keyword) {
    if (keyword.isEmpty) {
      filteredList = patientList;
    } else {
      filteredList = patientList.where((patient) {
        return patient.patientDetails.any((detail) =>
            detail.treatmentName
                .toLowerCase()
                .contains(keyword.toLowerCase()));
      }).toList();
    }
    notifyListeners();
  }


  void filterByDate(DateTime selectedDate) {
    filteredList = patientList.where((patient) {
      final d = patient.dateAndTime;
      return d.year == selectedDate.year &&
          d.month == selectedDate.month &&
          d.day == selectedDate.day;
    }).toList();

    notifyListeners();
  }


  void clearFilters() {
    filteredList = patientList;
    notifyListeners();
  }
}
