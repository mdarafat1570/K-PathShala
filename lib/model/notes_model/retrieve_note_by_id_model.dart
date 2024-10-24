class RetrieveNoteByIDModel {
  int? id;
  int? questionSetId;
  int? userId;
  String? title;
  String? description;
  String? createdAt;
  String? updatedAt;

  RetrieveNoteByIDModel(
      {this.id,
      this.questionSetId,
      this.userId,
      this.title,
      this.description,
      this.createdAt,
      this.updatedAt});

  RetrieveNoteByIDModel.fromJson(Map<String, dynamic> json) {
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


