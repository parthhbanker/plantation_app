import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
        body: Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 25.h,
            ),
            SizedBox(
              height: 10.h,
            ),
            homePageButton(
              color: Colors.green,
              radius: 12,
              text: "Demand Tree",
              fontsize: 15.sp,
              onPressed: () {
                Navigator.pushNamed(context, '/demand');
              },
            ),
            homePageButton(
              color: Colors.green,
              radius: 12,
              text: "Unsynced Forms",
              fontsize: 15.sp,
              onPressed: () {
                Fluttertoast.showToast(msg: "Unsynced Form Pressed");
              },
            ),
            homePageButton(
              color: Colors.green,
              radius: 12,
              text: "Sync Forms",
              fontsize: 15.sp,
              onPressed: () {
                Fluttertoast.showToast(msg: "Sync Form Pressed");
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.h),
              child: homePageButton(
                color: const Color.fromARGB(255, 49, 138, 52),
                text: "Logout",
                radius: 12,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                fontsize: 15.sp,
              ),
            ),
          ],
        ),
      ),
    ));
  }

  homePageButton(
      {required Color color,
      required String text,
      required double radius,
      double fontsize = 16,
      required Function onPressed}) {
    return Padding(
      padding: EdgeInsets.all(6.sp),
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(horizontal: 18.sp, vertical: 8.sp),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          fixedSize: Size(55.w, 6.h),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontsize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
