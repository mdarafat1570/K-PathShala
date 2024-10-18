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
        data!.add(new NoteResultData.fromJson(v));
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