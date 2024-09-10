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
        data!.add(new PackageModelList.fromJson(v));
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

class PackageModelList {
  int? id;
  String? title;
  String? subtitle;
  String? effectDate;
  String? validityDate;
  int? price;
  List<String>? features;
  bool? status;

  PackageModelList(
      {this.id,
      this.title,
      this.subtitle,
      this.effectDate,
      this.validityDate,
      this.price,
      this.features,
      this.status});

  PackageModelList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subtitle = json['subtitle'];
    effectDate = json['effect_date'];
    validityDate = json['validity_date'];
    price = json['price'];
    features = json['features'].cast<String>();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['effect_date'] = this.effectDate;
    data['validity_date'] = this.validityDate;
    data['price'] = this.price;
    data['features'] = this.features;
    data['status'] = this.status;
    return data;
  }
}