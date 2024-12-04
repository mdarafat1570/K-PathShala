class AuthorizationEndpoints {
  static const String demoBaseUrl = 'https://dev.kpathshala.com/api/v1';
  static const String liveBaseUrl = 'https://api.kpathshala.com/api/v1';

  static bool useLiveServer = true; // Set to true for live

  static String get baseUrl => useLiveServer ? liveBaseUrl : demoBaseUrl;

  // OTP Endpoints
  static final String sendOTP = '$baseUrl/send-otp';
  static final String verifyOTP = '$baseUrl/verify-otp';
  static final String receiveOTP = '$baseUrl/otp/userPhoneNumber';
  static final String logOut = '$baseUrl/logout';

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
  static String result =
      '${AuthorizationEndpoints.baseUrl}/result_question_set';
  static String answerReview =
      '${AuthorizationEndpoints.baseUrl}/answer_review';
}

class KpatshalaDashboardPage {
  static String dashboard = '${AuthorizationEndpoints.baseUrl}/dashboard';
}

class KpatshalaQuestionPage {
  static String readingQuestion = '${AuthorizationEndpoints.baseUrl}/question';
  static String textToSpeech =
      '${AuthorizationEndpoints.baseUrl}/text-to-speech';
}

class KpatshalaAnswerSubmission {
  static String answerSubmission =
      '${AuthorizationEndpoints.baseUrl}/answer_submission';
}

class KpatshalaRetrieveNotesQuestion {
  static String retrieveNotesQuestion =
      '${AuthorizationEndpoints.baseUrl}/notes';
  static String retrieveNotesVideo =
      '${AuthorizationEndpoints.baseUrl}/setExplanationVideo';
}

class KpathShalaYoutubeWebSite {
  static String kpathshalaWeb = "https://kpathshala.com/";
  static String kpathshalaYoutubeChannel =
      'https://www.youtube.com/channel/UCKeeBsW1hGy0NBCqKgd5oBw';
  static String youtubeSubscriberCountBase =
      'https://www.googleapis.com/youtube/v3/channels?part=statistics&id=UCKeeBsW1hGy0NBCqKgd5oBw&key=';
  static String youtubeSubscriberCountApiKey =
      "AIzaSyClsZlG68dO9BB9mF5XzxrdXvFcxehh9RA";
}
