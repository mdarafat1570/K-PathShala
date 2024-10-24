import 'dart:io';
import 'dart:typed_data';
import 'package:kpathshala/model/question_model/reading_question_page_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer';
import 'package:kpathshala/service/azure_tts_service.dart';

class AudioCacheService {
  final AzureTTS _azureTTS = AzureTTS();

  Future<void> cacheAudioFiles({
    required List<CachedVoiceModel> cachedVoiceModelList,
    required bool isDisposed,
  }) async {
    final Directory tempDir = await getTemporaryDirectory();

    for (CachedVoiceModel model in cachedVoiceModelList) {
      if (isDisposed) {
        log('Page is disposed. Stopping the caching process.');
        return;
      }

      String fileName = model.text;

      File audioFile = File('${tempDir.path}/$fileName.mp3');
      if (await audioFile.exists()) {
        log('Audio file for "${model.text}" is already cached.');
        continue;
      }

      try {
        Uint8List audioData = await _azureTTS.synthesizeSpeech(model.text, model.gender);

        if (isDisposed) {
          log('Page is disposed. Stopping the caching process before saving the file.');
          return;
        }

        await audioFile.writeAsBytes(audioData);
        log('Cached audio for: ${model.text}');
      } catch (e) {
        log('Failed to cache audio for "${model.text}": $e');
      }
    }
  }

  Future<void> clearCache() async {
    final Directory tempDir = await getTemporaryDirectory();

    List<FileSystemEntity> files = tempDir.listSync();
    for (var file in files) {
      if (file is File && file.path.endsWith('.mp3')) {
        await file.delete();
        log('Deleted cached audio file: ${file.path}');
      }
    }
  }

  Future<File?> getCachedAudio(String text) async {
    final Directory tempDir = await getTemporaryDirectory();
    String fileName = text;
    File audioFile = File('${tempDir.path}/$fileName.mp3');

    if (await audioFile.exists()) {
      return audioFile;
    } else {
      log('No cached audio found for "$text".');
      return null;
    }
  }
}

List<CachedVoiceModel> extractCachedVoiceModels(
    {required List<ListeningQuestions> listeningQuestionList}) {
  List<CachedVoiceModel> cachedVoiceList = [];

  for (var question in listeningQuestionList) {
    if (question.voiceScript != null && question.voiceGender != null) {
      log(question.voiceScript!);
      cachedVoiceList.add(CachedVoiceModel(
        text: question.voiceScript!,
        gender: question.voiceGender!,
      ));
    }

    for (var dialogue in question.dialogues) {
      if (dialogue.voiceScript != null && dialogue.voiceScript != ''  && dialogue.voiceGender != null) {
        log(dialogue.voiceScript!);
        cachedVoiceList.add(CachedVoiceModel(
          text: dialogue.voiceScript!,
          gender: dialogue.voiceGender!,
        ));
      }
    }

    for (var option in question.options) {
      if (option.voiceScript != null && option.voiceScript != '' && option.voiceGender != null) {
        log(option.voiceScript!);
        cachedVoiceList.add(CachedVoiceModel(
          text: option.voiceScript!,
          gender: option.voiceGender!,
        ));
      } else if (option.optionType == 'text_with_voice' && option.voiceGender != null){
        log(option.title!);
        cachedVoiceList.add(CachedVoiceModel(
          text: option.title!,
          gender: option.voiceGender!,
        ));
      }
    }
  }
  return cachedVoiceList;
}


class CachedVoiceModel {
  String text;
  String gender;

  CachedVoiceModel({required this.text, required this.gender});
}


