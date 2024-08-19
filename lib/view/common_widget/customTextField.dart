import 'package:flutter/material.dart';

Widget customTextField({
  required TextEditingController controller,
  required String label,
  required String hintText,
  String? errorMessage,
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
  ValueChanged<String>? onChanged,
}) {
  return TextField(
    controller: controller,
    obscureText: obscureText,
    keyboardType: keyboardType,
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: label,
      hintText: hintText,
      errorText: errorMessage,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: errorMessage == null ? Colors.grey : Colors.red,
          width: 2.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: errorMessage == null ? Colors.blue : Colors.red,
          width: 2.0,
        ),
      ),
      fillColor: Colors.white,
      filled: true,
      contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
    ),
  );
}
