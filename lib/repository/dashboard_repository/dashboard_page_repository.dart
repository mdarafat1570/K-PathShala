
import 'package:flutter/material.dart';
import 'package:kpathshala/api/api_container.dart';
import 'package:kpathshala/authentication/base_repository.dart';
import '../../model/dashboard_page_model/dashboard_page_model.dart';

class DashboardRepository {
  final BaseRepository _baseRepository =
      BaseRepository(); // Instantiate BaseRepository

  // Fetch Dashboard Data
  Future<DashboardPageModel?> fetchDashboardData( BuildContext context) async {
    final url = KpatshalaDashboardPage.dashboard; // URL endpoint

    try {
      final response = await _baseRepository
          .getRequest(url,context: context); // Use BaseRepository's getRequest
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
