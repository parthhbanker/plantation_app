import 'package:flutter/material.dart';
import 'package:plantation/Screen/Home/home.dart';
import 'package:plantation/utils/components.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 208, 214, 219),
          ),
        ),
        Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                customFormField(
                    controller: usernameController,
                    label: 'username',
                    hintText: 'Enter your username'),
                const SizedBox(height: 20),
                customFormField(
                  label: 'password',
                  hintText: 'Enter your password',
                  controller: passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                customButton(
                  text: "Login",
                  onPressed: () {
                    login(usernameController.text, passwordController.text,
                        context);
                  },
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }
}

// make a function to check if the user is logged in or not
void login(String username, String password, BuildContext context) {
  if (username == 'admin' && password == 'admin') {
    // navigate to home page

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  } else {
    // show error message
  }
}
