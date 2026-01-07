import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../core/service/api_service.dart';
import '../../models/patient_model.dart';



abstract class PatientRepo {

  Future<List<PatientModel>?> fetch_PatientLists(String token);


}

class PatientRepository implements PatientRepo {


  @override
  Future<List<PatientModel>?>fetch_PatientLists(String token,) async {
    try {
      final url = Uri.parse(ApiService.patientUrl);

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },

      );
      if (kDebugMode) {
        print("get Patient list: ${response.body}");
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        List data = jsonDecode(response.body)["patient"] ?? [];
        return data.map((e) => PatientModel.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }}