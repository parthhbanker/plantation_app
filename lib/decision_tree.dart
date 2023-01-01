import 'package:flutter/material.dart';
import 'package:plantation/Screen/Home/home.dart';
import 'package:plantation/Screen/Login/login.dart';

// check if the user is logged in
bool isLoggedIn() {
  // check if the user is logged in
  return true;
}

class DecisionTree extends StatefulWidget {
  const DecisionTree({Key? key}) : super(key: key);

  @override
  State<DecisionTree> createState() => _DecisionTreeState();
}

class _DecisionTreeState extends State<DecisionTree> {
  @override
  StatefulWidget build(BuildContext context) {
    
    if (isLoggedIn()) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}
