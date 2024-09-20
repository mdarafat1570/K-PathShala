import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:kpathshala/api/api_container.dart';
import 'package:kpathshala/model/question_model/question_set_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionSetRepository {
  static const String _tokenKey = 'authToken';

  // Fetch question sets for a specific package
  Future<QuestionSetData> fetchQuestionSets({required int packageId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    if (token == null) {
      throw Exception('No authentication token found.');
    }

    final url =
        Uri.parse('${KpatshalaquestionSet.questionSet}?package_id=$packageId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final questionSetModel = QuestionSetModel.fromJson(jsonResponse);
      log(jsonEncode(questionSetModel));
      return questionSetModel.data!;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid or missing Bearer Token.');
    } else if (response.statusCode == 404) {
      throw Exception('Not Found: The specified package ID does not exist.');
    } else {
      throw Exception(
          'Server Error: An error occurred while processing the request.');
    }
  }
}
