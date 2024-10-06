import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:kpathshala/api/api_container.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/authentication/base_repository.dart';
import 'package:kpathshala/model/log_in_credentials.dart';
import 'package:kpathshala/repository/sign_in_methods.dart';
import 'package:kpathshala/view/login_signup_page/registration_and_login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Credit by Md. Arafat Mia Date 20/8/2024

class AuthService {
  static const String _tokenKey = 'authToken';

  // Save token to SharedPreferences
  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Retrieve token from SharedPreferences
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Remove token (for logout)
  Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // Check if token exists
  Future<bool> hasToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_tokenKey);
  }

  // // Send OTP
  // Future<Map<String, dynamic>> sendOtp(String mobile, {String? email}) async {
  //   final url = Uri.parse(AuthorizationEndpoints.sendOTP);
  //   final headers = {'Content-Type': 'application/json'};
  //   final body = {
  //     'mobile': mobile,
  //   };
  //   if (email != null) {
  //     body['email'] = email;
  //   }

  //   final response =
  //       await http.post(url, headers: headers, body: json.encode(body));
  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     return {
  //       'error': true,
  //       'message': 'Failed to send OTP',
  //       'details': json.decode(response.body)
  //     };
  //   }
  // }

  Future<Map<String, dynamic>> sendOtp(
    String mobile, {
    String? email,
    required BuildContext context,
  }) async {
    final body = {
      'mobile': mobile,
      if (email != null) 'email': email,
    };
    try {
      final response = await BaseRepository().postRequest(
        AuthorizationEndpoints.sendOTP,
        body,
        context: context,
      );
      if (response['error'] == null || !response['error']) {
        return response;
      } else {
        return {
          'error': true,
          'message': 'Failed to send OTP',
          'details': response
        };
      }
    } catch (e) {
      return {
        'error': true,
        'message': 'An error occurred',
        'details': e.toString(),
      };
    }
  }

  // // Verify OTP
  // Future<Map<String, dynamic>> verifyOtp(
  //     String mobile, int otp, String deviceId,
  //     {String? deviceName}) async {
  //   final url = Uri.parse(AuthorizationEndpoints.verifyOTP);
  //   final headers = {'Content-Type': 'application/json'};
  //   final body = {
  //     'mobile': mobile,
  //     'otp': otp,
  //     'device_id': deviceId,
  //   };

  //   if (deviceName != null) {
  //     body['device_name'] = deviceName;
  //   }

  //   final response =
  //       await http.post(url, headers: headers, body: json.encode(body));
  //   if (response.statusCode == 200) {
  //     var data = json.decode(response.body);
  //     // Save the token if verification is successful
  //     if (data['status'] == 'success' && data['data']['token'] != null) {
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       await prefs.setString('authToken', data['data']['token']);
  //     }
  //     return data;
  //   } else {
  //     return {
  //       'error': true,
  //       'message': 'OTP verification failed',
  //       'details': json.decode(response.body)
  //     };
  //   }
  // }


  

  // Register User
  Future<Map<String, dynamic>> registerUser({
    String? name,
    String? email,
    required String mobile,
    String? image,
    required String deviceId,
  }) async {
    try {
      final url = Uri.parse(AuthorizationEndpoints.registerUser);
      final headers = {'Content-Type': 'application/json'};
      final body = json.encode({
        'name': name,
        'email': email,
        'mobile': mobile,
        'image': image ?? '',
        'device_id': deviceId,
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 400) {
        throw Exception(
            'This email is already in use. Please try another email or log in.');
      } else {
        // You can customize the error message or throw an exception as needed
        log('Failed to register user: ${response.statusCode}');
        throw Exception(
            'Failed to register user: ${response.statusCode}, ${jsonEncode(response.body)}');
      }
    } catch (error) {
      log('Error registering user: $error');
      // throw Exception('Error registering user: $error');
      rethrow;
    }
  }
  // Register User

  Future<Map<String, dynamic>> userUpdate(
      {String? name, String? email, String? image}) async {
    final url = Uri.parse(AuthorizationEndpoints.userUpdate);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer $token', // Ensure the Authorization header is correctly prefixed
    };

    final body = jsonEncode({
      'name': name ?? '',
      'email': email ?? '',
      'image': image ?? '',
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
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
    } catch (e) {
      return {
        'error': true,
        'message': 'An error occurred',
        'details': e.toString(),
      };
    }
  }

// Helper function to check if a string is valid JSON
  bool _isJson(String str) {
    try {
      jsonDecode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> saveLogInCredentials(LogInCredentials credentials) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(credentials.toJson());
    await prefs.setString('login_credentials', jsonString);
  }

  Future<LogInCredentials?> getLogInCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('login_credentials');

    if (jsonString != null) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return LogInCredentials.fromJson(jsonMap);
    }

    return null;
  }

  Future<void> clearLogInCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('login_credentials');
  }

  Future<Map<String, dynamic>> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final LogInCredentials? loginCredentials = await getLogInCredentials();

    if (loginCredentials != null &&
        (loginCredentials.token == null || loginCredentials.token == "")) {
      // No token found, perhaps already logged out
      if (context.mounted) {
        _showSnackbar(context, 'No active session found.');
      }
      return {'status': 'error', 'message': 'No active session.'};
    }

    final url = Uri.parse(AuthorizationEndpoints.logOut);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${loginCredentials?.token}',
      },
    );

    if (response.statusCode == 200) {
      // Remove token from local storage on successful logout
      await prefs.remove('authToken');
      await clearLogInCredentials();
      if (SignInMethods.isUserSignedIn()) {
        await SignInMethods.logout();
      }
      if (context.mounted) {
        _showSnackbar(context, 'Logout successful');
      }
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      await prefs.remove('authToken');
      await clearLogInCredentials();
      if (context.mounted) {
        slideNavigationPushAndRemoveUntil(
            const RegistrationPage(title: "Registration Page"), context);
        _showSnackbar(context, 'Invalid or expired token.');
      }
      return jsonDecode(response.body);
    } else {
      if (context.mounted) {
        _showSnackbar(context, 'Logout failed. Please try again.');
      }
      return jsonDecode(response.body);
    }
  }

  Future<Map<String, dynamic>> logoutIfInvalidToken(
      BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final LogInCredentials? loginCredentials = await getLogInCredentials();

    if (loginCredentials != null &&
        (loginCredentials.token == null || loginCredentials.token == "")) {
      // No token found, perhaps already logged out
      if (context.mounted) {
        _showSnackbar(context, 'No active session found.');
      }
      return {'status': 'error', 'message': 'No active session.'};
    }

    await prefs.remove('authToken');
    await clearLogInCredentials();
    if (SignInMethods.isUserSignedIn()) {
      await SignInMethods.logout();
    }

    if (context.mounted) {
      slideNavigationPushAndRemoveUntil(
          const RegistrationPage(title: "Registration Page"), context);
    }
    return {'status': 'error', 'message': 'Log Out..'};
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  //  onPressed: () async {
  //   Map<String, dynamic> result = await AuthService().logout(context);
  //   if (result['status'] == 'success') {
  //     Navigator.pushReplacementNamed(context, '/login');  // Navigate to login or initial screen
  //   }
  // },
}
