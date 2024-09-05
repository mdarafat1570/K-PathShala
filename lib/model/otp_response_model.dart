class OTPSuccessResponse {
  final String status;
  final Data data;
  final String message;

  OTPSuccessResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  factory OTPSuccessResponse.fromJson(Map<String, dynamic> json) {
    return OTPSuccessResponse(
      status: json['status'],
      data: Data.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class Data {
  final String token;
  final String tokenType;
  final User user;
  final bool isProfileRequired;

  Data({
    required this.token,
    required this.tokenType,
    required this.user,
    required this.isProfileRequired,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      token: json['token'],
      tokenType: json['token_type'],
      user: User.fromJson(json['user']),
      isProfileRequired: json['isProfileRequired'],
    );
  }
}

class User {
  final String name;
  final String? email;
  final String mobile;
  final String? image;

  User({
    required this.name,
    this.email,
    required this.mobile,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      image: json['image'],
    );
  }
}

class OTPErrorResponse {
  final bool error;
  final String message;
  final Details details;

  OTPErrorResponse({
    required this.error,
    required this.message,
    required this.details,
  });

  factory OTPErrorResponse.fromJson(Map<String, dynamic> json) {
    return OTPErrorResponse(
      error: json['error'],
      message: json['message'],
      details: Details.fromJson(json['details']),
    );
  }
}

class Details {
  final String status;
  final List<dynamic> validationErrors;
  final String message;

  Details({
    required this.status,
    required this.validationErrors,
    required this.message,
  });

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      status: json['status'],
      validationErrors: List<dynamic>.from(json['validationErrors']),
      message: json['message'],
    );
  }
}

class OTPApiResponse {
  OTPSuccessResponse? successResponse;
  OTPErrorResponse? errorResponse;

  OTPApiResponse.success(this.successResponse);
  OTPApiResponse.error(this.errorResponse);

  factory OTPApiResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('status')) {
      return OTPApiResponse.success(OTPSuccessResponse.fromJson(json));
    } else if (json.containsKey('error')) {
      return OTPApiResponse.error(OTPErrorResponse.fromJson(json));
    } else {
      throw Exception("Unexpected response format");
    }
  }
}

