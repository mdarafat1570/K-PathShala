import 'package:flutter/material.dart';
import 'package:kpathshala/app_theme/app_color.dart';

enum TextType { title, subtitle, paragraphTitle, normal, paragraphTitleNormal }

Widget customText(
    String text,
    TextType type, {
      Color? color,
      double? fontSize,
      FontWeight? fontWeight,
      TextAlign? textAlign, // New optional parameter for text alignment
    }) {
  switch (type) {
    case TextType.title:
      return Text(
        text,
        style: TextStyle(
          color: color ?? AppColor.navyBlue,
          fontSize: fontSize ?? 35.0,
          fontWeight: fontWeight ?? FontWeight.bold,
        ),
        textAlign: textAlign ?? TextAlign.left, // Default to left alignment
      );
    case TextType.subtitle:
      return Text(
        text,
        style: TextStyle(
          color: color ?? Colors.grey,
          fontSize: fontSize ?? 18.0,
          fontWeight: fontWeight ?? FontWeight.w500,
        ),
        textAlign: textAlign ?? TextAlign.left, // Default to left alignment
      );
    case TextType.paragraphTitle:
      return Text(
        text,
        style: TextStyle(
          color: color ?? Colors.black,
          fontSize: fontSize ?? 20.0,
          fontWeight: fontWeight ?? FontWeight.w600,
        ),
        textAlign: textAlign ?? TextAlign.left, // Default to left alignment
      );
    case TextType.normal:
      return Text(
        text,
        style: TextStyle(
          color: color ?? Colors.black,
          fontSize: fontSize ?? 14.0,
          fontWeight: fontWeight ?? FontWeight.normal,
        ),
        textAlign: textAlign ?? TextAlign.left, // Default to left alignment
      );
    case TextType.paragraphTitleNormal:
      return Text(
        text,
        style: TextStyle(
          color: color ?? AppColor.navyBlue,
          fontSize: fontSize ?? 20.0,
          fontWeight: fontWeight ?? FontWeight.w600,
        ),
        textAlign: textAlign ?? TextAlign.left, // Default to left alignment
      );
  }
}


Widget customGap({double width = 0, double height = 0}) {
  return SizedBox(
    width: width,
    height: height,
  );
}
