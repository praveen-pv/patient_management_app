import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_model.dart';
import '../../repositories/authRepo/auth_repository.dart';
class Authprovider extends ChangeNotifier {
  final _authrepository = Authrepository();
  bool isLoading = false;
  Usermodel? user;


  Authprovider() {
    getUserData();
  }

  Future<Usermodel?> userLogin({
    required String username,
    required String password,
  }) async {
    try {
      isLoading = true;
      notifyListeners();
      final userdata = await _authrepository.userLogin(
        username: username,
        password: password,
      );
      isLoading = false;
      notifyListeners();

      if (userdata != null) {
        user = userdata;
        //  Store user  data in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("user_data", jsonEncode(userdata));
        notifyListeners();
        return userdata;
      }
      isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint(e.toString());
      return null;
    }
  }


  // Retrieve stored user
  Future<Usermodel?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString("user_data");

      if (userString != null && userString.isNotEmpty) {
        final Map<String, dynamic> userMap = jsonDecode(userString);
        user = Usermodel.fromJson(userMap);
      }

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Clear user data  logout
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("user_data");
    user = null;
    notifyListeners();
  }
}