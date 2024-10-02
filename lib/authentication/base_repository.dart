import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kpathshala/repository/authentication_repository.dart';
import 'package:kpathshala/view/common_widget/common_loading_indicator.dart';
import 'package:kpathshala/view/login_signup_page/registration_and_login_page.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // For connectivity checking

class BaseRepository {
  static const String _tokenKey = 'authToken';

  // Check if there is internet connection
  Future<bool> _hasInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
    final AuthService _authService = AuthService();

  // Perform HTTP POST request
  Future<Map<String, dynamic>> postRequest(
      String url, Map<String, dynamic> body,
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
      final response = await http.post(uri, headers: headers, body: jsonEncode(body));
      return _processResponse(response, context); // Pass context to _processResponse
    } catch (e) {
      log('Error in POST request: $e');
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
      return _processResponse(response, context); // Pass context to _processResponse
    } catch (e) {
      log('Error in GET request: $e');
      rethrow;
    }
  }

  // Process response and handle 401 error
  Map<String, dynamic> _processResponse(http.Response response, BuildContext context) {
    if (_isJson(response.body)) {
      final decodedBody = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        log(decodedBody.toString());
        return decodedBody;
      } else if (response.statusCode == 401) {
        log("Token Expired");
        showSessionExpiredDialog(context); // Trigger session expiration dialog
        return {}; // Return empty map after dialog
      } else {
        throw Exception('Error: ${response.statusCode}, ${response.body}');
      }
    } else {
      throw Exception('Non-JSON response: ${response.body}');
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
