class ExamResult {
  String? status;
  ResultData? data;
  String? message;

  ExamResult({this.status, this.data, this.message});

  ExamResult.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? ResultData.fromJson(json['data']) : null;
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

class ResultData {
  int? gotReadingScore;
  int? gotListeningScore;
  int? maxReadingScore;
  int? maxListeningScore;
  int? takenTime;
  int? totalGotScore;
  int? maximumScore;
  int? totalRetake;
  int? totalSpendTime;

  ResultData(
      {this.gotReadingScore,
        this.gotListeningScore,
        this.maxReadingScore,
        this.maxListeningScore,
        this.takenTime,
        this.totalGotScore,
        this.maximumScore,
        this.totalRetake,
        this.totalSpendTime});

  ResultData.fromJson(Map<String, dynamic> json) {
    gotReadingScore = json['got_reading_score'];
    gotListeningScore = json['got_listening_score'];
    maxReadingScore = json['max_reading_score'];
    maxListeningScore = json['max_listening_score'];
    takenTime = json['taken_time'];
    totalGotScore = json['total_got_score'];
    maximumScore = json['maximum_score'];
    totalRetake = json['total_retake'];
    totalSpendTime = json['total_spend_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['got_reading_score'] = gotReadingScore;
    data['got_listening_score'] = gotListeningScore;
    data['max_reading_score'] = maxReadingScore;
    data['max_listening_score'] = maxListeningScore;
    data['taken_time'] = takenTime;
    data['total_got_score'] = totalGotScore;
    data['maximum_score'] = maximumScore;
    data['total_retake'] = totalRetake;
    data['total_spend_time'] = totalSpendTime;
    return data;
  }
}
