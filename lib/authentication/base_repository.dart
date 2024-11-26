import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:kpathshala/common_error_all_layout/connection_lost.dart';
import 'package:kpathshala/repository/authentication_repository.dart';
import 'package:kpathshala/view/login_signup_page/registration_and_login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kpathshala/view/common_widget/common_loading_indicator.dart';

class BaseRepository {
  static const String _tokenKey = 'authToken';
  final AuthService _authService = AuthService();

//* Credit by Mohammad Arafat *//
//Date : 11-27-2024

  Future<bool> _hasInternetConnection(BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ConnectionLost()),
      );
      return false;
    }
    return true;
  }

  // Show a Snackbar for No Internet Connection
  void _showNoInternetSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No Internet Connection'),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  // Perform HTTP POST request
  Future<Map<String, dynamic>> postRequest(
      String url, Map<String, dynamic> body,
      {Map<String, String>? headers, required BuildContext context}) async {
    if (!await _hasInternetConnection(context)) return {};

    final uri = Uri.parse(url);
    final defaultHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await getToken()}',
    };
    headers =
        headers != null ? {...defaultHeaders, ...headers} : defaultHeaders;

    try {
      final response =
          await http.post(uri, headers: headers, body: jsonEncode(body));
      return _processResponse(response, context);
    } catch (e) {
      log('Error in POST request: $e');
      rethrow;
    }
  }

  // Perform HTTP GET request
  Future<Map<String, dynamic>> getRequest(String url,
      {Map<String, String>? headers, required BuildContext context}) async {
    if (!await _hasInternetConnection(context)) return {};

    final uri = Uri.parse(url);
    final defaultHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await getToken()}',
    };
    headers =
        headers != null ? {...defaultHeaders, ...headers} : defaultHeaders;

    try {
      final response = await http.get(uri, headers: headers);
      return _processResponse(response, context);
    } catch (e) {
      log('Error in GET request: $e');
      rethrow;
    }
  }

  // Perform HTTP PUT request
  Future<Map<String, dynamic>> putRequest(String url, Map<String, dynamic> body,
      {Map<String, String>? headers, required BuildContext context}) async {
    if (!await _hasInternetConnection(context)) return {};

    final uri = Uri.parse(url);
    final defaultHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await getToken()}',
    };
    headers =
        headers != null ? {...defaultHeaders, ...headers} : defaultHeaders;

    try {
      final response =
          await http.put(uri, headers: headers, body: jsonEncode(body));
      return _processResponse(response, context);
    } catch (e) {
      log('Error in PUT request: $e');
      rethrow;
    }
  }

  // Perform HTTP DELETE request
  Future<Map<String, dynamic>> deleteRequest(String url,
      {Map<String, String>? headers, required BuildContext context}) async {
    if (!await _hasInternetConnection(context)) return {};

    final uri = Uri.parse(url);
    final defaultHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await getToken()}',
    };
    headers =
        headers != null ? {...defaultHeaders, ...headers} : defaultHeaders;

    try {
      final response = await http.delete(uri, headers: headers);
      return _processResponse(response, context);
    } catch (e) {
      log('Error in DELETE request: $e');
      rethrow;
    }
  }

  // Process response and handle 401 errors
  Map<String, dynamic> _processResponse(
      http.Response response, BuildContext context) {
    if (_isJson(response.body)) {
      final decodedBody = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decodedBody;
      } else if (response.statusCode == 401) {
        log("Token Expired");
        showSessionExpiredDialog(context);
        return {};
      } else {
        throw Exception(decodedBody["message"]);
      }
    } else {
      throw Exception(response.body);
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

  // Show session expired dialog
  Future<void> showSessionExpiredDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Session Expired'),
          content: const Text('Your session has expired. Please log in again.'),
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

  void userSignOut(BuildContext context) async {
    log("Calling userSignOut");
    showLoadingIndicator(context: context, showLoader: true);
    try {
      final response = await _authService.logoutIfInvalidToken(context);

      if (response['error'] == null || !response['error']) {
        showLoadingIndicator(context: context, showLoader: false);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const RegistrationPage(title: "Registration Page")),
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

  // Token management methods
  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
}
