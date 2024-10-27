import 'package:flutter/material.dart';
import 'package:kpathshala/app_theme/app_color.dart';

class BottomNavBar extends StatelessWidget {
  final bool isListViewVisible;
  final bool isPreviousButtonVisible;
  final bool isSubmitAnswerButtonVisible;
  final bool isNextButtonVisible;
  final VoidCallback moveToPrevious;
  final VoidCallback checkAnswerLength;
  final VoidCallback moveToNext;
  final VoidCallback onTotalQuestionsPress;

  const BottomNavBar({
    super.key,
    required this.isListViewVisible,
    required this.isPreviousButtonVisible,
    required this.isSubmitAnswerButtonVisible,
    required this.isNextButtonVisible,
    required this.moveToPrevious,
    required this.checkAnswerLength,
    required this.moveToNext,
    required this.onTotalQuestionsPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!isListViewVisible)
            _buildQuestionNavbarButton(
              context,
              'Previous',
              AppColor.navyBlue,
              isPreviousButtonVisible ? moveToPrevious : null,
              textColor: isPreviousButtonVisible ? Colors.white : Colors.grey[600]!,
            )
          else
            const SizedBox(),
          if (!isListViewVisible)
            _buildQuestionNavbarButton(
              context,
              'Total Questions',
              AppColor.grey200,
              onTotalQuestionsPress,
            ),
          if (isSubmitAnswerButtonVisible)
            _buildQuestionNavbarButton(
              context,
              'Submit Answer',
              AppColor.navyBlue,
              checkAnswerLength,
              textColor: Colors.white,
            ),
          if (isNextButtonVisible)
            _buildQuestionNavbarButton(
              context,
              'Next',
              AppColor.navyBlue,
              moveToNext,
              textColor: Colors.white,
            ),
        ],
      ),
    );
  }

  Widget _buildQuestionNavbarButton(
      BuildContext context,
      String text,
      Color backgroundColor,
      VoidCallback? onPressed, {
        Color textColor = AppColor.navyBlue,
      }) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.25,
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
}
