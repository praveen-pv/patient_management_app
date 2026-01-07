import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/treatment_model.dart';
import '../../repositories/registerRepo/register_repository.dart';

class RegisterProvider extends ChangeNotifier {
  final _registerrepository = RegisterRepository();


  List<BranchModel> branchReportList = [];
  List<TreatmentModel> treatmentReportList = [];
  bool isTreatmentLoading = false;
  bool isBranchLoading = false;
  String? selectedBranchName;
  int? selectedBranchId;
  String? selectedTreatmentName;
  int? selectedTreatmentId;


  void clearSelections() {
    selectedBranchName = null;
    selectedBranchId = null;
    selectedTreatmentName = null;
    selectedTreatmentId = null;
    notifyListeners();
  }

  Future<bool> isCreateNewRegister({
    required String authtoken,
    required Map<String, dynamic> registerdata,
  }) async {
    try {
      final res = await _registerrepository.create_new_register(
        authtoken: authtoken,
        registerdata: registerdata,
      );
      print('res: ${res?.body}');
      if (res?.statusCode == 200 || (res?.statusCode) == 201) {
        return true;
      } else {
        print('else work');
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
    return false;
  }

  Future<void> getTreatmentReports() async {
    try {
      isTreatmentLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("access_token") ?? "";

      final response = await _registerrepository.fetch_TreatmentLists(token);

      if (response != null) {
        treatmentReportList = response;
      } else {
        treatmentReportList = [];
      }
    } catch (e) {
      treatmentReportList = [];
      debugPrint(e.toString());
    } finally {
      isTreatmentLoading = false;
      notifyListeners();
    }
  }

  void selectTreatment(String name) {
    selectedTreatmentName = name;

    final t = treatmentReportList.firstWhere(
          (e) => e.name == name,
    );

    selectedTreatmentId = t.id;

    notifyListeners();
  }

  Future<void> getBranchReports() async {
    try {
      isBranchLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("access_token") ?? "";

      final response = await _registerrepository.fetch_BranchLists(token);

      if (response != null) {
        branchReportList = response;
      } else {
        branchReportList = [];
      }
    } catch (e) {
      branchReportList = [];
      debugPrint(e.toString());
    } finally {
      isBranchLoading = false;
      notifyListeners();
    }
  }

  void selectBranch(String branchName) {
    selectedBranchName = branchName;

    final branch = branchReportList.firstWhere(
          (e) => e.name == branchName,
    );

    selectedBranchId = branch.id;

    notifyListeners();

    debugPrint("Branch Name: $selectedBranchName");
    debugPrint("Branch ID: $selectedBranchId");
  }
}
