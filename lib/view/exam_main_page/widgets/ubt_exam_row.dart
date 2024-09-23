import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:kpathshala/app_theme/app_color.dart';

import 'package:kpathshala/view/common_widget/custom_text.dart.dart';

class CourseRow extends StatelessWidget {
  final String title;
  final String description;
  final int? score;
  final VoidCallback onDetailsClick;
  final VoidCallback onRetakeTestClick;
  final String buttonLabel;
  final int readingTestScore;
  final int listingTestScore;
  final String timeTaken;

  const CourseRow({
    required this.title,
    required this.description,
    required this.score,
    required this.onDetailsClick,
    required this.onRetakeTestClick,
    required this.buttonLabel,
    required this.readingTestScore,
    required this.listingTestScore,
    required this.timeTaken,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color scoreTextColor = (score ?? 0) >= 40 ? AppColor.navyBlue : AppColor.brightCoral;
    final String completionText = (score ?? 0) >= 40 ? 'Flawless Score' : (score == null ? '' : 'Completed');
    final Color containerColor = (score ?? 0) >= 40
        ? const Color.fromRGBO(26, 35, 126, 0.2)
        : (score == null ? Colors.red : const Color.fromRGBO(255, 111, 97, 0.2));
    final Color borderColor = (score ?? 0) >= 40
        ? const Color.fromRGBO(26, 35, 126, 0.2)
        : (score == null ? Colors.white : AppColor.brightCoral);
    final Color rowColor = (score ?? 0) >= 40
        ? const Color.fromRGBO(136, 208, 236, 0.2)
        : (score == null ? Colors.white : Colors.white);


    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: rowColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 0.5
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row
                    if (title.isNotEmpty)
                      Row(
                        children: [
                          Expanded(child: customText(title, TextType.normal, fontWeight: FontWeight.w600)),
                          const Gap(5),
                          if (completionText.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: containerColor,
                              ),
                              child: Center(
                                child: Text(
                                  completionText,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: scoreTextColor,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    const SizedBox(height: 3),

                    // Description
                    if (description.isNotEmpty)
                      Text(
                        description,
                        style: const TextStyle(
                          color: Color.fromRGBO(102, 102, 102, 1),
                          fontSize: 10,
                        ),
                      ),
                    const SizedBox(height: 3),

                    // Score Row
                    if (score != null)
                      Row(
                        children: [
                          customText('Your Score:', TextType.normal,
                              fontSize: 10, fontWeight: FontWeight.w600, color: AppColor.navyBlue),
                          const SizedBox(width: 5),
                          Text(
                            '$score',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: scoreTextColor,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 8.0),

                    // Button Row
                    Row(
                      children: [
                        // Retake Test Button
                        if (buttonLabel.isNotEmpty)
                          SizedBox(
                            width: 100,
                            height: 30,
                            child: ElevatedButton(
                              onPressed: onRetakeTestClick,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: AppColor.navyBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(36),
                                ),
                                textStyle: const TextStyle(fontSize: 13),
                                padding: EdgeInsets.zero,
                              ),
                              child: Center(
                                child: Text(
                                  buttonLabel,
                                  style: const TextStyle(color: AppColor.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(width: 5),

                        // Details Button
                        InkWell(
                          borderRadius: BorderRadius.circular(36),
                          onTap: onDetailsClick,
                          child: Container(
                            width: 40,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(36),
                              color: const Color.fromRGBO(26, 35, 126, 0.2),
                            ),
                            child: const Center(
                              child: FaIcon(
                                FontAwesomeIcons.angleDown,
                                size: 14,
                                color: AppColor.navyBlue,
                              ),
                            ),
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
      ),
    );
  }
}
