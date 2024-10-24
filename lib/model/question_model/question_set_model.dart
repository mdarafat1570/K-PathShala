class QuestionSetModel {
  String? status;
  QuestionSetData? data;
  String? message;

  QuestionSetModel({this.status, this.data, this.message});

  QuestionSetModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? QuestionSetData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class QuestionSetData {
  List<QuestionSets>? questionSets;
  QuestionSetResults? results;

  QuestionSetData({this.questionSets, this.results});

  QuestionSetData.fromJson(Map<String, dynamic> json) {
    if (json['question_sets'] != null) {
      questionSets = <QuestionSets>[];
      json['question_sets'].forEach((v) {
        questionSets!.add(QuestionSets.fromJson(v));
      });
    }
    results =
    json['results'] != null ? QuestionSetResults.fromJson(json['results']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (questionSets != null) {
      data['question_sets'] =
          questionSets!.map((v) => v.toJson()).toList();
    }
    if (results != null) {
      data['results'] = results!.toJson();
    }
    return data;
  }
}

class QuestionSets {
  dynamic id;
  String? title;
  String? subtitle;
  dynamic packageId;
  String? packageName;
  dynamic duration;
  dynamic totalQuestion;
  String? status;
  dynamic score;

  QuestionSets(
      {this.id,
        this.title,
        this.subtitle,
        this.packageId,
        this.packageName,
        this.duration,
        this.totalQuestion,
        this.status,
        this.score});

  QuestionSets.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subtitle = json['subtitle'];
    packageId = json['package_id'];
    packageName = json['package_name'];
    duration = json['duration'];
    totalQuestion = json['total_question'];
    status = json['status'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['package_id'] = packageId;
    data['package_name'] = packageName;
    data['duration'] = duration;
    data['total_question'] = totalQuestion;
    data['status'] = status;
    data['score'] = score;
    return data;
  }
}

class QuestionSetResults {
  dynamic completedQuestionSet;
  dynamic totalQuestionSet;
  dynamic batch;
  dynamic rankPercentage;

  QuestionSetResults(
      {this.completedQuestionSet,
        this.totalQuestionSet,
        this.batch,
        this.rankPercentage});

  QuestionSetResults.fromJson(Map<String, dynamic> json) {
    completedQuestionSet = json['completedQuestionSet'];
    totalQuestionSet = json['totalQuestionSet'];
    batch = json['batch'];
    rankPercentage = json['rank_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['completedQuestionSet'] = completedQuestionSet;
    data['totalQuestionSet'] = totalQuestionSet;
    data['batch'] = batch;
    data['rank_percentage'] = rankPercentage;
    return data;
  }
}