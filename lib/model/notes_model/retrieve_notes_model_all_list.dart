class NoteGetModel {
  String? status;
  NoteResultData? data;
  String? message;

  NoteGetModel({this.status, this.data, this.message});

  NoteGetModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new NoteResultData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class NoteResultData {
  QuestionSetSolutions? questionSetSolutions;
  List<QuestionNotes>? questionNotes;

  NoteResultData({this.questionSetSolutions, this.questionNotes});

  NoteResultData.fromJson(Map<String, dynamic> json) {
    questionSetSolutions = json['question_set_solutions'] != null
        ? new QuestionSetSolutions.fromJson(json['question_set_solutions'])
        : null;
    if (json['question_notes'] != null) {
      questionNotes = <QuestionNotes>[];
      json['question_notes'].forEach((v) {
        questionNotes!.add(new QuestionNotes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.questionSetSolutions != null) {
      data['question_set_solutions'] = this.questionSetSolutions!.toJson();
    }
    if (this.questionNotes != null) {
      data['question_notes'] =
          this.questionNotes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuestionSetSolutions {
  int? id;
  String? title;
  String? subtitle;
  String? videoLink;
  int? questionSetId;
  String? createdAt;
  String? updatedAt;

  QuestionSetSolutions(
      {this.id,
      this.title,
      this.subtitle,
      this.videoLink,
      this.questionSetId,
      this.createdAt,
      this.updatedAt});

  QuestionSetSolutions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subtitle = json['subtitle'];
    videoLink = json['video_link'];
    questionSetId = json['question_set_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['video_link'] = this.videoLink;
    data['question_set_id'] = this.questionSetId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class QuestionNotes {
  int? id;
  int? questionSetId;
  int? userId;
  String? title;
  String? description;
  String? createdAt;
  String? updatedAt;

  QuestionNotes(
      {this.id,
      this.questionSetId,
      this.userId,
      this.title,
      this.description,
      this.createdAt,
      this.updatedAt});

  QuestionNotes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionSetId = json['question_set_id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question_set_id'] = this.questionSetId;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}