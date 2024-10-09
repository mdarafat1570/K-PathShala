import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kpathshala/api/api_container.dart';
import 'package:kpathshala/authentication/base_repository.dart';
import 'package:kpathshala/model/notes_model/retrieve_noteby_ID_model.dart';
import 'package:kpathshala/model/notes_model/retrieve_notes_model_all_list.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NoteRepository {
    final BaseRepository _baseRepository = BaseRepository();

  final String baseUrl =
      '${KpatshalaRetrieveNotesQuestion.RetrieveNotesQuestion}';

Future<NoteGetModel> fetchNotes({
  required int questionSetId,
  required BuildContext context,
}) async {
  try {
    final url = '${KpatshalaRetrieveNotesQuestion.RetrieveNotesQuestion}?questionSetId=$questionSetId';
    final response = await _baseRepository.getRequest(url, context: context);
    final noteDataModel = NoteGetModel.fromJson(response);
    log(jsonEncode(noteDataModel));
    return noteDataModel; 
  } catch (e) {
    if (e.toString().contains('401')) {
      throw Exception('Unauthorized: Invalid or missing Bearer Token.');
    } else if (e.toString().contains('404')) {
      throw Exception('Not Found: The specified package ID does not exist.');
    } else {
      throw Exception(
          'Server Error: An error occurred while processing the request.');
    }
  }
}


  Future<void> addNote(RetrieveNotebyIDModel note, BuildContext context) async {
    await _baseRepository.postRequest(
      baseUrl,
      note.toJson(),
      context: context,
    );
  }

  Future<void> updateNote(
      RetrieveNotebyIDModel note, BuildContext context) async {
    await _baseRepository.putRequest(
      '$baseUrl/${note.id}',
      note.toJson(),
      context: context,
    );
  }

  Future<void> deleteNote(int noteId, BuildContext context) async {
    await _baseRepository.deleteRequest(
      '$baseUrl/$noteId',
      context: context,
    );
  }
}
