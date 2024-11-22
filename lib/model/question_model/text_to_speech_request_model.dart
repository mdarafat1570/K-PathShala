class TextToSpeechRequestModel {
  int? questionId;
  String? questionType;
  int? optionId;
  String? dialogueSequence;
  String? announceNumber;

  TextToSpeechRequestModel(
      {this.questionId,
        this.questionType,
        this.optionId,
        this.dialogueSequence,
        this.announceNumber});

  TextToSpeechRequestModel.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    questionType = json['question_type'];
    optionId = json['option_id'];
    dialogueSequence = json['dialogue_sequence'];
    announceNumber = json['announce_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question_id'] = questionId;
    data['question_type'] = questionType;
    data['option_id'] = optionId;
    data['dialogue_sequence'] = dialogueSequence;
    data['announce_number'] = announceNumber;
    return data;
  }
}
