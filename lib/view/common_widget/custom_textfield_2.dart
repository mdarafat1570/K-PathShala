import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final Widget? suffixIcon;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    this.initialValue,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Background color for the full column
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.grey.shade300, // Border color around the column
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
          TextFormField(
            initialValue: initialValue,
            controller: controller,
            keyboardType: keyboardType,
            obscureText: isPassword,
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border:InputBorder.none,
              suffixIcon: suffixIcon,
            ),
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
