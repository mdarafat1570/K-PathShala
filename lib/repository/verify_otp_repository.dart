import 'dart:developer';

import 'package:kpathshala/api/api_container.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/authentication/base_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AuthenticationService extends BaseRepository {
  
  /// Public method to fetch the app version from `pubspec.yaml`.
  Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version; 
  }

  Future<Map<String, dynamic>> verifyOtp(
    String mobile,
    int otp,
    String deviceId, {
    String? deviceName,
    required String oneSignalPlayerId,
    required BuildContext context,
    required double appVersion,
  }) async {
    const url = AuthorizationEndpoints.verifyOTP;

    final body = {
      'mobile': mobile,
      'otp': otp,
      'device_id': deviceId,
      'one_signal_player_id': oneSignalPlayerId,
      'app_version': appVersion,
    };
    if (deviceName != null) {
      body['device_name'] = deviceName;
    }

    try {
      final response = await postRequest(url, body, context: context);

      if (response['status'] == 'success') {
        final token = response['data']['token'];
        if (token != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('authToken', token);
        }
      }
      return response;
    } catch (e) {
      log("Error during OTP verification: $e");
      rethrow;
    }
  }
}
