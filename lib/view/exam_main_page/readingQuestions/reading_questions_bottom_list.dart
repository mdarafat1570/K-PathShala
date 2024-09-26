import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:kpathshala/model/question_model/reading_question_page_model.dart';
import 'package:kpathshala/repository/question/reading_questions_repository.dart';

import 'reading_questions_list.dart'; // Import your widget

class ReadingQuestionsPage extends StatefulWidget {
  final int questionSetId;

  const ReadingQuestionsPage({Key? key, required this.questionSetId})
      : super(key: key);

  @override
  _ReadingQuestionsPageState createState() => _ReadingQuestionsPageState();
}

class _ReadingQuestionsPageState extends State<ReadingQuestionsPage> {
  final ReadingQuestionsRepository _repository = ReadingQuestionsRepository();
  List<ReadingQuestions> _readingQuestions = [];

  @override
  void initState() {
    super.initState();
    _fetchReadingQuestions();
  }

  Future<void> _fetchReadingQuestions() async {
    QuestionsModel? questionsModel =
        await _repository.fetchReadingQuestions(widget.questionSetId);
    if (questionsModel != null && questionsModel.data != null) {
      setState(() {
        _readingQuestions = questionsModel.data!.readingQuestions ?? [];
        log(jsonEncode(_readingQuestions));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading Questions'),
      ),
      body: Text(_readingQuestions.length.toString()),
      // body: _readingQuestions.isNotEmpty
      //     ? ReadingQuestionsList(readingQuestions: _readingQuestions)
      //     : const Center(
      //         child: CircularProgressIndicator()), // Show loading indicator
    );
  }
}
