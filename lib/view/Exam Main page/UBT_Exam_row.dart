import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/view/common_widget/custom_text.dart.dart';

Widget courserow(
  String title,
  String description, {
  required VoidCallback onDetailsClick,
  required int score,
  required VoidCallback onRetakeTestClick,
  required String buttonLabel,
  required readingTestScore,
  required listingTestScore,
  required timeTaken,
}) {
  final Color scoreTextColor = score >= 40 ? AppColor.navyBlue : Colors.red;
  final String completionText = score >= 40 ? 'Flawless' : 'Complete';
  final Color containerColor = score >= 40
      ? const Color.fromRGBO(26, 35, 126, 0.2)
      : const Color.fromRGBO(255, 111, 97, 0.2);

  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    customText(title, TextType.paragraphTitle),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        width: 90,
                        height: 29,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: containerColor,
                        ),
                        child: Center(
                          child: Text(
                            completionText,
                            style: TextStyle(
                                color: score >= 40
                                    ? AppColor.navyBlue
                                    : Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color.fromRGBO(102, 102, 102, 1),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    customText('Your Score:', TextType.normal),
                    const Gap(5),
                    Text(
                      '$score',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: scoreTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 140,
                        height: 35,
                        child: ElevatedButton(
                          onPressed: onRetakeTestClick,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: AppColor.navyBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: const TextStyle(fontSize: 13),
                          ),
                          child: Text(buttonLabel),
                        ),
                      ),
                    ),
                    const Gap(5),
                    ElevatedButton(
                      onPressed: onDetailsClick,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppColor.navyBlue,
                        backgroundColor: const Color.fromRGBO(26, 35, 126, 0.2),
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                        shadowColor: Colors.transparent,
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.arrowDown,
                        size: 16,
                        color: AppColor.navyBlue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
