import 'package:kpathshala/api/api_container.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/authentication/base_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService extends BaseRepository {
  // Verify OTP
  Future<Map<String, dynamic>> verifyOtp(
      String mobile, int otp, String deviceId,
      {String? deviceName, required BuildContext context}) async {
    final url = AuthorizationEndpoints.verifyOTP;
    final body = {
      'mobile': mobile,
      'otp': otp,
      'device_id': deviceId,
    };

    if (deviceName != null) {
      body['device_name'] = deviceName;
    }

    // Use the postRequest method from the BaseRepository
    final response = await postRequest(url, body, context: context);

    // Check the response for success and save the token if applicable
    if (response['status'] == 'success' && response['data']['token'] != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', response['data']['token']);
    }

    return response;
  }




  
}
