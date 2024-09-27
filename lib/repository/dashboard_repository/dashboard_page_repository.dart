
import 'package:kpathshala/api/api_container.dart';
import 'package:kpathshala/authentication/base_repository.dart';
import '../../model/dashboard_page_model/dashboard_page_model.dart';

class DashboardRepository {
  final BaseRepository _baseRepository =
      BaseRepository(); // Instantiate BaseRepository

  // Fetch Dashboard Data
  Future<DashboardPageModel?> fetchDashboardData() async {
    final url = KpatshalaDashboardPage.dashboard; // URL endpoint

    try {
      final response = await _baseRepository
          .getRequest(url); // Use BaseRepository's getRequest
      return DashboardPageModel.fromJson(
          response['data']); // Directly return parsed JSON
    } catch (e) {
      if (e.toString().contains('401')) {
        // Handle unauthorized error
        throw Exception('Unauthorized: Token expired or invalid.');
      } else {
        // Other types of errors
        throw Exception('Error fetching dashboard data: ${e.toString()}');
      }
    }
  }
}
// import 'dart:convert';
// import 'dart:developer';
// import 'package:http/http.dart' as http;
// import 'package:kpathshala/api/api_container.dart';
// import 'package:kpathshala/repository/authentication_repository.dart';
// import '../../model/dashboard_page_model/dashboard_page_model.dart';

// class DashboardRepository {
//   final AuthService _authService = AuthService();

//   // Fetch Dashboard Data
//   Future<DashboardPageModel?> fetchDashboardData() async {
//     final url = Uri.parse(KpatshalaDashboardPage.dashboard);
//     final token = await _authService.getToken(); // Get auth token

//     if (token == null) {
//       throw Exception('Token not found, please log in again.');
//     }

//     final headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $token', // Add token to header
//     };

//     try {
//       final response = await http.get(url, headers: headers);

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         log(jsonEncode(data));
//         if (data is Map<String, dynamic>) {
//           return DashboardPageModel.fromJson(data['data']);
//         } else {
//           throw Exception('Unexpected response format.');
//         }
//       } else if (response.statusCode == 401) {
//         // Handle unauthorized error
//         throw Exception('Unauthorized: Token expired or invalid.');
//       } else {
//         // Other types of status code errors
//         throw Exception(
//             'Failed to load dashboard data. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error fetching dashboard data: ${e.toString()}');
//     }
//   }
// }

