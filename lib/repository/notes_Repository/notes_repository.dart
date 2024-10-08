import 'package:flutter/material.dart';
import 'package:kpathshala/api/api_container.dart';
import 'package:kpathshala/authentication/base_repository.dart';
import 'package:kpathshala/model/notes_model/retrieve_noteby_ID_model.dart';

class NoteRepository extends BaseRepository {
  final String baseUrl =
      '${KpatshalaRetrieveNotesQuestion.RetrieveNotesQuestion}';

  Future<List<RetrieveNotebyIDModel>> fetchNotes(BuildContext context) async {
    final response = await getRequest(
      baseUrl,
      context: context,
    );

    final List<dynamic> data = response['data'];
    return data.map((note) => RetrieveNotebyIDModel.fromJson(note)).toList();
  }

  Future<void> addNote(RetrieveNotebyIDModel note, BuildContext context) async {
    await postRequest(
      baseUrl,
      note.toJson(),
      context: context,
    );
  }

  Future<void> updateNote(
      RetrieveNotebyIDModel note, BuildContext context) async {
    await putRequest(
      '$baseUrl/${note.id}',
      note.toJson(),
      context: context,
    );
  }

  Future<void> deleteNote(int noteId, BuildContext context) async {
    await deleteRequest(
      '$baseUrl/$noteId',
      context: context,
    );
  }
}
