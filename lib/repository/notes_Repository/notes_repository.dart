import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kpathshala/api/api_container.dart';
import 'package:kpathshala/authentication/base_repository.dart';
import 'package:kpathshala/model/notes_model/RetrieveNotebyIDModel.dart';
import 'package:kpathshala/model/notes_model/note_video_model.dart';
import 'package:kpathshala/model/notes_model/retrieve_noteby_ID_model.dart';
import 'package:kpathshala/model/notes_model/retrieve_notes_model_all_list.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NoteRepository {
    final BaseRepository _baseRepository = BaseRepository();

  final String baseUrl =
      '${KpatshalaRetrieveNotesQuestion.retrieveNotesQuestion}';

Future<NoteGetModel> fetchNotes({
  required int questionSetId,
  required BuildContext context,
}) async {
  try {
    final url = '${KpatshalaRetrieveNotesQuestion.retrieveNotesQuestion}?questionSetId=$questionSetId';
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

Future<NoteVideoModel> fetchNotesVideo({
  required int questionSetId,
  required BuildContext context,
}) async {
  try {
    final url = '${KpatshalaRetrieveNotesQuestion.retrieveNotesVideo}?questionSetId=$questionSetId';
    final response = await _baseRepository.getRequest(url, context: context);
    final noteDataVideoModel = NoteVideoModel.fromJson(response);
    log(jsonEncode(noteDataVideoModel));
    return noteDataVideoModel; 
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

Future<void> updateNote(RetrieveNotebyIDUpdateModel note, BuildContext context) async {
  try {
    final url = '$baseUrl/${note.id}'; 
    final response = await _baseRepository.putRequest(
      url,
      note.toJson(),
      context: context,
    );

 
    if (response['status'] == 'success') {
      log('Note updated successfully: ${jsonEncode(response['data'])}');
    } else {
      throw Exception('Failed to update note');
    }
  } catch (e) {
    if (e.toString().contains('401')) {
      throw Exception('Unauthorized: Invalid or missing Bearer Token.');
    } else if (e.toString().contains('404')) {
      throw Exception('Note not found.');
    } else {
      throw Exception('Server Error: Unable to update the note.');
    }
  }
}


   Future<void> deleteNote(int noteId, BuildContext context) async {
    try {
      final response = await _baseRepository.deleteRequest(
        '$baseUrl/$noteId',
        context: context,
      );
      if (response['status'] == 'success') {
        log('Note deleted successfully');
      } else {
        throw Exception('Failed to delete the note');
      }
    } catch (e) {
      if (e.toString().contains('401')) {
        throw Exception('Unauthorized: Invalid or missing Bearer Token.');
      } else if (e.toString().contains('404')) {
        throw Exception('Note not found.');
      } else {
        throw Exception('Server Error: Unable to delete the note.');
      }
    }
  }
}
