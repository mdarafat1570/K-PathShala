import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://5.104.86.3:8010/api/v1';

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    headers ??= {'Content-Type': 'application/json'};
    final response = await http.post(url, headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to post data: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    headers ??= {'Content-Type': 'application/json'};
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get data: ${response.body}');
    }
  }
}
