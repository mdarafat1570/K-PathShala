import 'package:http/http.dart' as http;
import 'package:kpathshala/api/api_container.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:developer'; // For logging
import 'package:flutter/material.dart'; // For UI feedback
import 'package:kpathshala/view/navigation_bar_page/navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfileRepository {
  final http.Client httpClient;

  UpdateProfileRepository({http.Client? client})
      : httpClient = client ?? http.Client();

  Future<Map<String, dynamic>> updateUser({
    required BuildContext context, // Ensure context is passed here
    required String name,
    required String email,
    File? imageFile,
    String? imageUrl,
  }) async {
    // Show loading indicator while updating
    _showLoadingIndicator(
        context: context, showLoader: true); // Pass context here

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';
    var url = Uri.parse(AuthorizationEndpoints.userUpdate);

    try {
      var request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['name'] = name
        ..fields['email'] = email;

      // Add file if provided
      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ));
      } else if (imageUrl != null && imageUrl.isNotEmpty) {
        request.fields['image_url'] = imageUrl;
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      log('Raw Response: $responseBody'); // Log the raw response for debugging

      final responseJson =
          _parseJson(responseBody); // Attempt to parse the response

      log('Parsed Response: $responseJson'); // Log the parsed response for debugging

      _showLoadingIndicator(
          context: context, showLoader: false); // Pass context here

      if (response.statusCode == 200) {
        if (responseJson['status'] == 'success') {
          // Navigate to the desired screen upon success
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => const Navigation()));
        } else {
          _showSnackBar(
              context, responseJson['message'] ?? "Something went wrong");
        }
      } else {
        _showSnackBar(
            context, "Failed to update profile: ${response.statusCode}");
      }

      return responseJson; // Return parsed response
    } catch (e) {
      log('Error parsing response: $e'); // Log error in case of failure
      _showLoadingIndicator(
          context: context, showLoader: false); // Pass context here
      _showSnackBar(context, "An error occurred while updating profile");
      return {
        'error': true,
        'message': 'Error during profile update',
      };
    }
  }

  // Helper to parse JSON and handle errors
  Map<String, dynamic> _parseJson(String responseBody) {
    try {
      return jsonDecode(responseBody);
    } catch (e) {
      log('Error parsing JSON: $e');
      return {
        'error': true,
        'message': 'Invalid JSON response from server',
      };
    }
  }

  // Helper method to show loading indicator
  void _showLoadingIndicator(
      {required BuildContext context, required bool showLoader}) {
    if (showLoader) {
      // Show a loading indicator (can be a dialog or any other widget)
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
    } else {
      Navigator.of(context, rootNavigator: true)
          .pop(); // Close the loading indicator
    }
  }

  // Helper method to show a snack bar
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
