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
        banners!.add(Banners.fromJson(v));
      });
    }
    exam = json['exam'] != null ? Exam.fromJson(json['exam']) : null;
    videoClasses = json['videoClasses'];
    isVersionUpdateRequired = json['isVersionUpdateRequired'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (banners != null) {
      data['banners'] = banners!.map((v) => v.toJson()).toList();
    }
    if (exam != null) {
      data['exam'] = exam!.toJson();
    }
    data['videoClasses'] = videoClasses;
    data['isVersionUpdateRequired'] = isVersionUpdateRequired;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['banner_url'] = bannerUrl;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['exam_name'] = examName;
    data['subscription_id'] = subscriptionId;
    data['package_id'] = packageId;
    data['completedQuestionSet'] = completedQuestionSet;
    data['totalQuestionSet'] = totalQuestionSet;
    return data;
  }
}
