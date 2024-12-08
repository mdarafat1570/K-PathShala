class PaymentHistoryModel {
  String? status;
  List<Data>? data;
  String? message;

  PaymentHistoryModel({this.status, this.data, this.message});

  PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  int? paymentId;
  int? subscriptionId;
  int? packageId;
  String? packageName;
  int? paymentAmount;
  String? paymentStatus;
  String? paymentDate;

  Data(
      {this.paymentId,
      this.subscriptionId,
      this.packageId,
      this.packageName,
      this.paymentAmount,
      this.paymentStatus,
      this.paymentDate});

  Data.fromJson(Map<String, dynamic> json) {
    paymentId = json['payment_id'];
    subscriptionId = json['subscription_id'];
    packageId = json['package_id'];
    packageName = json['package_name'];
    paymentAmount = json['payment_amount'];
    paymentStatus = json['payment_status'];
    paymentDate = json['payment_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_id'] = this.paymentId;
    data['subscription_id'] = this.subscriptionId;
    data['package_id'] = this.packageId;
    data['package_name'] = this.packageName;
    data['payment_amount'] = this.paymentAmount;
    data['payment_status'] = this.paymentStatus;
    data['payment_date'] = this.paymentDate;
    return data;
  }
}
