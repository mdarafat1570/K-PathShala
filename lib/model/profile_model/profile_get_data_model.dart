class ProfileGetDataModel {
  dynamic courseTaken;
  dynamic examTaken;
  dynamic memberSince;

  ProfileGetDataModel({this.courseTaken, this.examTaken, this.memberSince});

  ProfileGetDataModel.fromJson(Map<String, dynamic> json) {
    courseTaken = json['course_taken'];
    examTaken = json['exam_taken'];
    memberSince = json['member_since'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['course_taken'] = courseTaken;
    data['exam_taken'] = examTaken;
    data['member_since'] = memberSince;
    return data;
  }
}
