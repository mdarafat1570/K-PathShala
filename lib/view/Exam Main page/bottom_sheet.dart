import 'package:flutter/material.dart';
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/view/Exam%20Main%20page/exam.dart';
import 'package:kpathshala/view/common_widget/common_button_add.dart';
import '../../app_base/common_imports.dart'; // Importing fui_kit for Gap

class BottomSheetPage extends StatefulWidget {
  final BuildContext context;
  const BottomSheetPage({super.key, required this.context});

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
          // Divider with Circular Edges
          Container(
            width: screenWidth * 0.2, // Adjust the width as needed
            height: 4, // Adjust the height (thickness) as needed
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 217, 217, 217), // Divider color
              borderRadius: BorderRadius.circular(8), // Circular edges
            ),
          ),
          Gap(screenHeight * 0.03),
          customText("Confirm purchase", TextType.paragraphTitle),
          Gap(screenHeight * 0.03),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(width: 0.2, color: Colors.black),
              color: const Color.fromRGBO(245, 245, 245, 1),
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
                        style: const TextStyle(
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExamPage()),
              );
            },
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
