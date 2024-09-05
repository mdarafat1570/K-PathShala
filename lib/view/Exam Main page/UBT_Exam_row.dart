import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kpathshala/app_theme/app_color.dart';

import 'package:kpathshala/view/common_widget/custom_text.dart.dart';

class CourseRow extends StatelessWidget {
  final String title;
  final String description;
  final int score;
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color scoreTextColor = score >= 40 ? AppColor.navyBlue : Colors.red;
    final String completionText = score >= 40 ? 'Flawless Score' : 'Complete';
    final Color containerColor = score >= 40
        ? const Color.fromRGBO(26, 35, 126, 0.2)
        : const Color.fromRGBO(255, 111, 97, 0.2);

    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                    Row(
                      children: [
                        customText(title, TextType.paragraphTitle),
                        const SizedBox(width: 10),
                        Container(
                          width: 120,
                          height: 25,
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
                                    : Colors.red,
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
                        const SizedBox(width: 5),
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
                                  borderRadius: BorderRadius.circular(36),
                                ),
                                textStyle: const TextStyle(fontSize: 13),
                                padding: EdgeInsets.zero,
                              ),
                              child: Center(
                                child: Text(
                                  buttonLabel,
                                  style: const TextStyle(
                                      color: AppColor.white, fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        ElevatedButton(
                          onPressed: onDetailsClick,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppColor.navyBlue,
                            backgroundColor:
                                const Color.fromRGBO(26, 35, 126, 0.2),
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
      ),
    );
  }
}
