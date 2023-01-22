import 'package:flutter/material.dart';
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
                    setState(() {
                      logout();
                    });
                    Navigator.pushReplacementNamed(context, '/login');
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

    await prefs.remove("isLoggedIn");
    await prefs.remove("surveyor_id");

    DbQueries.dropTables();
  }


}
