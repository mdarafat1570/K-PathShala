import 'package:http/http.dart' as http;
import 'package:kpathshala/api/api_container.dart';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfileRepository {
  final http.Client httpClient;

  UpdateProfileRepository({http.Client? client})
      : httpClient = client ?? http.Client();

  Future<Map<String, dynamic>> updateUser({
    String? name,
    String? email,
    String? imageUrl,
    File? imageFile,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';
    var url = Uri.parse(AuthorizationEndpoints.userUpdate);

    if (imageFile != null) {
      // Use MultipartRequest for file uploads
      var request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['name'] = name ?? ''
        ..fields['email'] = email ?? '';

      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ));

      var streamedResponse = await request.send();

      return _handleResponse(streamedResponse);
    } else {
      // Use normal POST for JSON data if no file is involved
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = jsonEncode({
        'name': name ?? '',
        'email': email ?? '',
        'image': imageUrl ?? '',
      });

      final response = await httpClient.post(url, headers: headers, body: body);

      if (_isJson(response.body)) {
        final decodedBody = jsonDecode(response.body);
        if (response.statusCode == 200) {
          return decodedBody;
        } else {
          return {
            'error': true,
            'message': 'Update failed',
            'details': decodedBody,
          };
        }
      } else {
        return {
          'error': true,
          'message': 'Non-JSON response from server',
          'details': response.body,
        };
      }
    }
  }

  Future<Map<String, dynamic>> _handleResponse(http.StreamedResponse response) async {
    var responseBody = await http.Response.fromStream(response);
    if (response.statusCode == 200) {
      return json.decode(responseBody.body);
    } else {
      return {
        'error': true,
        'message': 'Failed to update profile',
        'details': jsonDecode(responseBody.body),
      };
    }
  }

  bool _isJson(String str) {
    try {
      jsonDecode(str);
      return true;
    } catch (_) {
      return false;
    }
  }
}
