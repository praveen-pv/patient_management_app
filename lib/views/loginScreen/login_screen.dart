
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/common/colors.dart';
import '../../core/common/images.dart';
import '../../core/common/routes.dart';
import '../../core/common/utils.dart';
import '../../providers/authProvider/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [


          SizedBox(
            height: 0.38.sh,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  Images.loginBg,
                  fit: BoxFit.cover,
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.black.withOpacity(0.25),
                  ),
                ),
              ],
            ),
          ),


          Positioned(
            top: 0.15.sh,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                Images.applogo,
                height: 90.h,
                width: 90.w,
              ),
            ),
          ),


          SingleChildScrollView(
            child: Column(
              children: [


                SizedBox(height: 0.36.sh),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 24.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22.r),
                      topRight: Radius.circular(22.r),
                    ),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [


                        Text(
                          textAlign: TextAlign.center,
                          "           Login Or Register To Book\n        Your Appointments",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        SizedBox(height: 24.h),


                        Text(
                          "Username",
                          style: TextStyle(
                            color: Pallette.textGrey,
                            fontSize: 13.sp,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        CustomTextField(
                      validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }

                                  return null;
                                },
                          hint: "Enter your username",
                          controller: usernameController,

                        ),

                        SizedBox(height: 18.h),


                        Text(
                          "Password",
                          style: TextStyle(
                            color: Pallette.textGrey,
                            fontSize: 13.sp,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        CustomTextField(

                          hint: "Enter your password",
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          isPassword: true,
                        ),

                        SizedBox(height: 30.h),


                        CustomButton(
                          text: "Login",
                          onTap: ()async {
                            final authprovider = context.read<Authprovider>();

                            if (usernameController.text.isEmpty) {
                              return showSnackBarMsg(
                                context,
                                "Please enter username",
                                const Color.fromARGB(255, 204, 39, 27),
                              );
                            } else if (passwordController.text.isEmpty) {
                              return showSnackBarMsg(
                                context,
                                "Please enter password",
                                const Color.fromARGB(255, 204, 39, 27),
                              );
                            }

                            final user = await authprovider.userLogin(
                              username: usernameController.text.trim(),
                              password: passwordController.text.trim(),
                            );

                            if (user != null) {
                            //  await authprovider.getUserData();
                              debugPrint('name: ${user.name}');

                              final prefs = await SharedPreferences.getInstance();
                              debugPrint('token : ${prefs.getString('access_token')}');

                              if (context.mounted) {
                                showSnackBarMsg(
                                  context,
                                  "Login successfully",
                                  Colors.green,
                                );
                                await Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  CustomRoutes.patientScreen,
                                      (route) => false,
                                );
                              }
                            } else {
                              if (context.mounted) {
                                return showSnackBarMsg(
                                  context,
                                  "User does not exist",
                                  const Color.fromARGB(255, 204, 39, 27),
                                );
                              }
                            }


                          },
                        ),

                        SizedBox(height: 18.h),


                        Center(
                          child: Text.rich(
                            TextSpan(
                              text:
                              "By creating or logging into an account you are agreeing\nwith our ",
                              style: TextStyle(fontSize: 12.sp),
                              children: [
                                TextSpan(
                                  text: "Terms and Conditions",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const TextSpan(text: " and "),
                                TextSpan(
                                  text: "Privacy Policy",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


