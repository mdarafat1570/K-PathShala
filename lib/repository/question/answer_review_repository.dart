import 'dart:convert';
import 'dart:developer';
import 'package:kpathshala/api/api_container.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/authentication/base_repository.dart';
import 'package:kpathshala/model/question_model/result_model.dart';

class AnswerReviewRepository {
  final BaseRepository _baseRepository = BaseRepository();
  Future<ResultData> fetchResults(
      {required int questionSetId, required BuildContext context}) async {
    try {
      final url = '${KpatshalaAnswerReview.result}?questionSetId=$questionSetId';
      final response = await _baseRepository.getRequest(url, context: context);
      final resultDataModel = ExamResult.fromJson(response);
      log(jsonEncode(resultDataModel));
      return resultDataModel.data!;
    } catch (e) {
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
