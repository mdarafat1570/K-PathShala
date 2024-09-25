import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:kpathshala/model/question_model/reading_question_page_model.dart';
import 'package:kpathshala/repository/question/reading_questions_repository.dart';

class ReadingQuestionsPage extends StatefulWidget {
  const ReadingQuestionsPage({Key? key}) : super(key: key);

  @override
  _ReadingQuestionsPageState createState() => _ReadingQuestionsPageState();
}

class _ReadingQuestionsPageState extends State<ReadingQuestionsPage> {
  List<ReadingQuestions>? _readingQuestions = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    fetchReadingQuestions();
  }

  Future<void> fetchReadingQuestions() async {
    try {
      final repository = ReadingQuestionsRepository();
      final questionData = await repository.fetchReadingQuestions(3);

      setState(() {
        // _readingQuestions = questionData?.data?.readingQuestions;

        log(jsonEncode(_readingQuestions));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text('Error: $_errorMessage'))
              : _readingQuestions != null && _readingQuestions!.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                        ),
                        itemCount: _readingQuestions!.length,
                        itemBuilder: (context, index) {
                          final question = _readingQuestions![index];
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const Center(child: Text('No questions available')),
    );
  }
}
