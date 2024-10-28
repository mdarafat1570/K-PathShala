class DashboardPageModel {
  List<Banners>? banners;
  Exam? exam;
  int? videoClasses;
  bool? isVersionUpdateRequired;

  DashboardPageModel(
      {this.banners,
      this.exam,
      this.videoClasses,
      this.isVersionUpdateRequired});

  DashboardPageModel.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners!.add(new Banners.fromJson(v));
      });
    }
    exam = json['exam'] != null ? new Exam.fromJson(json['exam']) : null;
    videoClasses = json['videoClasses'];
    isVersionUpdateRequired = json['isVersionUpdateRequired'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banners != null) {
      data['banners'] = this.banners!.map((v) => v.toJson()).toList();
    }
    if (this.exam != null) {
      data['exam'] = this.exam!.toJson();
    }
    data['videoClasses'] = this.videoClasses;
    data['isVersionUpdateRequired'] = this.isVersionUpdateRequired;
    return data;
  }
}

class Banners {
  int? id;
  String? title;
  String? bannerUrl;
  String? createdAt;
  String? updatedAt;

  Banners(
      {this.id, this.title, this.bannerUrl, this.createdAt, this.updatedAt});

  Banners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    bannerUrl = json['banner_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['banner_url'] = this.bannerUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Exam {
  String? examName;
  int? subscriptionId;
  int? packageId;
  int? completedQuestionSet;
  int? totalQuestionSet;

  Exam(
      {this.examName,
      this.subscriptionId,
      this.packageId,
      this.completedQuestionSet,
      this.totalQuestionSet});

  Exam.fromJson(Map<String, dynamic> json) {
    examName = json['exam_name'];
    subscriptionId = json['subscription_id'];
    packageId = json['package_id'];
    completedQuestionSet = json['completedQuestionSet'];
    totalQuestionSet = json['totalQuestionSet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['exam_name'] = this.examName;
    data['subscription_id'] = this.subscriptionId;
    data['package_id'] = this.packageId;
    data['completedQuestionSet'] = this.completedQuestionSet;
    data['totalQuestionSet'] = this.totalQuestionSet;
    return data;
  }
}