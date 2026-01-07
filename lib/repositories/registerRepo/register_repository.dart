import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';


import '../../core/service/api_service.dart';

import '../../models/treatment_model.dart';



abstract class RegisterRepo {
  Future<void> create_new_register({
    required String authtoken,
    required Map<String, dynamic> registerdata,
  });
  Future<List<BranchModel>?> fetch_BranchLists(String token);
  Future<List<TreatmentModel>?> fetch_TreatmentLists(String token);


}

class RegisterRepository implements RegisterRepo {
  @override
  Future<Response?> create_new_register({
    required String authtoken,
    required Map<String, dynamic> registerdata,
  }) async {
    try {
      final uri = Uri.parse(ApiService.registerUrl);

      final request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer $authtoken';


      registerdata.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      }
    } catch (e) {
      debugPrint("REGISTER ERROR: $e");
    }
    return null;
  }

  // @override
  // Future<Response?> create_new_register({
  //   required String authtoken,
  //   required Map<String, dynamic> registerdata,
  // }) async {
  //   try {
  //     final uri = Uri.parse(ApiService.registerUrl);
  //     final body = jsonEncode(registerdata);
  //     final response = await http.post(
  //       uri,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $authtoken",
  //       },
  //       body: body,
  //     );
  //     // print('response  : ${response.body}');
  //     print(response.body);
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       print('new register created successfully');
  //       return response;
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return null;
  //   }
  //   return null;
  // }


  @override
  Future<List<BranchModel>?>fetch_BranchLists(String token,) async {
    try {
      final url = Uri.parse(ApiService.branchUrl);

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },

      );
      if (kDebugMode) {
        print("get branches list: ${response.body}");
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        List data = jsonDecode(response.body)["branches"] ?? [];
        return data.map((e) => BranchModel.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
  @override
  Future<List<TreatmentModel>?>fetch_TreatmentLists(String token,) async {
    try {
      final url = Uri.parse(ApiService.treatmentUrl);

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },

      );
      if (kDebugMode) {
        print("get treatments list: ${response.body}");
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        List data = jsonDecode(response.body)["treatments"] ?? [];
        return data.map((e) => TreatmentModel.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }


}