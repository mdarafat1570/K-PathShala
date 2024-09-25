class QuestionPageModel {
  Data? data;

  QuestionPageModel({this.data});

  QuestionPageModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? duration;
  int? totalQuestion;
  List<ReadingQuestions>? readingQuestions;
  List<ListeningQuestions>? listeningQuestions;

  Data({this.duration, this.totalQuestion, this.readingQuestions, this.listeningQuestions});

  Data.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    totalQuestion = json['total_question'];
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
  int? id;
  int? questionSetId;
  String? title;
  String? question;
  String? subtitle;
  ImageUrl? imageUrl;
  List<Options>? options;

  ReadingQuestions({
    this.id,
    this.questionSetId,
    this.title,
    this.question,
    this.subtitle,
    this.imageUrl,
    this.options,
  });

  ReadingQuestions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionSetId = json['question_set_id'];
    title = json['title'];
    question = json['question'];
    subtitle = json['subtitle'];
    imageUrl = json['image_url'] != null ? ImageUrl.fromJson(json['image_url']) : null;
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question_set_id'] = questionSetId;
    data['title'] = title;
    data['question'] = question;
    data['subtitle'] = subtitle;
    if (imageUrl != null) {
      data['image_url'] = imageUrl!.toJson();
    }
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListeningQuestions {
  int? id;
  String? question;

  ListeningQuestions({this.id, this.question});

  ListeningQuestions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    return data;
  }
}

class ImageUrl {
  String? url;

  ImageUrl({this.url});

  ImageUrl.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    return data;
  }
}

class Options {
  int? id;
  String? optionType;
  String? title;

  Options({this.id, this.optionType, this.title});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    optionType = json['option_type'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['option_type'] = optionType;
    data['title'] = title;
    return data;
  }
}
