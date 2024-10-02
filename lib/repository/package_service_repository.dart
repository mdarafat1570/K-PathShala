import 'package:flutter/material.dart';
import 'package:kpathshala/authentication/base_repository.dart';
import 'package:kpathshala/model/package_model/package_model.dart';
import 'package:kpathshala/api/api_container.dart';

class PackageRepository {
  final BaseRepository _baseRepository = BaseRepository();

  Future<PackageModel> fetchPackages( BuildContext context) async {
    try {
      final response =
          await _baseRepository.getRequest(KpatshalaPackage.packages,context:context );
      return PackageModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load packages: $e');
    }
  }
}


// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:kpathshala/model/package_model/package_model.dart';
// import 'package:kpathshala/api/api_container.dart'; // Import the API container for URLs
// import 'package:kpathshala/repository/authentication_repository.dart';

// class PackageRepository {
//   final AuthService _authService = AuthService(); // Get token from AuthService

//   Future<PackageModel> fetchPackages() async {
//     final token = await _authService.getToken(); // Retrieve the token from AuthService
//     if (token == null) {
//       throw Exception('Authentication token is missing.');
//     }

//     final headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $token',  // Add Bearer token in the headers
//     };

//     final url = Uri.parse(KpatshalaPackage.packages);  // Endpoint URL for packages

//     final response = await http.get(url, headers: headers);
//     if (response.statusCode == 200) {
//       return PackageModel.fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Failed to load packages');
//     }
//   }
// }

