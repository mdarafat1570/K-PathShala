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
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  int? duration;
  int? totalQuestion;
  List<ReadingQuestions>? readingQuestions;
  List<ListeningQuestions>? listeningQuestions;

  Data({this.duration, this.totalQuestion, this.readingQuestions,
    this.listeningQuestions
  });

  Data.fromJson(Map<String, dynamic> json) {
    duration = json['duration'] as int?;
    totalQuestion = json['total_question'] as int?;
    if (json['reading_questions'] != null) {
      readingQuestions = <ReadingQuestions>[];
      json['reading_questions'].forEach((v) {
        readingQuestions!.add(ReadingQuestions.fromJson(v));
      });
    }
    if (json['listening_questions'] != null) {
      listeningQuestions = <ListeningQuestions>[];
      json['listening_questions'].forEach((v) {
        listeningQuestions!.add(ListeningQuestions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['duration'] = duration;
    data['total_question'] = totalQuestion;
    if (readingQuestions != null) {
      data['reading_questions'] = readingQuestions!.map((v) => v.toJson()).toList();
    }
    if (listeningQuestions != null) {
      data['listening_questions'] = listeningQuestions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class ReadingQuestions {
  int id;
  int questionSetId;
  String? title;
  String? question;
  String? subtitle;
  String? imageUrl;
  String? imageCaption;
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

class ListeningQuestions {
  int id;
  int questionSetId;
  String? questionType;
  String? title;
  String? subtitle;
  String? imageUrl;
  String? imageCaption;
  String? voiceScript;
  String? voiceGender;
  dynamic dialogues;
  List<Options> options;

  ListeningQuestions({
    required this.id,
    required this.questionSetId,
    required this.questionType,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.imageCaption,
    required this.voiceScript,
    required this.voiceGender,
    required this.dialogues,
    required this.options,
  });

  factory ListeningQuestions.fromJson(Map<String, dynamic> json) => ListeningQuestions(
    id: json["id"],
    questionSetId: json["question_set_id"],
    questionType: json["question_type"],
    title: json["title"],
    subtitle: json["subtitle"],
    imageUrl: json["image_url"],
    imageCaption: json["image_caption"],
    voiceScript: json["voice_script"],
    voiceGender: json["voice_gender"],
    dialogues: json["dialogues"],
    options: List<Options>.from(json["options"].map((x) => Options.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question_set_id": questionSetId,
    "question_type": questionType,
    "title": title,
    "subtitle": subtitle,
    "image_url": imageUrl,
    "image_caption": imageCaption,
    "voice_script": voiceScript,
    "voice_gender": voiceGender,
    "dialogues": dialogues,
    "options": List<dynamic>.from(options.map((x) => x.toJson())),
  };
}

class Options {
  int id;
  String optionType;
  String? title;
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
