class PaymentHistoryModel {
  List<PaymentRecord>? data;
  String? status;
  String? message;

  PaymentHistoryModel({this.data, this.status, this.message});

  // From JSON constructor
  PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(PaymentRecord.fromJson(v));
      });
    }
  }

  // To JSON method
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaymentRecord {
  int? paymentId;
  int? subscriptionId;
  int? packageId;
  String? packageName;
  double? paymentAmount;
  String? paymentDate;

  PaymentRecord({
    this.paymentId,
    this.subscriptionId,
    this.packageId,
    this.packageName,
    this.paymentAmount,
    this.paymentDate,
  });

  // From JSON constructor for individual records
  PaymentRecord.fromJson(Map<String, dynamic> json) {
    paymentId = json['payment_id'];
    subscriptionId = json['subscription_id'];
    packageId = json['package_id'];
    packageName = json['package_name'];
    paymentAmount = json['payment_amount'].toDouble();
    paymentDate = json['payment_date'];
  }

  // To JSON method for individual records
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['payment_id'] = paymentId;
    data['subscription_id'] = subscriptionId;
    data['package_id'] = packageId;
    data['package_name'] = packageName;
    data['payment_amount'] = paymentAmount;
    data['payment_date'] = paymentDate;
    return data;
  }
}
