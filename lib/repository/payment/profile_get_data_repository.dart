import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kpathshala/model/profile_model/profile_get_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kpathshala/api/api_container.dart';
// Import your Profile Model

class ProfileRepository {
  static const String _tokenKey = 'authToken';

  // Fetch profile data
  Future<ProfileGetDataModel?> fetchProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    if (token == null) {
      return null; // No token available
    }

    final url = Uri.parse(KpatshalaProfaile.profileData);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'success') {
        return ProfileGetDataModel.fromJson(jsonResponse['data']);
      } else {
        return null; // Handle non-success status
      }
    } else {
      return null; // Handle error responses
    }
  }
}
