import 'package:flutter/material.dart';

customFormField({
  required String hintText,
  required TextEditingController controller,
  required String label,
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
  bool isPassword = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
    child: StatefulBuilder(builder: (context, internalState) {
      return TextFormField(
        obscureText: obscureText,
        keyboardType: TextInputType.text,
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: () {
                    internalState(() {
                      obscureText = !obscureText;
                    });
                  },
                  icon: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off))
              : null,
          hintText: hintText,
          label: Text(
            capitalize(label),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.black,
            ),
          ),
          errorStyle: const TextStyle(
            color: Colors.red,
          ),
        ),
      );
    }),
  );
}

// make a function to convert a string to capital case
String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

// make a function for custom button

customButton(
    {required String text,
    required Function onPressed,
    ButtonStyle? style}) {
  return ElevatedButton(
    onPressed: () {
      onPressed();
    },
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(
        horizontal: 50,
        vertical: 15,
      ),
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    ),
  );
}
