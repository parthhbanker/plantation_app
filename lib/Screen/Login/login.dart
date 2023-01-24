import 'package:flutter/material.dart';
import 'package:plantation/api/api.dart';
import 'package:plantation/api/const.dart';
import 'package:plantation/utils/components.dart';
import 'package:plantation/utils/dbqueries.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(10.sp),
          height: 100.h,
          width: 100.w,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.sp),
                    child: Image.asset(
                      'assets/logo.png',
                      height: 25.h,
                    ),
                  ),
                  customFormField(
                    hintText: "Enter username",
                    controller: usernameController,
                    label: "Username",
                  ),
                  customFormField(
                    hintText: "Enter password",
                    controller: passwordController,
                    label: "Password",
                    isPassword: true,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                  ),
                  Divider(
                    endIndent: 10.sp,
                    indent: 10.sp,
                    thickness: 1.sp,
                  ),
                  CommonButton(
                    text: "Login",
                    onPressed: () {
                      setState(() {
                        login(usernameController.text, passwordController.text);
                      });
                      DbQueries.createTables();
                      ApiHandler.fetchApiData();
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void login(String username, String password) async {
    var log = await ApiHandler.postApiData(
      url: surveyorLoginUrl,
      body: {"username": username, "password": password},
    );

    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

// Save an integer value to 'counter' key.
    await prefs.setString(
      'surveyor_id',
      (log[0]['surveyor_id']).toString(),
    );
    await prefs.setBool(
      'isLoggedIn',
      true,
    );
  }
}
