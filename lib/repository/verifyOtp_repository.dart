import 'package:kpathshala/api/api_container.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/authentication/base_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService extends BaseRepository {
  // Verify OTP
  Future<Map<String, dynamic>> verifyOtp(
    String mobile,
    int otp,
    String deviceId, {
    String? deviceName,
    required String oneSignalPlayerId, // Now required
    required BuildContext context,
  }) async {
    final url = AuthorizationEndpoints.verifyOTP;

    // Build the request body
    final body = {
      'mobile': mobile,
      'otp': otp,
      'device_id': deviceId,
      'one_signal_player_id': oneSignalPlayerId, // Added here
    };

    // Conditionally add the device name if provided
    if (deviceName != null) {
      body['device_name'] = deviceName;
    }

    // Use the postRequest method from BaseRepository
    final response = await postRequest(url, body, context: context);

    // Check response for success and store the token if applicable
    if (response['status'] == 'success' && response['data']['token'] != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', response['data']['token']);
    }

    return response;
  }
}
