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
  final int readingTestScore;
  final int listingTestScore;
  final String timeTaken;
  final String status;
  final bool? isInPreviewMode;

  const CourseRow({
    required this.title,
    required this.description,
    required this.score,
    required this.onDetailsClick,
    required this.onRetakeTestClick,
    required this.readingTestScore,
    required this.listingTestScore,
    required this.timeTaken,
    required this.status,
    this.isInPreviewMode = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color scoreTextColor = (score ?? 0) >= 40 ? AppColor.navyBlue : AppColor.brightCoral;
    final String completionText = status == 'flawless' ? 'Flawless Score' : (status == 'completed' ? 'Completed' : '');
    final String buttonLabel = (status == 'flawless' || status == 'completed') ? 'Retake Test' : 'Start';

    final Color containerColor = status == 'flawless'
        ? const Color.fromRGBO(26, 35, 126, 0.2)
        : (score == null ? Colors.red : const Color.fromRGBO(255, 111, 97, 0.2));

    final Color borderColor = (score ?? 0) >= 40
        ? const Color.fromRGBO(26, 35, 126, 0.2)
        : (score == null ? Colors.white : AppColor.brightCoral);

    final Color rowColor = (score ?? 0) >= 40
        ? const Color.fromRGBO(136, 208, 236, 0.2)
        : (score == null ? Colors.white : Colors.white);


    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Container(
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
                          Column(
                            children: [
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isInPreviewMode! ? Colors.black54 : null,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: title,
                                        ),
                                        if (completionText.isNotEmpty)
                                          const WidgetSpan(child: SizedBox(width: 3)),
                                        if (completionText.isNotEmpty)
                                          WidgetSpan(
                                            alignment: PlaceholderAlignment.middle,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25),
                                                color: containerColor,
                                              ),
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
                                    maxLines: null, textScaler: MediaQuery.textScalerOf(context), // Allows wrapping
                                  );
                                },
                              ),
                              const Gap(3),
                            ],
                          ),

                        // Description
                        if (description.isNotEmpty)
                          Column(
                            children: [
                              Text(
                                description,
                                style: TextStyle(
                                  color: isInPreviewMode! ? Colors.black45 : const Color.fromRGBO(102, 102, 102, 1),
                                  fontSize: 10,
                                ),
                              ),
                              const Gap(3),
                            ],
                          ),

                        // Score Row
                        if (score != null)
                          Column(
                            children: [
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
                            ],
                          ),

                        // Button Row
                        Column(
                          children: [
                            const Gap(5),
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
                                        backgroundColor: isInPreviewMode! ? Colors.grey[500] : AppColor.navyBlue,
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
                                      color: isInPreviewMode! ? Colors.grey[200] : const Color.fromRGBO(26, 35, 126, 0.2),
                                    ),
                                    child:  Center(
                                      child: FaIcon(
                                        FontAwesomeIcons.angleDown,
                                        size: 14,
                                        color: isInPreviewMode! ? Colors.grey[500] : AppColor.navyBlue,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
        ),
        if (isInPreviewMode!)
        const Positioned(
          right: 15,
          child: CircleAvatar(
            child: Icon(Icons.lock_rounded, color: AppColor.navyBlue,size: 18,),
          ),
        )
      ],
    );
  }
}
