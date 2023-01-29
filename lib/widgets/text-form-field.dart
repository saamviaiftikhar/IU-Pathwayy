// ignore_for_file: file_names, must_be_immutable, avoid_unnecessary_containers, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget TextFieldWidget({
  required String hintText,
  String? labelText,
  var errorStyle,
  required double height,
  var labelStyle,
  var preffixIcon,
  Widget? SuffixIcon,
  var initialValue,
  int maxLines = 1,
  FocusNode? focusNode,
  bool autoFocus = false,
  bool obscureText = false,
  bool readOnly = false,
  bool inDense = false,
  var style,
  double radius = 8,
  TextEditingController? controller,
  String? Function(String?)? onValidator,
  String? Function(String)? onChanged,
  String? Function(String)? onFieldSubmitted,
  Function()? suffixTap,
  TextInputType? keyboardType,
  TextInputAction? textInputAction,
}) {
  return Container(
    // margin: const EdgeInsets.symmetric(horizontal: 10.0),
    height: height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      // ignore: prefer_const_constructors
      // boxShadow: [
      //   BoxShadow(
      //     color: Color(0xff707070),
      //     spreadRadius: 4,
      //     blurRadius: 7,
      //     offset: Offset(0, 3), // changes position of shadow
      //   )
      // ]
    ),
    child: TextFormField(
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      autofocus: autoFocus,
      readOnly: readOnly,

      style: style,
      maxLines: maxLines,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: onValidator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      // cursorColor: primaryDarkColor,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        isDense: inDense,
        fillColor: Colors.transparent,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        errorStyle: errorStyle,
        labelStyle: labelStyle,
        labelText: labelText,
        // icon != null
        //     ? EdgeInsets.zero
        //     : const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xff1D468A), width: 5.0),
        ),
        suffixIcon: SuffixIcon,
        // hintText == "Enter Password" ||
        //         hintText == "Enter Confirm Password"
        //     ? IconButton(
        //         onPressed: suffixTap,
        //         icon:
        //             Icon(obscureText ? Icons.visibility : Icons.visibility_off),
        //         // color: primaryDarkColor,
        //       )
        //     : null,
        hintText: hintText,
        prefixIcon: preffixIcon,
        hintStyle: const TextStyle(
          // letterSpacing: 3,
          fontWeight: FontWeight.w400,
          color: Color(0xff979797),
          fontSize: 16,
        ),
      ),
    ),
  );
}
