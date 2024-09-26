import 'dart:developer';
import 'package:kpathshala/api/api_container.dart';
import 'package:kpathshala/authentication/base_repository.dart';
import 'package:kpathshala/model/question_model/reading_question_page_model.dart';

class ReadingQuestionsRepository {
  final BaseRepository _baseRepository = BaseRepository();

  Future<QuestionsModel?> fetchReadingQuestions(int questionSetId) async {
    try {
      String url =
          '${KpatshalaQuestionPage.readingQuestion}?questionSetId=$questionSetId';

      // Make the GET request using the BaseRepository's getRequest method
      Map<String, dynamic> response = await _baseRepository.getRequest(url);

      if (response.containsKey('data')) {
        return QuestionsModel.fromJson(response);
      } else {
        log('No data found in the response');
        return null;
      }
    } catch (e) {
      log('Error fetching reading questions: $e');
      return null;
    }
  }

  Future<QuestionsModel> fetchQuestions() async {
    var response = await BaseRepository().getRequest(
        'http://159.203.105.5:8012/api/v1/question?questionSetId=3');
    // Assuming the response returns a map that can be directly used by QuestionsModel.fromJson()
    return QuestionsModel.fromJson(response);
  }
}
