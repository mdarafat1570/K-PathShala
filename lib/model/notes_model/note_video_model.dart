class NoteVideoModel {
  String? status;
  NoteVideoData? data;
  String? message;

  NoteVideoModel({this.status, this.data, this.message});

  NoteVideoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new NoteVideoData.fromJson(json['data']) : null;
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

class NoteVideoData {
  int? id;
  String? title;
  String?subtitle;
  String? videoLink;
  int? questionSetId;
  String? createdAt;
  String? updatedAt;

  NoteVideoData(
      {this.id,
      this.title,
      this.subtitle,
      this.videoLink,
      this.questionSetId,
      this.createdAt,
      this.updatedAt});

  NoteVideoData.fromJson(Map<String, dynamic> json) {
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