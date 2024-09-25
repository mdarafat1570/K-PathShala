import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BaseRepository {
  static const String _tokenKey = 'authToken';

  // Perform HTTP POST request
  Future<Map<String, dynamic>> postRequest(String url, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    final uri = Uri.parse(url);
    final defaultHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await getToken()}',
    };
    headers = headers != null ? {...defaultHeaders, ...headers} : defaultHeaders;

    try {
      final response = await http.post(uri, headers: headers, body: jsonEncode(body));
      return _processResponse(response);
    } catch (e) {
      log('Error in POST request: $e');
      rethrow;
    }
  }

  // Perform HTTP GET request
  Future<Map<String, dynamic>> getRequest(String url, {Map<String, String>? headers}) async {
    final uri = Uri.parse(url);
    final defaultHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await getToken()}',
    };
    headers = headers != null ? {...defaultHeaders, ...headers} : defaultHeaders;

    try {
      final response = await http.get(uri, headers: headers);
      return _processResponse(response);
    } catch (e) {
      log('Error in GET request: $e');
      rethrow;
    }
  }

  // Process response
  Map<String, dynamic> _processResponse(http.Response response) {
    if (_isJson(response.body)) {
      final decodedBody = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decodedBody;
      } else {
        throw Exception('Error: ${response.statusCode}, ${response.body}');
      }
    } else {
      throw Exception('Non-JSON response: ${response.body}');
    }
  }

  // Check if response is JSON
  bool _isJson(String str) {
    try {
      jsonDecode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Token Management
  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<bool> hasToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_tokenKey);
  }
}
