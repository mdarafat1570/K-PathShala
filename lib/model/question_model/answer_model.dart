class AnswerModel {
  int? questionSetId;
  int? duration;
  List<Answers>? answers;

  AnswerModel({this.questionSetId, this.duration, this.answers});

  AnswerModel.fromJson(Map<String, dynamic> json) {
    questionSetId = json['question_set_id'];
    duration = json['duration'];
    if (json['answers'] != null) {
      answers = <Answers>[];
      json['answers'].forEach((v) {
        answers!.add(Answers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question_set_id'] = questionSetId;
    data['duration'] = duration;
    if (answers != null) {
      data['answers'] = answers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Answers {
  int? questionId;
  int? questionOptionId;

  Answers({this.questionId, this.questionOptionId});

  Answers.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    questionOptionId = json['question_option_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question_id'] = questionId;
    data['question_option_id'] = questionOptionId;
    return data;
  }
}
