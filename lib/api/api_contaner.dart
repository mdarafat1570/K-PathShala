class AuthorizationEndpoints {
  static const String baseUrl = 'http://5.104.86.3:8010/api/v1';

  // Endpoint to send OTP
  static String sendOTP(String phoneNumber) => '$baseUrl/send-otp/$phoneNumber';

  // Endpoint to verify OTP
  static const String verifyOTP = '$baseUrl/verify-otp';

  // Endpoint to receive OTP
  static String receiveOTP(String phoneNumber) => '$baseUrl/otp/$phoneNumber';
  static String registerUser = '$baseUrl/auth/register';
}
