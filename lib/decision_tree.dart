import 'package:flutter/material.dart';
import 'package:plantation/Screen/Home/home.dart';
import 'package:plantation/Screen/Login/login.dart';
import 'package:plantation/utils/dbhelper.dart';

// check if the user is logged in
bool isLoggedIn() {
  // check if the user is logged in
  return true;
}

class DecisionTree extends StatelessWidget {
  const DecisionTree({Key? key}) : super(key: key);

  @override
  StatefulWidget build(BuildContext context) {
    DatabaseHelper().opendb();
    if (isLoggedIn()) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}
