import 'package:customizable_counter/customizable_counter.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

customFormField({
  required String hintText,
  required TextEditingController controller,
  required String label,
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
  bool isPassword = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    child: StatefulBuilder(builder: (context, internalState) {
      return TextFormField(
        autofocus: true,
        obscureText: obscureText,
        keyboardType: TextInputType.text,
        controller: controller,
        autovalidateMode: AutovalidateMode.always,
        decoration: InputDecoration(
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: () {
                    internalState(() {
                      obscureText = !obscureText;
                    });
                  },
                  icon: Icon(
                      !obscureText ? Icons.visibility : Icons.visibility_off))
              : null,
          hintText: hintText,
          label: Text(
            capitalize(label),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x66000000),
              width: 2,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(10),
              topLeft: Radius.circular(10),
              topRight: Radius.circular(20),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x66000000),
              width: 2,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(10),
              topLeft: Radius.circular(10),
              topRight: Radius.circular(20),
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x66FF0004),
              width: 2,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(10),
              topLeft: Radius.circular(10),
              topRight: Radius.circular(20),
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x66FF0004),
              width: 2,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(10),
              topLeft: Radius.circular(10),
              topRight: Radius.circular(20),
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
        ),
      );
    }),
  );
}

// make a function to convert a string to capital case
String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

// make a function for custom button

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.title,
    required this.tap,
  }) : super(key: key);

  final String title;
  final Function tap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        tap();
      },
      child: Container(
        // width: 90.w,
        height: 9.h,
        margin: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: Colors.black45),
          borderRadius: BorderRadius.circular(10.sp),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(81, 0, 0, 0),
              offset: Offset(0.0, 1.0),
              blurRadius: 10.0,
            ),
          ],
        ),
        padding: EdgeInsets.all(10.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            const Icon(Icons.arrow_forward_ios_rounded),
          ],
        ),
      ),
    );
  }
}

class CommonButton extends StatelessWidget {
  const CommonButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 67, 210, 72),
          padding: EdgeInsets.symmetric(horizontal: 18.sp, vertical: 8.sp),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.sp),
                bottomLeft: Radius.circular(10.sp),
                bottomRight: Radius.circular(20.sp),
                topLeft: Radius.circular(20.sp)),
          ),
          fixedSize: Size(45.w, 7.h),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    Key? key,
    this.value,
    required this.data,
    required this.func,
    required this.hint,
  }) : super(key: key);

  final int? value;
  final List<DropdownMenuItem> data;
  final Function func;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.sp, vertical: 12.sp),
      child: DropdownButtonFormField(
        // value: value,
        hint: Text(hint),
        items: data,
        decoration: InputDecoration(
          focusColor: Colors.transparent,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black.withOpacity(0.2),
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(30.sp),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.blueAccent,
            ),
            borderRadius: BorderRadius.circular(30.sp),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.3),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.sp),
            borderSide: BorderSide(
              color: Colors.red.shade600,
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(20.sp),

        // isExpanded: true,
        onChanged: (value) {
          func(value);
        },
      ),
    );
  }
}

class CustomQuantity extends StatelessWidget {
  const CustomQuantity({Key? key, required this.tree, required this.list})
      : super(key: key);

  final dynamic tree;
  final Map<String, double> list;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 5.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(tree['tree_name'].toString()),
          CustomizableCounter(
            minCount: 0,
            step: 1,
            borderRadius: 20.sp,
            onCountChange: (c) {
              c == 0
                  ? list.remove(
                      tree['id'].toString(),
                    )
                  : list[tree['id'].toString()] = c;
            },
          ),
        ],
      ),
    );
  }
}

