import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:patient_management_app/providers/authProvider/auth_provider.dart';
import 'package:patient_management_app/providers/patientProvider/patient_provider.dart';
import 'package:patient_management_app/providers/registerProvider/register_provider.dart';
import 'package:patient_management_app/views/loginScreen/login_screen.dart';
import 'package:patient_management_app/views/patientScreen/patient_screen.dart';
import 'package:patient_management_app/views/splashScreen/splash_screen.dart';

import 'package:provider/provider.dart';

import 'core/common/routes.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: kDebugMode,
      // builder: (context) => const MyApp(),

      builder: (context) {
        return
          MultiProvider(
          providers: [
             ChangeNotifierProvider(create: (_) => Authprovider()),
             ChangeNotifierProvider(create: (_) => PatientProvider()),
            ChangeNotifierProvider(create: (_) => RegisterProvider()),


          ],
          child: const MyApp(),
        );
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(412, 917),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: CustomRoutes.splash,
          routes: {
            CustomRoutes.splash: (context) => SplashScreen(),
            CustomRoutes.login: (context) => LoginScreen(),
            CustomRoutes.patientScreen: (context) => PatientScreen(),

          },
          title: 'Patient Management App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
