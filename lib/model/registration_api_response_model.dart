class RegistrationApiResponse {
  String? status;
  Data? data;
  String? message;

  RegistrationApiResponse({this.status, this.data, this.message});

  RegistrationApiResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? token;
  String? tokenType;
  User? user;
  bool? mobileVerified;

  Data({this.token, this.tokenType, this.user, this.mobileVerified});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    tokenType = json['token_type'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    mobileVerified = json['mobileVerified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['token_type'] = this.tokenType;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['mobileVerified'] = this.mobileVerified;
    return data;
  }
}

class User {
  String? name;
  String? email;
  String? mobile;
  String? image;

  User({this.name, this.email, this.mobile, this.image});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['image'] = this.image;
    return data;
  }
}
