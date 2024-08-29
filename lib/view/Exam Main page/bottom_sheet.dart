import 'package:flutter/material.dart';
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/view/common_widget/common_button_add.dart';
import 'package:fui_kit/fui_kit.dart';

import '../../app_base/common_imports.dart'; // Importing fui_kit for Gap

class BottomSheetPage extends StatefulWidget {
  const BottomSheetPage({super.key});

  @override
  State<BottomSheetPage> createState() => _BottomSheetPageState();
}

class _BottomSheetPageState extends State<BottomSheetPage> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Column(
        children: [
          Flexible(
            child: Divider(
              color: Color.fromARGB(255, 217, 217, 217),
              thickness: 4,
              indent: screenWidth * 0.3,
              endIndent: screenWidth * 0.3,
            ),
          ),
          Gap(screenHeight * 0.03),
          customText("Confirm purchase", TextType.paragraphTitle),
          Gap(screenHeight * 0.03),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(width: 0.2, color: Colors.black),
              color: Color.fromRGBO(245, 245, 245, 1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Payment of ৳999.00",
                    style: TextStyle(
                      color: AppColor.navyBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(screenHeight * 0.01),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: RichText(
                      text: TextSpan(
                        text: "You’ll have access to UBT Mock Test till ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                        children: [
                          TextSpan(
                            text: "12th January 2025",
                            style: TextStyle(
                              color: AppColor.navyBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Gap(screenHeight * 0.03),
          commonCustomButton(
            width: double.infinity,
            backgroundColor: AppColor.navyBlue,
            height: 60,
            borderRadius: 30,
            onPressed: () {},
            reversePosition: false,
            child: Text(
              "Proceed to payment",
              style: TextStyle(color: AppColor.white, fontSize: 20),
            ),
          ),
          Gap(screenHeight * 0.03),
          SizedBox(
            width: double.infinity,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text:
                    "By proceeding you’re agreeing with K-Pathshala’s purchasing ",
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: "and refund policy.",
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
