import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kpathshala/api/api_container.dart';

class AuthService {
  
  // Send OTP
  Future<Map<String, dynamic>> sendOtp(String mobile, {String? email}) async {
    final url = Uri.parse(AuthorizationEndpoints.sendOTP);
    final headers = {'Content-Type': 'application/json'};
    final body = {
      'mobile': mobile,
    };
    if (email != null) {
      body['email'] = email;
    }

    final response = await http.post(url, headers: headers, body: json.encode(body));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {
        'error': true,
        'message': 'Failed to send OTP',
        'details': json.decode(response.body)
      };
    }
  }

  // Verify OTP
  Future<Map<String, dynamic>> verifyOtp(String mobile, int otp, String deviceId, {String? deviceName}) async {
    final url = Uri.parse(AuthorizationEndpoints.verifyOTP);
    final headers = {'Content-Type': 'application/json'};
    final body = {
      'mobile': mobile,
      'otp': otp,
      'device_id': deviceId,
    };
    if (deviceName != null) {
      body['device_name'] = deviceName;
    }

    final response = await http.post(url, headers: headers, body: json.encode(body));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {
        'error': true,
        'message': 'OTP verification failed',
        'details': json.decode(response.body)
      };
    }
  }

  // Register User
  Future<Map<String, dynamic>> registerUser({String? name, String? email,required String mobile, String? image,required String deviceId}) async {
    final url = Uri.parse(AuthorizationEndpoints.registerUser);
    final headers = {'Content-Type': 'application/json'};
    final body = {
      'name': name,
      'email': email,
      'mobile': mobile,
      'image': image ?? '',
      'device_id': deviceId,
    };

    final response = await http.post(url, headers: headers, body: json.encode(body));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {
        'error': true,
        'message': 'Registration failed',
        'details': json.decode(response.body)
      };
    }
  }
  // Register User
  Future<Map<String, dynamic>> userUpdate({String? name, String? email, String? image}) async {
    final url = Uri.parse(AuthorizationEndpoints.userUpdate);
    final headers = {'Content-Type': 'application/json'};
    final body = {
      'name': name ?? '',
      'email': email ?? '',
      'image': image ?? '',
    };

    final response = await http.post(url, headers: headers, body: json.encode(body));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {
        'error': true,
        'message': 'Registration failed',
        'details': json.decode(response.body)
      };
    }
  }
}
