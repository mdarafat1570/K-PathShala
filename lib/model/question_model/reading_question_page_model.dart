class QuestionsModel {
  String? status;
  Data? data;
  String? message;

  QuestionsModel({this.status, this.data, this.message});

  QuestionsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] as String?;
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? duration;
  int? totalQuestion;
  List<ReadingQuestions>? readingQuestions;

  Data({this.duration, this.totalQuestion, this.readingQuestions});

  Data.fromJson(Map<String, dynamic> json) {
    duration = json['duration'] as int?;
    totalQuestion = json['total_question'] as int?;
    if (json['reading_questions'] != null) {
      readingQuestions = <ReadingQuestions>[];
      json['reading_questions'].forEach((v) {
        readingQuestions!.add(ReadingQuestions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['duration'] = this.duration;
    data['total_question'] = this.totalQuestion;
    if (this.readingQuestions != null) {
      data['reading_questions'] = this.readingQuestions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
//
// class ReadingQuestions {
//   int? id;
//   var questionSetId;
//   var title;
//   var question;
//   var subtitle;
//   var imageUrl;
//   List<Options>? options;
//
//   ReadingQuestions({
//     this.id,
//     this.questionSetId,
//     this.title,
//     this.question,
//     this.subtitle,
//     this.imageUrl,
//     this.options,
//   });
//
//   ReadingQuestions.fromJson(Map<String, dynamic> json) {
//     id = json['id'] as int?;
//     questionSetId = json['question_set_id'];
//     title = json['title'];
//     question = json['question'];
//     subtitle = json['subtitle'];
//     imageUrl = json['image_url'];
//     if (json['options'] != null) {
//       options = <Options>[];
//       json['options'].forEach((v) {
//         options!.add(Options.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = this.id;
//     data['question_set_id'] = this.questionSetId;
//     data['title'] = this.title;
//     data['question'] = this.question;
//     data['subtitle'] = this.subtitle;
//     data['image_url'] = this.imageUrl;
//     if (this.options != null) {
//       data['options'] = this.options!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Options {
//   int? id;
//   var optionType;
//   var title;
//
//   Options({
//     this.id,
//     this.optionType,
//     this.title,
//   });
//
//   Options.fromJson(Map<String, dynamic> json) {
//     id = json['id'] as int?;
//     optionType = json['option_type'];
//     title = json['title'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = this.id;
//     data['option_type'] = this.optionType;
//     data['title'] = this.title;
//     return data;
//   }
// }


class ReadingQuestions {
  int id;
  int questionSetId;
  String title;
  dynamic question;
  dynamic subtitle;
  dynamic imageUrl;
  dynamic imageCaption;
  List<Options> options;

  ReadingQuestions({
    required this.id,
    required this.questionSetId,
    required this.title,
    required this.question,
    required this.subtitle,
    required this.imageUrl,
    required this.imageCaption,
    required this.options,
  });

  factory ReadingQuestions.fromJson(Map<String, dynamic> json) => ReadingQuestions(
    id: json["id"],
    questionSetId: json["question_set_id"],
    title: json["title"],
    question: json["question"],
    subtitle: json["subtitle"],
    imageUrl: json["image_url"],
    imageCaption: json["image_caption"],
    options: List<Options>.from(json["options"].map((x) => Options.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question_set_id": questionSetId,
    "title": title,
    "question": question,
    "subtitle": subtitle,
    "image_url": imageUrl,
    "image_caption": imageCaption,
    "options": List<dynamic>.from(options.map((x) => x.toJson())),
  };
}

class Options {
  int id;
  String optionType;
  String title;
  dynamic subtitle;
  dynamic imageUrl;
  dynamic voiceScript;
  dynamic voiceGender;

  Options({
    required this.id,
    required this.optionType,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.voiceScript,
    required this.voiceGender,
  });

  factory Options.fromJson(Map<String, dynamic> json) => Options(
    id: json["id"],
    optionType: json["option_type"],
    title: json["title"],
    subtitle: json["subtitle"],
    imageUrl: json["image_url"],
    voiceScript: json["voice_script"],
    voiceGender: json["voice_gender"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "option_type": optionType,
    "title": title,
    "subtitle": subtitle,
    "image_url": imageUrl,
    "voice_script": voiceScript,
    "voice_gender": voiceGender,
  };
}
