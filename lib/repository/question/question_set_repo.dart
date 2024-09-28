import 'package:flutter/material.dart';
import 'package:kpathshala/api/api_container.dart';
import 'package:kpathshala/authentication/base_repository.dart';
import 'package:kpathshala/model/question_model/question_set_model.dart';

class QuestionSetRepository {
  final BaseRepository _baseRepository =
      BaseRepository(); // Utilize BaseRepository

  // Fetch question sets for a specific package
  Future<QuestionSetData> fetchQuestionSets({required int packageId,required BuildContext context}) async {
    try {
      // Build the request URL with package ID
      final url = '${KpatshalaquestionSet.questionSet}?package_id=$packageId';

      // Perform the GET request using BaseRepository
      final response = await _baseRepository.getRequest(url ,context: context);

      // Parse the JSON response and log the result
      final questionSetModel = QuestionSetModel.fromJson(response);

      // Return the data from the question set model
      return questionSetModel.data!;
    } catch (e) {
      // Handle specific HTTP errors
      if (e.toString().contains('401')) {
        throw Exception('Unauthorized: Invalid or missing Bearer Token.');
      } else if (e.toString().contains('404')) {
        throw Exception('Not Found: The specified package ID does not exist.');
      } else {
        throw Exception(
            'Server Error: An error occurred while processing the request.');
      }
    }
  }
}
