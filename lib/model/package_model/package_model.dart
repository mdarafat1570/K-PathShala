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
        data!.add(PackageList.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class PackageList {
  dynamic id;
  String? title;
  String? subtitle;
  String? effectDate;
  dynamic validity;
  dynamic price;
  dynamic withDiscountPrice;
  List<String>? features;
  bool? status;
  dynamic expiryIn;
  dynamic completedQuestionSet;
  dynamic totalQuestionSet;
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
        ? Subscription.fromJson(json['subscription'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['effect_date'] = effectDate;
    data['validity'] = validity;
    data['price'] = price;
    data['withDiscountPrice'] = withDiscountPrice;
    data['features'] = features;
    data['status'] = status;
    data['expiry_in'] = expiryIn;
    data['completedQuestionSet'] = completedQuestionSet;
    data['totalQuestionSet'] = totalQuestionSet;
    data['isUserAccess'] = isUserAccess;
    if (subscription != null) {
      data['subscription'] = subscription!.toJson();
    }
    return data;
  }
}

class Subscription {
  dynamic id;
  dynamic packageId;
  dynamic bookId;
  String? subscriptionTypeId;
  String? effectDate;
  dynamic userId;
  String? expireDate;
  dynamic validity;
  dynamic couponId;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['package_id'] = packageId;
    data['book_id'] = bookId;
    data['subscription_type_id'] = subscriptionTypeId;
    data['effect_date'] = effectDate;
    data['user_id'] = userId;
    data['expire_date'] = expireDate;
    data['validity'] = validity;
    data['coupon_id'] = couponId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
