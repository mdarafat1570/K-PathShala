import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kpathshala/api/api_container.dart';
import 'package:kpathshala/authentication/base_repository.dart';

class AnswerSubmissionRepository extends BaseRepository {
  Future<Map<String, dynamic>> submitAnswers({
    required int questionSetId,
    required int duration,
    required List<Map<String, dynamic>> answers,
    required BuildContext context,
  }) async {
 
    Map<String, dynamic> requestBody = {
      'question_set_id': questionSetId,
      'duration': duration,
      'answers': answers,
    };

    try {
      final response = await postRequest(
        KpatshalaAnswerSubmission.answerSubmission,
        requestBody,
        context: context,
      );

      log("Answer Submission Response: $response");

      return response;
    } catch (e) {
      log('Error during answer submission: $e');
      throw Exception('Answer submission failed.');
    }
  }
}
