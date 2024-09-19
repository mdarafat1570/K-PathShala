class PackageModel {
  String? status;
  List<PackageModelList>? data;
  String? message;

  PackageModel({this.status, this.data, this.message});

  PackageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <PackageModelList>[];
      json['data'].forEach((v) {
        data!.add( PackageModelList.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['status'] = status;
    data['data'] = this.data!.map((v) => v.toJson()).toList();
      data['message'] = message;
    return data;
  }
}

class PackageModelList {
  int? id;
  String? title;
  String? subtitle;
  String? effectDate;
  String? validityDate;
  int? price;
  List<String>? features;
  bool? status;
  bool? isUserAccess;
  Subscription? subscription;

  PackageModelList(
      {this.id,
        this.title,
        this.subtitle,
        this.effectDate,
        this.validityDate,
        this.price,
        this.features,
        this.status,
        this.isUserAccess,
        this.subscription});

  PackageModelList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subtitle = json['subtitle'];
    effectDate = json['effect_date'];
    validityDate = json['validity_date'];
    price = json['price'];
    features = json['features'].cast<String>();
    status = json['status'];
    isUserAccess = json['isUserAccess'];
    subscription = json['subscription'] != null
        ?  Subscription.fromJson(json['subscription'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['effect_date'] = effectDate;
    data['validity_date'] = validityDate;
    data['price'] = price;
    data['features'] = features;
    data['status'] = status;
    data['isUserAccess'] = isUserAccess;
    if (subscription != null) {
      data['subscription'] = subscription!.toJson();
    }
    return data;
  }
}

class Subscription {
  int? id;
  int? packageId;
  int? bookId;
  String? subscriptionTypeId;
  String? effectDate;
  int? userId;
  String? expireDate;
  int? validity;
  int? couponId;
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
