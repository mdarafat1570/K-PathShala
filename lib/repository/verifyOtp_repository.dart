import 'package:kpathshala/api/api_container.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/authentication/base_repository.dart';
import 'package:kpathshala/view/login_signup_page/device_id_button_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService extends BaseRepository {
  Future<Map<String, dynamic>> verifyOtp(
      String mobile,
      int otp,
      String deviceId, {
        String? deviceName,
        required String oneSignalPlayerId,
        required BuildContext context,
      }) async {
    final url = AuthorizationEndpoints.verifyOTP;
    final body = {
      'mobile': mobile,
      'otp': otp,
      'device_id': deviceId,
      'one_signal_player_id': oneSignalPlayerId,
    };
    if (deviceName != null) {
      body['device_name'] = deviceName;
    }

    try {
      // Make the API request
      final response = await postRequest(url, body, context: context);

      if (response['status'] == 'success') {
        final token = response['data']['token'];
        final int deviceCount = response['data']['device_count'] ?? 0;

        if (token != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('authToken', token);

    
          if (deviceCount > 2) {
            _showDeviceIdButtonSheet(context);
          }
        }
      }
      else if (response['status'] == 'error' && response['message'] == 'Login device limitation is over') {

        _showDeviceIdButtonSheet(context);
      }

      return response;
    } catch (e) {
   
      print('Error verifying OTP: $e');
      return {'status': 'error', 'message': 'Something went wrong'};
    }
  }

  void _showDeviceIdButtonSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const DevoiceIdButtonSheet(); 
      },
    );
  }
}
