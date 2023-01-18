import 'package:flutter/material.dart';
import 'package:plantation/Screen/Demand/demand.dart';
import 'package:plantation/Screen/Home/home.dart';
import 'package:plantation/Screen/Login/login.dart';
import 'package:plantation/Screen/Unsynced%20Forms/sync_form_page.dart';
import 'package:plantation/decision_tree.dart';
import 'package:sizer/sizer.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
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
            '/unsyncForm': (context) => const SyncFormPage(),
          },
          initialRoute: '/',
        );
      },
    );
  }
}
