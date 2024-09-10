class LogInCredentials {
  String? name;
  String? email;
  String? mobile;
  String? imagesAddress;
  String? token;

  LogInCredentials({this.name, this.email, this.mobile, this.imagesAddress, this.token});

  // Convert a LogInCredentials object to JSON (String).
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'mobile': mobile,
      'imagesAddress': imagesAddress,
      'token': token,
    };
  }

  // Create a LogInCredentials object from JSON (String).
  factory LogInCredentials.fromJson(Map<String, dynamic> json) {
    return LogInCredentials(
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      imagesAddress: json['imagesAddress'],
      token: json['token'],
    );
  }
}
