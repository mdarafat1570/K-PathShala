import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kpathshala/api/api_container.dart';
import 'package:kpathshala/repository/authentication_repository.dart';
import '../../model/dashboard_page_model/dashboard_page_model.dart';

class DashboardRepository {
  final AuthService _authService = AuthService();

  // Fetch Dashboard Data
  Future<List<DashboardPageModel>?> fetchDashboardData() async {
    final url = Uri.parse(KpatshalaDashboardPage.dashboard);
    final token = await _authService.getToken();  // Get auth token

    if (token == null) {
      throw Exception('Token not found, please log in again.');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',  // Add token to header
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          // Parse each item in the list and return a list of models
          return data.map<DashboardPageModel>((item) =>
            DashboardPageModel.fromJson(item as Map<String, dynamic>)).toList();
        } else {
          throw Exception('Expected a list but got a ${data.runtimeType}');
        }
      } else if (response.statusCode == 401) {
        // Handle unauthorized error
        throw Exception('Unauthorized: Token expired or invalid.');
      } else {
        // Other types of status code errors
        throw Exception('Failed to load dashboard data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching dashboard data: ${e.toString()}');
    }
  }
}
