import 'package:flutter/material.dart';
import 'package:plantation/Screen/Demand/demand.dart';
import 'package:plantation/Screen/Home/home.dart';
import 'package:plantation/Screen/Login/login.dart';
import 'package:plantation/decision_tree.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    // DbQueries.createTables();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plantation App',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      routes: {
        '/': (context) => const DecisionTree(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/demand': (context) => const DemandPage(),
      },
      initialRoute: '/',
    );
  }
}
