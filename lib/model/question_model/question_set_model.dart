class QuestionSetModel {
  String? status;
  List<QuestionSet>? data;
  String? message;

  QuestionSetModel({this.status, this.data, this.message});

  // From JSON constructor
  QuestionSetModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(QuestionSet.fromJson(v));
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

class QuestionSet {
  int? id;
  String? title;
  int? packageId;
  String? packageName;
  int? duration;
  int? totalQuestion;

  QuestionSet({
    this.id,
    this.title,
    this.packageId,
    this.packageName,
    this.duration,
    this.totalQuestion,
  });

  // From JSON constructor for individual question sets
  QuestionSet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    packageId = json['package_id'];
    packageName = json['package_name'];
    duration = json['duration'];
    totalQuestion = json['total_question'];
  }

  // To JSON method for individual question sets
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['package_id'] = packageId;
    data['package_name'] = packageName;
    data['duration'] = duration;
    data['total_question'] = totalQuestion;
    return data;
  }
}
