class AuthorizationEndpoints {
  static const String baseUrl = 'http://167.99.118.239:8009/api/v1';

  // OTP Endpoints
  static String sendOTP = '$baseUrl/send-otp';
  static const String verifyOTP = '$baseUrl/verify-otp';
  static String receiveOTP = '$baseUrl/otp/userPhoneNumber';

  // User Endpoints
  static String registerUser = '$baseUrl/auth/register';
  static String userUpdate = '$baseUrl/user-update';

  // YouTube Channel Statistics
  static String getYouTubeStats(String channelId, String apiKey) {
    return 'https://www.googleapis.com/youtube/v3/channels?part=statistics&id=$channelId&key=$apiKey';
  }
}

class KpatshalaPackage {
  static String packages = '${AuthorizationEndpoints.baseUrl}/package';
}
