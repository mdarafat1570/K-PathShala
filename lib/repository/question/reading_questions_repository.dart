import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:kpathshala/api/api_container.dart';
import 'package:kpathshala/authentication/base_repository.dart';
import 'package:kpathshala/model/question_model/text_to_speech_request_model.dart';
import 'package:kpathshala/view/exam_main_page/quiz_attempt_page/quiz_attempt_page_imports.dart';

class QuestionsRepository {
  final BaseRepository _baseRepository = BaseRepository();

  Future<QuestionsModel?> fetchReadingQuestions(int questionSetId,BuildContext context) async {
    try {
      String url = '${KpatshalaQuestionPage.readingQuestion}?questionSetId=$questionSetId';

      // Make the GET request using the BaseRepository's getRequest method
      Map<String, dynamic> response = await _baseRepository.getRequest(url ,context:context );

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


  Future<Uint8List?> fetchTextToSpeech(TextToSpeechRequestModel textToSpeechRequestModel) async {
    try {
      String url = "https://dev.kpathshala.com/api/v1/text-to-speech";

      // Convert the request model to JSON
      final body = jsonEncode(textToSpeechRequestModel.toJson());

      // Define headers
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await _baseRepository.getToken()}',
      };

      // Make the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        log('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      log('Error in fetchTextToSpeech: $e');
      return null;
    }
  }



// Future<QuestionsModel> fetchQuestions() async {
  //   var response = await BaseRepository().getRequest(
  //       'http://159.203.105.5:8012/api/v1/question?questionSetId=3');
  //   // Assuming the response returns a map that can be directly used by QuestionsModel.fromJson()
  //   return QuestionsModel.fromJson(response);
  // }
}
