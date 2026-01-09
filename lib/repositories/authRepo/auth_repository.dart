import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/service/api_service.dart';
import '../../models/user_model.dart';

class Authrepository {
  Future<Usermodel?> userLogin({
    required String username,
    required String password,
  }) async {
    try {
      final uri = Uri.parse(ApiService.loginUrl);

      final request = http.MultipartRequest("POST", uri);
      request.fields["username"] = username;
      request.fields["password"] = password;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("Status code: ${response.statusCode}");
      debugPrint("Login response: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> usermap = jsonDecode(response.body);

        if (usermap["status"] == true) {
          final token = usermap["token"];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("access_token", token);

          return Usermodel.fromJson(usermap["user_details"]);
        }
      }

      return null;
    } catch (e) {
      debugPrint("Login error: $e");
      return null;
    }
  }

  // Future<Usermodel?> userLogin({
  //   required String username,
  //   required String password,
  // }) async {
  //   try {
  //     final url = Uri.parse(ApiService.loginUrl);
  //
  //     debugPrint("Login URL: $url");
  //
  //     final response = await http.post(
  //       url,
  //      // headers: {"Content-Type": "application/json"},
  //       body: {
  //         "username": username,
  //         "password": password,
  //       },
  //
  //     );
  //     debugPrint("Status code: ${response.statusCode}");
  //     debugPrint("login response: ${response.body}");
  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> usermap = jsonDecode(response.body);
  //
  //       if (usermap['status'] == true) {
  //         final String token = usermap['token'] ?? '';
  //
  //         final prefs = await SharedPreferences.getInstance();
  //         await prefs.setString("access_token", token);
  //
  //         return Usermodel.fromJson(usermap['user_details']);
  //       } else {
  //
  //         debugPrint("Login failed: ${usermap['message']}");
  //         return null;
  //       }
  //     }
  //
  //
  //     return null;
  //   } catch (e) {
  //     debugPrint("Login error: $e");
  //     return null;
  //   }
  // }

  Future<bool> checkUserExist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("access_token");


      debugPrint("Token: $token");


      // Only check if both token  exist
      if (token != null && token.isNotEmpty ) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("checkUserExist error: $e");
      return false;
    }
  }


  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
