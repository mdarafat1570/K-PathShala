import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../api/json_response.dart';

 class BaseRepository {
  Future<http.Response> _sendRequest(
    String url,
    String method,
    Map<String, dynamic>? data, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(url);

      http.Response response;
      switch (method) {
        case 'POST':
          response = await http.post(
            uri,
            headers: headers,
            body: jsonEncode(data),
          );
          break;
        case 'GET':
        default:
          response = await http.get(
            uri,
            headers: headers,
          );
          break;
      }

      return response;
    } on SocketException catch (e) {
      log('SocketException: $e');
      throw Exception('Failed to connect to the server.');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to send request. $error');
    }
  }

  Future<T> fetchData<T>(
    String apiEndpoint,
    Map<String, dynamic>? data,
    dynamic Function(dynamic) parser, {
    bool isPost = false,
    bool isAdditionalHeaderRequired = true,
  }) async {
    try {
      // Add any additional headers if needed
      Map<String, String>? headers;
      if (isAdditionalHeaderRequired) {
        headers = {
          'Authorization': 'Bearer ${await _initializeToken()}',
          'Content-Type': 'application/json',
        };
      }

      final response = await _sendRequest(
        apiEndpoint,
        isPost ? 'POST' : 'GET',
        data,
        headers: headers,
      );

      final jsonResponse = JsonResponse.fromJson(response);

      if (response.statusCode == 200) {
        log('${jsonResponse.getMessage} from $apiEndpoint');
        log(jsonResponse.data);
        final responseData = jsonResponse.getData;

        return parser(responseData);
      } else if (response.statusCode == 403) {
        dynamic responseData = jsonResponse;
        return responseData as T;
      } else {
        _handleHttpError(response);
      }
    } on SocketException catch (e) {
      log('SocketException: $e');
      throw Exception('Failed to connect to the server.');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to fetch data. $error');
    }

    // Ensure that a return value or an exception is always provided
    throw Exception('Unexpected state reached in fetchData method.');
  }

  Future<String> _initializeToken() async {
    // Implement token initialization logic if needed
    return 'your-token';
  }

  void _handleHttpError(http.Response response) {
    final statusCode = response.statusCode;

    if (statusCode == 401) {
      log('Authentication error');
      throw Exception('Failed to fetch data. HTTP Status Code $statusCode');
    } else if (statusCode == 400) {
      log('Bad request');
      throw Exception('Failed to fetch data. HTTP Status Code $statusCode');
    } else if (statusCode == 404) {
      log('Resource not found');
      throw Exception('Failed to fetch data. HTTP Status Code $statusCode');
    } else if (statusCode == 408) {
      log('Request timeout');
      throw Exception('Failed to fetch data. HTTP Status Code $statusCode');
    } else if (statusCode == 502) {
      log('Bad gateway');
      throw Exception('Failed to fetch data. HTTP Status Code $statusCode');
    } else {
      log('Error: HTTP Status Code $statusCode');
      throw Exception('Failed to fetch data. HTTP Status Code $statusCode');
    }
  }
}
