import 'package:kpathshala/api/api_contaner.dart';
import 'package:kpathshala/base/base_repository.dart';
import 'package:kpathshala/base/get_device_Id.dart';
import '../api/json_response.dart';

class OtpRepository extends BaseRepository {
 Future<void> sendOtp(String mobileNumber, String email) async {
  String? deviceId = await getDeviceId();

  final data = {
    'mobile': mobileNumber,
    'email': email,
    'device_id': deviceId ?? '', // Include device ID
  };

  await fetchData(
    AuthorizationEndpoints.sendOTP(mobileNumber),
    data,
    (response) {
      print('OTP sent successfully: ${response['message']}');
    },
    isPost: true,
  );
}

Future<JsonResponse> verifyOtp(String mobileNumber, String otp) async {
  String? deviceId = await getDeviceId();

  final data = {
    'mobile': mobileNumber,
    'otp': otp,
    'device_id': deviceId ?? '', 
    'device_name': 'android',  
  };

  final response = await fetchData(
    AuthorizationEndpoints.verifyOTP,
    data,
    (response) {
      print('OTP verified successfully: ${response['message']}');
      return response;
    },
    isPost: true,
  );

  return response;
}


 
  Future<JsonResponse> registerUser(
      String name, String email, String mobile, String image) async {
    final data = {
      'name': name,
      'email': email,
      'mobile': mobile,
      'image': image,
    };

    final response = await fetchData(
      AuthorizationEndpoints.registerUser,
      data,
      (response) {
        print('User registered successfully: ${response['message']}');
        return response;
      },
      isPost: true,
    );

    return response;
  }
}
