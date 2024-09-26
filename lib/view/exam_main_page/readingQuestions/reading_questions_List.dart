import 'package:flutter/material.dart';
import 'package:kpathshala/model/question_model/reading_question_page_model.dart';

class ReadingQuestionsList extends StatelessWidget {
  final List<ReadingQuestions> readingQuestions;

  const ReadingQuestionsList({Key? key, required this.readingQuestions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: readingQuestions.length,
      itemBuilder: (context, index) {
        final question = readingQuestions[index];

        return Container(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${index + 1}. ${question.question ?? 'No Question'}', 
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
