class ProfileGetDataModel {
  var courseTaken;
  var examTaken;
  var memberSince;

  ProfileGetDataModel({this.courseTaken, this.examTaken, this.memberSince});

  ProfileGetDataModel.fromJson(Map<String, dynamic> json) {
    courseTaken = json['course_taken'];
    examTaken = json['exam_taken'];
    memberSince = json['member_since'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['course_taken'] = this.courseTaken;
    data['exam_taken'] = this.examTaken;
    data['member_since'] = this.memberSince;
    return data;
  }
}
