import 'dart:developer';
import 'package:kpathshala/api/api_container.dart';
import 'package:kpathshala/authentication/base_repository.dart';
import 'package:kpathshala/model/question_model/reading_question_page_model.dart';
class ReadingQuestionsRepository {
  final BaseRepository _baseRepository = BaseRepository();

  Future<ReadingQuestions?> fetchReadingQuestions(int questionSetId) async {
    try {
      // Construct the full API URL with the query parameter
      String url =
          '${KpatshalaQuestionPage.readingQuestion}?questionSetId=$questionSetId';

      // Make the GET request using the BaseRepository's getRequest method
      Map<String, dynamic> response = await _baseRepository.getRequest(url);

      if (response.containsKey('data')) {
        return ReadingQuestions.fromJson(response);
      } else {
        log('No data found in the response');
        return null;
      }
    } catch (e) {
      log('Error fetching reading questions: $e');
      return null;
    }
  }
}
