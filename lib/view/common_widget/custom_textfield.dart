import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class CustomTextField extends StatelessWidget {
  final bool isEnabled;
  final bool isObscure;
  final String? label;
  final String? errorMessage;
  final String? initialValue;
  final int? maxLength;
  final int? maxLines;
  final double? fontSize;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatter;
  final Widget? suffixIcon;
  final String? prefix;
  final Widget? prefixIcon;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    this.isEnabled = true,
    this.label,
    this.errorMessage,
    this.initialValue,
    this.maxLength,
    this.maxLines,
    this.fontSize = 16,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.inputFormatter,
    this.isObscure = false,
    this.suffixIcon,
    this.prefix,
    this.prefixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
              color: (errorMessage != null && errorMessage!.isNotEmpty)
                  ? Colors.red
                  : Colors.transparent,
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (label != null)
                Text(
                  label ?? '',
                  style: const TextStyle(
                      fontSize: 10.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300),
                ),
                if (label != null)
                const Gap(2),
                TextFormField(
                  enabled: isEnabled,
                  initialValue: initialValue,
                  controller: controller,
                  keyboardType: keyboardType,
                  obscureText: isObscure,
                  onChanged: onChanged,
                  maxLength: maxLength,
                  maxLines: maxLines,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    suffix: suffixIcon,
                    prefixText: prefix,
                    prefixIcon: prefixIcon,
                    prefixIconConstraints:const BoxConstraints(
                      minHeight: 0,
                      minWidth: 0,
                    ),
                    counterText: '',
                  ),
                  style: TextStyle(
                    color: isEnabled ? Colors.black : Colors.grey,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w400,
                  ),
                  inputFormatters:inputFormatter,
                ),
              ],
            ),
          ),
        ),
        if (errorMessage != null && errorMessage!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Text(
              errorMessage ?? '',
              style: const TextStyle(
                fontSize: 10,
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }
}