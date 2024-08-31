import 'package:http/http.dart' as http;
import 'dart:convert';

class JsonResponse {
  final bool isSucceeded;
  final dynamic data;
  final String message;
  final List<String>? apiMessages;
  final dynamic errors;
  final int? statusCode;
  final bool? isContainPermission;

  JsonResponse({
    required this.isSucceeded,
    required this.data,
    required this.message,
    required this.apiMessages,
    required this.errors,
    required this.statusCode,
    this.isContainPermission,
  });

  factory JsonResponse.fromJson(http.Response response) {
    final Map<String, dynamic> json = jsonDecode(response.body);
    return JsonResponse(
      isSucceeded: json['succeeded'] ?? false,
      data: json['data'] ?? {},
      message: json['message'] ?? '',
      apiMessages: (json['apiMessages'] as List<dynamic>?)?.cast<String>(),
      errors: json['errors'],
      statusCode: response.statusCode,
      isContainPermission: false,
    );
  }

  // Getters
  bool get getSucceeded => isSucceeded;
  dynamic get getData => data;
  String get getMessage => message;
  List<String>? get getApiMessages => apiMessages;
  dynamic get getErrors => errors;
}
