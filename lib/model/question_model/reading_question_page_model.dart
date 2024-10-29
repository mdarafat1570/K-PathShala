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
  dynamic duration;
  dynamic totalQuestion;
  List<ReadingQuestions>? readingQuestions;
  List<ListeningQuestions>? listeningQuestions;

  Data({this.duration, this.totalQuestion, this.readingQuestions,
    this.listeningQuestions
  });

  Data.fromJson(Map<String, dynamic> json) {
    duration = json['duration'] as dynamic;
    totalQuestion = json['total_question'] as dynamic;
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
  dynamic id;
  dynamic questionSetId;
  String? title;
  String? question;
  String? subtitle;
  String? imageUrl;
  String? imageCaption;
  List<Options> options;
  AnswerOption? answerOption;
  Submission? submission;

  ReadingQuestions({
    required this.id,
    required this.questionSetId,
    required this.title,
    required this.question,
    required this.subtitle,
    required this.imageUrl,
    required this.imageCaption,
    required this.options,
    required this.answerOption,
    required this.submission,
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
    answerOption: json["answer_option"] != null ? AnswerOption.fromJson(json["answer_option"]) : null,
    submission: json["submission"] != null ? Submission.fromJson(json["submission"]) : null,
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
    "answer_option": answerOption?.toJson(),
    "submission": submission?.toJson(),
  };
}

class ListeningQuestions {
  dynamic id;
  dynamic questionSetId;
  String? questionType;
  String? title;
  String? subtitle;
  String? imageUrl;
  String? imageCaption;
  String? voiceScript;
  String? voiceGender;
  List<Dialogue> dialogues;
  List<Options> options;
  AnswerOption? answerOption;
  Submission? submission;

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
    required this.options, required this.answerOption, required this.submission
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
    dialogues: List<Dialogue>.from(json["dialogues"].map((x) => Dialogue.fromJson(x))),
    options: List<Options>.from(json["options"].map((x) => Options.fromJson(x))),
    answerOption: json["answer_option"] != null ? AnswerOption.fromJson(json["answer_option"]) : null,
    submission: json["submission"] != null ? Submission.fromJson(json["submission"]) : null,
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
    "dialogues": List<dynamic>.from(dialogues.map((x) => x.toJson())),
    "options": List<dynamic>.from(options.map((x) => x.toJson())),
    "answer_option": answerOption?.toJson(),
    "submission": submission?.toJson(),
  };
}

class Dialogue {
  String? voiceScript;
  String? voiceGender;
  dynamic sequence;

  Dialogue({this.voiceScript, this.voiceGender, this.sequence});

  Dialogue.fromJson(Map<String, dynamic> json) {
    voiceScript = json['voice_script'];
    voiceGender = json['voice_gender'];
    sequence = json['sequence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['voice_script'] = voiceScript;
    data['voice_gender'] = voiceGender;
    data['sequence'] = sequence;
    return data;
  }
}

class Options {
  dynamic id;
  String? optionType;
  String? title;
  dynamic subtitle;
  dynamic imageUrl;
  dynamic voiceScript;
  dynamic voiceGender;
  dynamic isAnnounce;

  Options({
    required this.id,
    required this.optionType,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.voiceScript,
    required this.voiceGender,
    required this.isAnnounce,
  });

  factory Options.fromJson(Map<String, dynamic> json) => Options(
    id: json["id"],
    optionType: json["option_type"],
    title: json["title"],
    subtitle: json["subtitle"],
    imageUrl: json["image_url"],
    voiceScript: json["voice_script"],
    voiceGender: json["voice_gender"],
      isAnnounce: json["isAnnounce"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "option_type": optionType,
    "title": title,
    "subtitle": subtitle,
    "image_url": imageUrl,
    "voice_script": voiceScript,
    "voice_gender": voiceGender,
    "isAnnounce": isAnnounce,
  };
}

class AnswerOption {
  dynamic id;
  dynamic questionId;
  dynamic questionOptionId;
  String? description;
  String? createdAt;
  String? updatedAt;

  AnswerOption(
      {this.id,
        this.questionId,
        this.questionOptionId,
        this.description,
        this.createdAt,
        this.updatedAt});

  AnswerOption.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionId = json['question_id'];
    questionOptionId = json['question_option_id'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question_id'] = questionId;
    data['question_option_id'] = questionOptionId;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Submission {
  dynamic id;
  dynamic questionSetSubmissionsId;
  dynamic questionId;
  dynamic questionOptionId;
  String? userResponse;
  String? createdAt;
  String? updatedAt;
  Options? option;

  Submission(
      {this.id,
        this.questionSetSubmissionsId,
        this.questionId,
        this.questionOptionId,
        this.userResponse,
        this.createdAt,
        this.updatedAt,
        this.option});

  Submission.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionSetSubmissionsId = json['question_set_submissions_id'];
    questionId = json['question_id'];
    questionOptionId = json['question_option_id'];
    userResponse = json['user_response'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    option =
    json['option'] != null ? Options.fromJson(json['option']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question_set_submissions_id'] = questionSetSubmissionsId;
    data['question_id'] = questionId;
    data['question_option_id'] = questionOptionId;
    data['user_response'] = userResponse;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (option != null) {
      data['option'] = option!.toJson();
    }
    return data;
  }
}