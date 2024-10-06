import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:velocity_x/velocity_x.dart';

void showCustomDialog({
  required BuildContext context,
  bool showErrorDialog = false,
  bool showSuccessDialog = false,
  bool showWarningDialog = false,
  int? missedQuestions,
  bool showTimeUpDialog = false,
  bool showNoAnswerSelectedDialog = false,
  required VoidCallback onPrimaryAction,
  VoidCallback? onSecondaryAction, // Optional for cases like cancel
  bool isPopScope = false,
  bool barrierDismissible = true,
}) {
  showDialog(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (context) {
      return isPopScope
          ? PopScope(
              canPop: false,
              onPopInvoked: (bool didPop) async {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: _buildDialogContent(
                  context,
                  showErrorDialog,
                  showSuccessDialog,
                  showWarningDialog,
                  showTimeUpDialog,
                  showNoAnswerSelectedDialog,
                  onPrimaryAction,
                  onSecondaryAction,
                  missedQuestions,
              ),
            )
          : _buildDialogContent(
              context,
              showErrorDialog,
              showSuccessDialog,
              showWarningDialog,
              showTimeUpDialog,
              showNoAnswerSelectedDialog,
              onPrimaryAction,
              onSecondaryAction,
              missedQuestions,
      );
    },
  );
}

Widget _buildDialogContent(
  BuildContext context,
  bool showErrorDialog,
  bool showSuccessDialog,
  bool showWarningDialog,
  bool showTimeUpDialog,
  bool showNoQuestionSelectedDialog,
  VoidCallback onPrimaryAction,
  VoidCallback? onSecondaryAction,
    int? missedQuestions,
) {
  // Determine content based on flags
  String title = '';
  String message = '';
  IconData icon = Icons.info;
  Color iconBackgroundColor = Colors.blue;
  String primaryButtonLabel = 'OK';
  String secondaryButtonLabel = 'Cancel';

  if (showErrorDialog) {
    title = 'Error!';
    message = 'Something went wrong while submitting!';
    icon = Icons.close;
    iconBackgroundColor = Colors.red;
    primaryButtonLabel = 'TRY AGAIN';
  } else if (showSuccessDialog) {
    title = 'Success!';
    message = 'Answer Submitted Successfully';
    icon = Icons.check;
    iconBackgroundColor = Colors.green;
    primaryButtonLabel = 'See Result!';
  } else if (showWarningDialog) {
    title = 'Warning';
    message = 'You have missed $missedQuestions questions. Submit anyway?';
    icon = Icons.warning;
    iconBackgroundColor = AppColor.navyBlue;
    primaryButtonLabel = 'Submit Anyway';
    secondaryButtonLabel = 'Cancel';
  } else if (showTimeUpDialog) {
    title = 'Time Up';
    message = 'Your time for the test has ended. Please submit your answer.';
    icon = Icons.timer;
    iconBackgroundColor = Colors.purple;
    primaryButtonLabel = 'Submit Answer';
    secondaryButtonLabel = 'Cancel';
  } else if (showNoQuestionSelectedDialog) {
    title = 'Exam Not Attempted';
    message = "You haven't answered any questions yet.\nPlease attempt the exam to submit your answers.";
    icon = Icons.error;
    iconBackgroundColor = AppColor.navyBlue;
    secondaryButtonLabel = 'Close';
  }

  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    child: Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: iconBackgroundColor,
            child: Icon(icon, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: onSecondaryAction == null
                ? MainAxisAlignment.center
                : MainAxisAlignment.end,
            children: [
              if (onSecondaryAction != null)
                ElevatedButton(
                  onPressed: onSecondaryAction,
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      backgroundColor: Colors.grey),
                  child: Text(secondaryButtonLabel),
                ),
              if (onSecondaryAction != null)
                const Gap(10),
              ElevatedButton(
                onPressed: onPrimaryAction,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    backgroundColor: iconBackgroundColor),
                child: Text(primaryButtonLabel),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
