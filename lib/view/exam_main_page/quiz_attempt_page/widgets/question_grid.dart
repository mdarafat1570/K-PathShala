import 'package:flutter/material.dart';
import 'package:kpathshala/app_theme/app_color.dart';

class QuestionGrid extends StatelessWidget {
  final bool dataFound;
  final int readingQuestionsLength;
  final int listeningQuestionsLength;
  final Function(int, bool) isQuestionSolved;
  final Function(int, bool) updateSelectedQuestion;

  const QuestionGrid({
    super.key,
    required this.dataFound,
    required this.readingQuestionsLength,
    required this.listeningQuestionsLength,
    required this.isQuestionSolved,
    required this.updateSelectedQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionColumn(
            context: context,
            image: "assets/book-open.png",
            title: "읽기 ($readingQuestionsLength Questions)",
            questionsLength: readingQuestionsLength,
            isListening: false,
          ),
          _buildQuestionColumn(
            context: context,
            image: "assets/headphones.png",
            title: "듣기 ($listeningQuestionsLength Questions)",
            questionsLength: listeningQuestionsLength,
            isListening: true,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionColumn({
    required BuildContext context,
    required String image,
    required String title,
    required int questionsLength,
    required bool isListening,
  }) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(image, height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 10),
            child: !dataFound
                ? const Center(child: CircularProgressIndicator())
                : questionsLength == 0
                ? const Center(child: Text("No Questions Available"))
                : _buildQuestionsGrid(questionsLength, isListening),
          ),
        ],
      ),
    );
  }

  GridView _buildQuestionsGrid(int questionCount, bool isListening) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      itemCount: questionCount,
      itemBuilder: (context, index) {
        bool isSelected = isQuestionSolved(index, isListening);

        return GestureDetector(
          onTap: () {
            updateSelectedQuestion(index, isListening);
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColor.skyBlue
                  : const Color.fromRGBO(245, 247, 250, 1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
  isListening ? '${readingQuestionsLength + index + 1}' : '${index + 1}',
  style: TextStyle(
    fontSize: 20,
    color: isSelected
        ? const Color.fromRGBO(245, 247, 250, 1)
        : AppColor.navyBlue,
    fontWeight:   FontWeight.w500 ,
  )
              ),
            ),
          ),
        );
      },
    );
  }
}
