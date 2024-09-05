class AuthorizationEndpoints {
  static const String baseUrl = 'http://5.104.86.3:8010/api/v1';

  // Endpoint to send OTP
  static String sendOTP = '$baseUrl/send-otp';

  // Endpoint to verify OTP
  static const String verifyOTP = '$baseUrl/verify-otp';

  // Endpoint to receive OTP
  static String receiveOTP = '$baseUrl/otp/userPhoneNumber';
  static String registerUser = '$baseUrl/auth/register';
  static String userUpdate = '$baseUrl/user-update';

    // Endpoint to fetch YouTube channel statistics
  static String getYouTubeStats(String channelId, String apiKey) {
    return "https://www.googleapis.com/youtube/v3/channels?part=statistics&id=$channelId&key=$apiKey";
  }
}
