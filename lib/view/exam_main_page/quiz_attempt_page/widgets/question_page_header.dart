import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kpathshala/app_theme/app_color.dart';

class PageHeader extends StatelessWidget {
  final bool isListViewVisible;
  final String formattedTime;
  final int totalQuestions;
  final int solvedQuestions;
  final int unsolvedQuestions;
  final String userImageUrl;
  final String userName;

  const PageHeader({
    super.key,
    required this.isListViewVisible,
    required this.formattedTime,
    required this.totalQuestions,
    required this.solvedQuestions,
    required this.unsolvedQuestions,
    required this.userImageUrl,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> imageProvider;

    if (userImageUrl.isNotEmpty) {
      imageProvider = NetworkImage(userImageUrl);
    } else {
      imageProvider = const AssetImage('assets/new_App_icon.png');
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildUserProfile(imageProvider),
              _buildStats(),
            ],
          ),
        ),
        Container(
          color: AppColor.navyBlue,
          width: double.maxFinite,
          height: 1,
        ),
      ],
    );
  }


  Widget _buildUserProfile(ImageProvider imageProvider) {
    return Flexible(
      flex: 1,
      fit: FlexFit.loose,
      child: Row(
        children: [
          CircleAvatar(radius: 17, backgroundImage: imageProvider),
          const Gap(10),
          if (userName.isNotEmpty)
            Expanded(
              child: Text(
                userName,
                style: const TextStyle(fontSize: 12, color: AppColor.grey700),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Flexible(
      flex: 3,
      fit: FlexFit.tight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildQuestionCount(),
          if (!isListViewVisible)
            Container(height: 20, width: 2, color: AppColor.grey400),
          _buildSolvedUnsolved('Solved', solvedQuestions),
          Container(height: 20, width: 2, color: AppColor.grey400),
          _buildSolvedUnsolved('Unsolved', unsolvedQuestions),
          _buildTimeDisplay(),
        ],
      ),
    );
  }

  Widget _buildQuestionCount() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: isListViewVisible
          ? const BoxDecoration(
        border: Border(
          right: BorderSide(width: 3, color: AppColor.navyBlue),
        ),
        color: AppColor.navyBlue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      )
          : null,
      child: Text(
        isListViewVisible
            ? "Total Questions"
            : "Total Questions - $totalQuestions",
        style: TextStyle(
          color: isListViewVisible ? Colors.white : AppColor.grey700,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildSolvedUnsolved(String label, int count) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        '$label Questions-$count',
        style: const TextStyle(color: AppColor.grey700, fontSize: 12),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildTimeDisplay() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(11.0),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 1, color: AppColor.navyBlue),
          right: BorderSide(width: 1, color: AppColor.navyBlue),
          left: BorderSide(width: 1, color: AppColor.navyBlue),
        ),
        color: Color.fromRGBO(26, 35, 126, 0.2),
        borderRadius: BorderRadius.only(topRight: Radius.circular(15)),
      ),
      child: Text(
        formattedTime,
        style: const TextStyle(
          color: AppColor.navyBlue,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
