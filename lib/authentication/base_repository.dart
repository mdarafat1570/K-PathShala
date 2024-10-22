import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kpathshala/repository/authentication_repository.dart';
import 'package:kpathshala/view/common_widget/common_loading_indicator.dart';
import 'package:kpathshala/view/login_signup_page/registration_and_login_page.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; 

class BaseRepository {
  static const String _tokenKey = 'authToken';


  Future<bool> _hasInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
    final AuthService _authService = AuthService();

Future<Map<String, dynamic>> postRequest(
    String url, Map<String, dynamic> body,
    {Map<String, String>? headers, required BuildContext context}) async {
  if (!await _hasInternetConnection()) {
    _showSnackbar(context, 'No Internet Connection'); 
    throw Exception('No Internet Connection');
  }

  final uri = Uri.parse(url);
  final defaultHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${await getToken()}',
  };
  headers = headers != null ? {...defaultHeaders, ...headers} : defaultHeaders;

  try {
    log('POST Request URL: $url');
    log('Request Headers: ${jsonEncode(headers)}');
    log('Request Body: ${jsonEncode(body)}');
    final response = await http.post(uri, headers: headers, body: jsonEncode(body));
    return _processResponse(response, context);
  } catch (e) {
    log('Error in POST request: $e');
    _showSnackbar(context, 'An unexpected error occurred. Please try again.');
    rethrow; 
  }
}

  // Perform HTTP GET request
  Future<Map<String, dynamic>> getRequest(String url,
      {Map<String, String>? headers, required BuildContext context}) async {
    if (!await _hasInternetConnection()) {
      throw Exception('No Internet Connection');
    }

    final uri = Uri.parse(url);
    final defaultHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await getToken()}',
    };
    headers = headers != null ? {...defaultHeaders, ...headers} : defaultHeaders;

    try {
      final response = await http.get(uri, headers: headers);
      log("Data Found From $url");
      return _processResponse(response, context);
    } catch (e) {
      log('Error in GET request: $e');
      rethrow;
    }
  }

// Process the HTTP response and handle different status codes
Map<String, dynamic> _processResponse(http.Response response, BuildContext context) {
  log('Response Status: ${response.statusCode}');
  log('Response Body: ${response.body}');

  try {
    final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {

      return decodedResponse;
    } else {

      String message = decodedResponse['message'] ?? 'Something went wrong';
      if (response.statusCode == 400) {
        message = 'Bad request: $message';
      } else if (response.statusCode == 401) {
        message = 'Unauthorized. Please log in again.';
      } else if (response.statusCode == 500) {
        message = 'Server error. Please try again later.';
      }
      _showSnackbar(context, message);
      throw Exception('Error: ${response.statusCode}, $message');
    }
  } catch (e) {
    log('Failed to parse response: $e');
    _showSnackbar(context, 'Failed to process the response. Please try again.');
    throw Exception('Response parsing error');
  }
}

void _showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

  // Perform HTTP PUT request
Future<Map<String, dynamic>> putRequest(String url, Map<String, dynamic> body,
    {Map<String, String>? headers, required BuildContext context}) async {
  if (!await _hasInternetConnection()) {
    throw Exception('No Internet Connection');
  }

  final uri = Uri.parse(url);
  final defaultHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${await getToken()}',
  };
  headers = headers != null ? {...defaultHeaders, ...headers} : defaultHeaders;

  try {
    final response = await http.put(uri, headers: headers, body: jsonEncode(body));
    return _processResponse(response, context); // Pass context to _processResponse
  } catch (e) {
    log('Error in PUT request: $e');
    rethrow;
  }
}

// Perform HTTP DELETE request
Future<Map<String, dynamic>> deleteRequest(String url,
    {Map<String, String>? headers, required BuildContext context}) async {
  if (!await _hasInternetConnection()) {
    throw Exception('No Internet Connection');
  }

  final uri = Uri.parse(url);
  final defaultHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${await getToken()}',
  };
  headers = headers != null ? {...defaultHeaders, ...headers} : defaultHeaders;

  try {
    final response = await http.delete(uri, headers: headers);
    return _processResponse(response, context); // Pass context to _processResponse
  } catch (e) {
    log('Error in DELETE request: $e');
    rethrow;
  }
}



  bool _isJson(String str) {
    try {
      jsonDecode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

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

  void userSignOut(BuildContext context) async {
    log("Calling userSignOut");
    showLoadingIndicator(context: context, showLoader: true);
    try {
      final response = await _authService.logoutIfInvalidToken(context);

      if (response['error'] == null || !response['error']) {
        showLoadingIndicator(context: context, showLoader: false);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const RegistrationPage(title: "Registration Page")),
          (route) => false,
        );
      } else {
        throw Exception("${response["message"]}");
      }
    } catch (e) {
      showLoadingIndicator(context: context, showLoader: false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred during sign-out: $e")),
      );
    }
  }

  // Show session expired dialog
Future<void> showSessionExpiredDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Session Expired'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('assets/unauth_error.json'),
            const SizedBox(height: 16),
            const Text('Your session has expired. Please log in again.'),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              log("pressed ok--------");
              Navigator.of(context).pop();
              userSignOut(context); 
            },
          ),
        ],
      );
    },
  );
}
}
