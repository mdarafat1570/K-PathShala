class QuestionsModel {
  String? status;
  Data? data;
  String? message;

  QuestionsModel({this.status, this.data, this.message});

  QuestionsModel.fromJson(Map<String, dynamic> json) {
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
  int? totalQuestion;
  List<ReadingQuestions>? readingQuestions;
  // List<Null>? listeningQuestions;

  Data(
      {this.duration,
        this.totalQuestion,
        this.readingQuestions,
        // this.listeningQuestions
      });

  Data.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    totalQuestion = json['total_question'];
    if (json['reading_questions'] != null) {
      readingQuestions = <ReadingQuestions>[];
      json['reading_questions'].forEach((v) {
        readingQuestions!.add(new ReadingQuestions.fromJson(v));
      });
    }
    // if (json['listening_questions'] != null) {
    //   listeningQuestions = <Null>[];
    //   json['listening_questions'].forEach((v) {
    //     listeningQuestions!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['duration'] = this.duration;
    data['total_question'] = this.totalQuestion;
    if (this.readingQuestions != null) {
      data['reading_questions'] =
          this.readingQuestions!.map((v) => v.toJson()).toList();
    }
    // if (this.listeningQuestions != null) {
    //   data['listening_questions'] =
    //       this.listeningQuestions!.map((v) => v.toJson()).toList();
    // }
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

  ReadingQuestions(
      {this.id,
        this.questionSetId,
        this.title,
        this.question,
        this.subtitle,
        this.imageUrl,
        this.imageCaption,
        this.options});

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
    return data;
  }
}

class Options {
  int? id;
  String? optionType;
  String? title;
  Null? subtitle;
  Null? imageUrl;
  Null? voiceScript;
  Null? voiceGender;

  Options(
      {this.id,
        this.optionType,
        this.title,
        this.subtitle,
        this.imageUrl,
        this.voiceScript,
        this.voiceGender});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    optionType = json['option_type'];
    title = json['title'];
    subtitle = json['subtitle'];
    imageUrl = json['image_url'];
    voiceScript = json['voice_script'];
    voiceGender = json['voice_gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['option_type'] = this.optionType;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['image_url'] = this.imageUrl;
    data['voice_script'] = this.voiceScript;
    data['voice_gender'] = this.voiceGender;
    return data;
  }
}