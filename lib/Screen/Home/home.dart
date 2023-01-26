import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plantation/utils/components.dart';
import 'package:plantation/utils/dbqueries.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(10.sp),
          height: 100.h,
          width: 100.w,
          child: SingleChildScrollView(
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
                CustomButton(
                  title: "Fill Form",
                  tap: () {
                    Navigator.pushNamed(context, '/demand');
                  },
                ),
                CustomButton(
                  title: "Unsynced Forms",
                  tap: () {
                    Navigator.pushNamed(context, '/unsyncForm');
                  },
                ),
                Divider(
                  endIndent: 10.sp,
                  indent: 10.sp,
                  thickness: 1.sp,
                ),
                CommonButton(
                  text: "Logout",
                  onPressed: () {
                    setState(
                      () {
                        logout().then(
                          (value) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (Route<dynamic> route) => false,
                            );
                          },
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future logout() async {
    final prefs = await SharedPreferences.getInstance();

    final directory = await getApplicationDocumentsDirectory();

    final dir1 = Directory("${directory.path}/surveyor_sign");
    final dir2 = Directory("${directory.path}/farmer_sign");
    final dir3 = Directory("${directory.path}/farmer_image");

    await prefs.remove("isLoggedIn");
    await prefs.remove("surveyor_id");

    if (dir1.existsSync()) {
      dir1.deleteSync(recursive: true);
    }
    if (dir2.existsSync()) {
      dir2.deleteSync(recursive: true);
    }
    if (dir3.existsSync()) {
      dir3.deleteSync(recursive: true);
    }

    DbQueries.dropTables();
  }
}
