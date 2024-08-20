import 'package:custom_button_builder/custom_button_builder.dart';
import 'package:flutter/material.dart';
import 'package:kpathshala/app_theme/app_color.dart';

Widget commonCustomButton({
  required double width,
  required Color backgroundColor,
  required double height,
  required double borderRadius,
   EdgeInsets? margin,
  required VoidCallback onPressed,
   Widget? iconWidget,
  required bool reversePosition,
  required Widget child,
  bool isThreeD = false,
  Color shadowColor = AppColor.lightGray,
  bool animate = false,
  bool isPressed = false,
}) {
  return CustomButton(
    width: width,
    backgroundColor: backgroundColor,
    height: height,
    borderRadius: borderRadius,
    isThreeD: isThreeD,
    shadowColor: shadowColor,
    pressed: isPressed
        ? Pressed.pressed
        : Pressed.notPressed, 
    animate: animate,
    margin: margin,
    onPressed: onPressed,
    iconWidget: iconWidget,
    reversePosition: reversePosition,
    child: child,
  );
}
