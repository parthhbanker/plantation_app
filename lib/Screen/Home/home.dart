import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
            homePageButton(
              color: Colors.green,
              radius: 12,
              text: "Demand Tree",
              fontsize: 20,
              onPressed: () {
                Navigator.pushNamed(context, '/demand');
              },
            ),
            homePageButton(
              color: Colors.green,
              radius: 12,
              text: "Unsynced Forms",
              fontsize: 20,
              onPressed: () {
                Fluttertoast.showToast(msg: "Unsynced Form Pressed");
              },
            ),
            homePageButton(
              color: Colors.green,
              radius: 12,
              text: "Sync Forms",
              fontsize: 20,
              onPressed: () {
                Fluttertoast.showToast(msg: "Sync Form Pressed");
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: homePageButton(
                  color: const Color.fromARGB(255, 49, 138, 52),
                  text: "Logout",
                  radius: 12,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  fontsize: 20),
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
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          fixedSize: const Size(200, 50),
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
