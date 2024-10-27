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

      int retryCount = 0;
      bool success = false;

      while (retryCount < 2 && !success) {
        try {
          Uint8List audioData = await _azureTTS.synthesizeSpeech(model.text, model.gender);

          if (isDisposed) {
            log('Page is disposed. Stopping the caching process before saving the file.');
            return;
          }

          await audioFile.writeAsBytes(audioData);
          log('Cached audio for: ${model.text}');
          success = true; // Mark as successful if no errors occur
        } catch (e) {
          retryCount++;
          if (retryCount < 2) {
            log('Failed to cache audio for "${model.text}", retrying... Attempt $retryCount');
          } else {
            log('Failed to cache audio for "${model.text}" after $retryCount attempts: $e');
          }
        }
      }

      if (!success) {
        log('Stopping caching for "${model.text}" after multiple failed attempts.');
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
  for (int i=1; i<=4; i++){
    cachedVoiceList.addAll([CachedVoiceModel(text: "Option $i", gender: "male"), CachedVoiceModel(text: "option $i", gender: "female")]);
  }

  for (var question in listeningQuestionList) {
    if (question.voiceScript != null) {
      log(question.voiceScript!);
      cachedVoiceList.add(CachedVoiceModel(
        text: question.voiceScript!,
        gender: question.voiceGender != null && question.voiceGender != '' ? question.voiceGender! : 'female',
      ));
    }
    if (question.imageCaption != null) {
      log(question.imageCaption!);
      cachedVoiceList.add(CachedVoiceModel(
        text: question.imageCaption!,
        gender: question.voiceGender != null && question.voiceGender != '' ? question.voiceGender! : 'female',
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


