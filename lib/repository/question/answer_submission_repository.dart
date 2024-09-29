import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kpathshala/api/api_container.dart';
import 'package:kpathshala/authentication/base_repository.dart';
import 'package:kpathshala/model/question_model/answer_model.dart';

class AnswerSubmissionRepository extends BaseRepository {
  Future<Map<String, dynamic>> submitAnswers({
    required AnswerModel answers,
    required BuildContext context,
  }) async {
 
    Map<String, dynamic> requestBody = answers.toJson();

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
