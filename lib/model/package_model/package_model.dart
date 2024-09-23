class PackageModel {
  String? status;
  List<PackageList>? data;
  String? message;

  PackageModel({this.status, this.data, this.message});

  PackageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <PackageList>[];
      json['data'].forEach((v) {
        data!.add(new PackageList.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class PackageList {
  var id;
  String? title;
  String? subtitle;
  String? effectDate;
  var validity;
  var price;
  var withDiscountPrice;
  List<String>? features;
  bool? status;
  var expiryIn;
  var completedQuestionSet;
  var totalQuestionSet;
  bool? isUserAccess;
  Subscription? subscription;

  PackageList(
      {this.id,
        this.title,
        this.subtitle,
        this.effectDate,
        this.validity,
        this.price,
        this.withDiscountPrice,
        this.features,
        this.status,
        this.expiryIn,
        this.completedQuestionSet,
        this.totalQuestionSet,
        this.isUserAccess,
        this.subscription});

  PackageList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subtitle = json['subtitle'];
    effectDate = json['effect_date'];
    validity = json['validity'];
    price = json['price'];
    withDiscountPrice = json['withDiscountPrice'];
    features = json['features'].cast<String>();
    status = json['status'];
    expiryIn = json['expiry_in'];
    completedQuestionSet = json['completedQuestionSet'];
    totalQuestionSet = json['totalQuestionSet'];
    isUserAccess = json['isUserAccess'];
    subscription = json['subscription'] != null
        ? new Subscription.fromJson(json['subscription'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['effect_date'] = this.effectDate;
    data['validity'] = this.validity;
    data['price'] = this.price;
    data['withDiscountPrice'] = this.withDiscountPrice;
    data['features'] = this.features;
    data['status'] = this.status;
    data['expiry_in'] = this.expiryIn;
    data['completedQuestionSet'] = this.completedQuestionSet;
    data['totalQuestionSet'] = this.totalQuestionSet;
    data['isUserAccess'] = this.isUserAccess;
    if (this.subscription != null) {
      data['subscription'] = this.subscription!.toJson();
    }
    return data;
  }
}

class Subscription {
  var id;
  var packageId;
  var bookId;
  String? subscriptionTypeId;
  String? effectDate;
  var userId;
  String? expireDate;
  var validity;
  var couponId;
  String? createdAt;
  String? updatedAt;

  Subscription(
      {this.id,
        this.packageId,
        this.bookId,
        this.subscriptionTypeId,
        this.effectDate,
        this.userId,
        this.expireDate,
        this.validity,
        this.couponId,
        this.createdAt,
        this.updatedAt});

  Subscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packageId = json['package_id'];
    bookId = json['book_id'];
    subscriptionTypeId = json['subscription_type_id'];
    effectDate = json['effect_date'];
    userId = json['user_id'];
    expireDate = json['expire_date'];
    validity = json['validity'];
    couponId = json['coupon_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['package_id'] = this.packageId;
    data['book_id'] = this.bookId;
    data['subscription_type_id'] = this.subscriptionTypeId;
    data['effect_date'] = this.effectDate;
    data['user_id'] = this.userId;
    data['expire_date'] = this.expireDate;
    data['validity'] = this.validity;
    data['coupon_id'] = this.couponId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
