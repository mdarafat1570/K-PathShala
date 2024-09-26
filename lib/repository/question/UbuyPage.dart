import 'package:flutter/material.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/model/question_model/reading_question_page_model.dart';
import '../../authentication/base_repository.dart';

class ExamScreen extends StatefulWidget {
  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  late Future<QuestionsModel> _questions;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _questions = fetchQuestions();
  }

  Future<QuestionsModel> fetchQuestions() async {
    var response = await BaseRepository().getRequest(
        'http://159.203.105.5:8012/api/v1/question?questionSetId=3');
    // Assuming the response returns a map that can be directly used by QuestionsModel.fromJson()
    return QuestionsModel.fromJson(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text('Exam'),
      ),
      body: FutureBuilder<QuestionsModel>(
        future: _questions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            return buildQuestionScreen(snapshot.data!);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget buildQuestionScreen(QuestionsModel data) {
    final question = data.data!.readingQuestions![_currentIndex];
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(question.question ??
                  "No question provided"), // Handle null question
              ...question.options!.map(buildOption).toList(),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: _currentIndex > 0
                  ? () => setState(() => _currentIndex--)
                  : null,
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: _currentIndex < data.data!.readingQuestions!.length - 1
                  ? () => setState(() => _currentIndex++)
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildOption(Options option) {
    return ListTile(
      title: Text(option.title ?? "No title"), // Handle null title
      leading: Radio(
        value: option.id,
        groupValue: 'selectedOption',
        onChanged: (value) {
          setState(() {
            // handle option select
          });
        },
      ),
    );
  }
}
