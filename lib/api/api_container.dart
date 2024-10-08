class AuthorizationEndpoints {
  static const String baseUrl = 'https://api.kpathshala.com/api/v1';

  // OTP Endpoints
  static String sendOTP = '$baseUrl/send-otp';
  static const String verifyOTP = '$baseUrl/verify-otp';
  static String receiveOTP = '$baseUrl/otp/userPhoneNumber';
  static String logOut = '$baseUrl/logout';

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

class KpatshalaProfaile {
  static String profileData = '${AuthorizationEndpoints.baseUrl}/profile';
}

class KpatshalaPaymentHistory {
  static String paymentHistory =
      '${AuthorizationEndpoints.baseUrl}/payment_history';
  static String paymentPost = '${AuthorizationEndpoints.baseUrl}/payments';
}

class KpatshalaquestionSet {
  static String questionSet = '${AuthorizationEndpoints.baseUrl}/question-sets';
}

class KpatshalaAnswerReview {
  static String result = '${AuthorizationEndpoints.baseUrl}/result_question_set';
  static String answerReview = '${AuthorizationEndpoints.baseUrl}/answer_review';
}

class KpatshalaDashboardPage {
  static String dashboard = '${AuthorizationEndpoints.baseUrl}/dashboard';
}

class KpatshalaQuestionPage {
  static String readingQuestion = '${AuthorizationEndpoints.baseUrl}/question';
}

class KpatshalaAnswerSubmission {
  static String answerSubmission =
      '${AuthorizationEndpoints.baseUrl}/answer_submission';
}


class KpatshalaRetrieveNotesQuestion {
  static String RetrieveNotesQuestion =
      '${AuthorizationEndpoints.baseUrl}/notes';
}

