class AnswerReview {
  String? status;
  Data? data;
  String? message;

  AnswerReview({this.status, this.data, this.message});

  AnswerReview.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  int? duration;
  int? takenDuration;
  int? totalQuestion;
  List<ReadingQuestions>? readingQuestions;
  List<ListeningQuestions>? listeningQuestions;

  Data(
      {this.duration,
        this.takenDuration,
        this.totalQuestion,
        this.readingQuestions,
        this.listeningQuestions});

  Data.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    takenDuration = json['taken_duration'];
    totalQuestion = json['total_question'];
    if (json['reading_questions'] != null) {
      readingQuestions = <ReadingQuestions>[];
      json['reading_questions'].forEach((v) {
        readingQuestions!.add(new ReadingQuestions.fromJson(v));
      });
    }
    if (json['listening_questions'] != null) {
      listeningQuestions = <ListeningQuestions>[];
      json['listening_questions'].forEach((v) {
        listeningQuestions!.add(new ListeningQuestions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['duration'] = this.duration;
    data['taken_duration'] = this.takenDuration;
    data['total_question'] = this.totalQuestion;
    if (this.readingQuestions != null) {
      data['reading_questions'] =
          this.readingQuestions!.map((v) => v.toJson()).toList();
    }
    if (this.listeningQuestions != null) {
      data['listening_questions'] =
          this.listeningQuestions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReadingQuestions {
  int? id;
  int? questionSetId;
  String? title;
  String? question;
  String? subtitle;
  String? imageUrl;
  Null? imageCaption;
  List<Options>? options;
  AnswerOption? answerOption;
  Submission? submission;

  ReadingQuestions(
      {this.id,
        this.questionSetId,
        this.title,
        this.question,
        this.subtitle,
        this.imageUrl,
        this.imageCaption,
        this.options,
        this.answerOption,
        this.submission});

  ReadingQuestions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionSetId = json['question_set_id'];
    title = json['title'];
    question = json['question'];
    subtitle = json['subtitle'];
    imageUrl = json['image_url'];
    imageCaption = json['image_caption'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
    answerOption = json['answer_option'] != null
        ? new AnswerOption.fromJson(json['answer_option'])
        : null;
    submission = json['submission'] != null
        ? new Submission.fromJson(json['submission'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question_set_id'] = this.questionSetId;
    data['title'] = this.title;
    data['question'] = this.question;
    data['subtitle'] = this.subtitle;
    data['image_url'] = this.imageUrl;
    data['image_caption'] = this.imageCaption;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    if (this.answerOption != null) {
      data['answer_option'] = this.answerOption!.toJson();
    }
    if (this.submission != null) {
      data['submission'] = this.submission!.toJson();
    }
    return data;
  }
}

class Options {
  int? id;
  String? optionType;
  String? title;
  Null? imageUrl;
  Null? voiceScript;
  Null? voiceGender;

  Options(
      {this.id,
        this.optionType,
        this.title,
        this.imageUrl,
        this.voiceScript,
        this.voiceGender});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    optionType = json['option_type'];
    title = json['title'];
    imageUrl = json['image_url'];
    voiceScript = json['voice_script'];
    voiceGender = json['voice_gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['option_type'] = this.optionType;
    data['title'] = this.title;
    data['image_url'] = this.imageUrl;
    data['voice_script'] = this.voiceScript;
    data['voice_gender'] = this.voiceGender;
    return data;
  }
}

class AnswerOption {
  int? id;
  int? questionId;
  int? questionOptionId;
  Null? description;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question_id'] = this.questionId;
    data['question_option_id'] = this.questionOptionId;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Submission {
  int? id;
  int? questionSetSubmissionsId;
  int? questionId;
  int? questionOptionId;
  Null? userResponse;
  String? createdAt;
  String? updatedAt;
  Option? option;

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
    json['option'] != null ? new Option.fromJson(json['option']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question_set_submissions_id'] = this.questionSetSubmissionsId;
    data['question_id'] = this.questionId;
    data['question_option_id'] = this.questionOptionId;
    data['user_response'] = this.userResponse;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.option != null) {
      data['option'] = this.option!.toJson();
    }
    return data;
  }
}

class Option {
  int? id;
  String? optionType;
  int? questionId;
  String? title;
  Null? subtitle;
  Null? imageUrl;
  Null? voiceScript;
  Null? voiceGender;
  String? createdAt;
  String? updatedAt;

  Option(
      {this.id,
        this.optionType,
        this.questionId,
        this.title,
        this.subtitle,
        this.imageUrl,
        this.voiceScript,
        this.voiceGender,
        this.createdAt,
        this.updatedAt});

  Option.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    optionType = json['option_type'];
    questionId = json['question_id'];
    title = json['title'];
    subtitle = json['subtitle'];
    imageUrl = json['image_url'];
    voiceScript = json['voice_script'];
    voiceGender = json['voice_gender'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['option_type'] = this.optionType;
    data['question_id'] = this.questionId;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['image_url'] = this.imageUrl;
    data['voice_script'] = this.voiceScript;
    data['voice_gender'] = this.voiceGender;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class ListeningQuestions {
  int? id;
  int? questionSetId;
  String? questionType;
  String? title;
  String? subtitle;
  String? imageUrl;
  String? imageCaption;
  String? voiceScript;
  String? voiceGender;
  List<dynamic>? dialogues;
  dynamic question;
  List<Options>? options;
  AnswerOption? answerOption;
  dynamic submission;

  ListeningQuestions(
      {this.id,
        this.questionSetId,
        this.questionType,
        this.title,
        this.subtitle,
        this.imageUrl,
        this.imageCaption,
        this.voiceScript,
        this.voiceGender,
        this.dialogues,
        this.question,
        this.options,
        this.answerOption,
        this.submission});

  ListeningQuestions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionSetId = json['question_set_id'];
    questionType = json['question_type'];
    title = json['title'];
    subtitle = json['subtitle'];
    imageUrl = json['image_url'];
    imageCaption = json['image_caption'];
    voiceScript = json['voice_script'];
    voiceGender = json['voice_gender'];
    // if (json['dialogues'] != null) {
    //   dialogues = <Null>[];
    //   json['dialogues'].forEach((v) {
    //     dialogues!.add(new Null.fromJson(v));
    //   });
    // }
    question = json['question'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
    answerOption = json['answer_option'] != null
        ? new AnswerOption.fromJson(json['answer_option'])
        : null;
    submission = json['submission'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question_set_id'] = this.questionSetId;
    data['question_type'] = this.questionType;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['image_url'] = this.imageUrl;
    data['image_caption'] = this.imageCaption;
    data['voice_script'] = this.voiceScript;
    data['voice_gender'] = this.voiceGender;
    if (this.dialogues != null) {
      data['dialogues'] = this.dialogues!.map((v) => v.toJson()).toList();
    }
    data['question'] = this.question;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    if (this.answerOption != null) {
      data['answer_option'] = this.answerOption!.toJson();
    }
    data['submission'] = this.submission;
    return data;
  }
}

