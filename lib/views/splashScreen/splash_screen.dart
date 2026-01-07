import 'package:flutter/material.dart';

import '../../core/common/images.dart';
import '../../core/common/routes.dart';
import '../../repositories/authRepo/auth_repository.dart';
import '../loginScreen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _authRepository = Authrepository();

  Future<void> checkUserExist() async {

    Future.delayed(Duration(seconds: 2));
    try {
      final isUserExist = await _authRepository.checkUserExist();
      print("isUserExist: $isUserExist");

      if (!mounted) return;

      if (isUserExist != null && isUserExist) {

        Navigator.pushNamedAndRemoveUntil(
          context,
          CustomRoutes.patientScreen,
              (route) => false,
        );
      } else {

        Navigator.pushNamedAndRemoveUntil(
          context,
          CustomRoutes.login,
              (route) => false,
        );
      }
    }  catch (e) {
      debugPrint("Splash check error: $e");
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        CustomRoutes.login,
            (route) => false,
      );
    }
  }

  @override
  void initState() {

    super.initState();
    checkUserExist();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: Image.asset(
          Images.splashlogo,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}