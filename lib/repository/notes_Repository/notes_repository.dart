import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kpathshala/api/api_container.dart';
import 'package:kpathshala/authentication/base_repository.dart';
import 'package:kpathshala/model/notes_model/retrieve_noteby_ID_model.dart';
import 'package:kpathshala/model/notes_model/retrieve_notes_model_all_list.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NoteRepository extends BaseRepository {
  final String baseUrl =
      '${KpatshalaRetrieveNotesQuestion.RetrieveNotesQuestion}';

  Future<void> fetchNotes(int questionId, BuildContext context) async {
    try {
      final response = await getRequest(
        '$baseUrl?questionSetId=$questionId',
        context: context,
      );

      List<dynamic> notesJson = response['question_notes'];
      List<QuestionNotes> questionNotes =
          notesJson.map((note) => QuestionNotes.fromJson(note)).toList();
      log(jsonEncode(questionNotes));
      if (notesJson.isNotEmpty) {
        final videoLink = notesJson[0]['video_link'];
        String? videoId = YoutubePlayer.convertUrlToId(videoLink);
        if (videoId != null) {
          YoutubePlayerController _youtubeController = YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching notes: $e")),
      );
    }
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
