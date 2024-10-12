class RetrieveNotebyIDUpdateModel {
  final int id;
  final String title;
  final String description;
  final int questionSetId;

  RetrieveNotebyIDUpdateModel({
    required this.id,
    required this.title,
    required this.description,
    required this.questionSetId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'question_set_id': questionSetId,
    };
  }
}
