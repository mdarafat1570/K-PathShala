import 'package:flutter/material.dart';
import 'package:kpathshala/app_theme/app_color.dart';

enum TextType { title, subtitle, paragraphTitle, normal, paragraphTitlenormal }

Widget customText(String text, TextType type,
    {Color? color, double? fontSize, FontWeight? fontWeight}) {
  switch (type) {
    case TextType.title:
      return Text(
        text,
        style: TextStyle(
          color: color ?? AppColor.navyBlue,
          fontSize: fontSize ?? 35.0,
          fontWeight: fontWeight ?? FontWeight.bold,
        ),
      );
    case TextType.subtitle:
      return Text(
        text,
        style: TextStyle(
          color: color ?? Colors.grey,
          fontSize: fontSize ?? 18.0,
          fontWeight: fontWeight ?? FontWeight.w500,
        ),
      );
    case TextType.paragraphTitle:
      return Text(
        text,
        style: TextStyle(
          color: color ?? Colors.black,
          fontSize: fontSize ?? 20.0,
          fontWeight: fontWeight ?? FontWeight.w600,
        ),
      );
    case TextType.normal:
      return Text(
        text,
        style: TextStyle(
          color: color ?? Colors.black,
          fontSize: fontSize ?? 14.0,
          fontWeight: fontWeight ?? FontWeight.normal,
        ),
      );
    case TextType.paragraphTitlenormal:
      return Text(
        text,
        style: TextStyle(
          color: color ?? AppColor.navyBlue,
          fontSize: fontSize ?? 20.0,
          fontWeight: fontWeight ?? FontWeight.w600,
        ),
      );
  }
}

Widget customGap({double width = 0, double height = 0}) {
  return SizedBox(
    width: width,
    height: height,
  );
}
