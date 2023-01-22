import 'package:flutter/material.dart';
import 'package:plantation/Screen/Demand/demand.dart';
import 'package:plantation/Screen/Home/home.dart';
import 'package:plantation/Screen/Login/login.dart';
import 'package:plantation/Screen/Unsynced%20Forms/sync_form_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isLoggedIn = false;
  if (prefs.containsKey("isLoggedIn")) {
    isLoggedIn = prefs.getBool("isLoggedIn");
  }

  runApp(MyApp(
    isLoggedIn: isLoggedIn!,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  final bool isLoggedIn;

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
            '/home': (context) => const HomePage(),
            '/login': (context) => const LoginPage(),
            '/demand': (context) => const DemandPage(),
            '/unsyncForm': (context) => const SyncFormPage(),
          },
          initialRoute: isLoggedIn ? "/home" : "/login",
        );
      },
    );
  }
}
