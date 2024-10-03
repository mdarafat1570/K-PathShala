import 'package:flutter/material.dart';
import 'package:kpathshala/app_theme/app_color.dart';

Widget buildQuestionNavbarButton(
    BuildContext context,
    String text,
    Color backgroundColor,
    VoidCallback onPressed, {
      Color textColor = AppColor.navyBlue,
    }) {
  return SizedBox(
    width: MediaQuery.sizeOf(context).width * 0.2,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColor.grey400, width: 1),
        ),
        backgroundColor: backgroundColor,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: textColor,
        ),
      ),
    ),
  );
}