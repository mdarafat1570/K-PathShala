class NoteGetModel {
  String? status;
  List<NoteResultData>? data;
  String? message;

  NoteGetModel({this.status, this.data, this.message});

  NoteGetModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <NoteResultData>[];
      json['data'].forEach((v) {
        data!.add(NoteResultData.fromJson(v));
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

class NoteResultData {
  int? id;
  int? questionSetId;
  int? userId;
  String? title;
  String? description;
  String? createdAt;
  String? updatedAt;

  NoteResultData(
      {this.id,
      this.questionSetId,
      this.userId,
      this.title,
      this.description,
      this.createdAt,
      this.updatedAt});

  NoteResultData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionSetId = json['question_set_id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question_set_id'] = questionSetId;
    data['user_id'] = userId;
    data['title'] = title;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}