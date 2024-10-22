import 'dart:io';
import 'dart:typed_data';
import 'package:kpathshala/model/question_model/reading_question_page_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer';
import 'package:kpathshala/service/azure_tts_service.dart';

class AudioCacheService {
  final AzureTTS _azureTTS = AzureTTS();

  // Cache the audio files
  Future<void> cacheAudioFiles({required List<CachedVoiceModel> cachedVoiceModelList}) async {
    final Directory tempDir = await getTemporaryDirectory();

    for (CachedVoiceModel model in cachedVoiceModelList) {
      // String fileName = generateFileName(model.text);
      String fileName = model.text;

      File audioFile = File('${tempDir.path}/$fileName.mp3');
      if (await audioFile.exists()) {
        log('Audio file for "${model.text}" is already cached.');
        continue;
      }

      try {
        Uint8List audioData = await _azureTTS.synthesizeSpeech(model.text, model.gender);

        await audioFile.writeAsBytes(audioData);
        log('Cached audio for: ${model.text}');
      } catch (e) {
        log('Failed to cache audio for "${model.text}": $e');
      }
    }
  }

  // Generate a file name based on the text
  // String generateFileName(String text) {
  //   String cleanText = text.replaceAll(RegExp(r'[^\w\s]+'), '').replaceAll(' ', '_');
  //
  //   String uniqueIdentifier = text.hashCode.toString();
  //
  //   return '${cleanText}_$uniqueIdentifier';
  // }


  // Clear the cached audio files
  Future<void> clearCache() async {
    final Directory tempDir = await getTemporaryDirectory();

    // List all files in the temporary directory
    List<FileSystemEntity> files = tempDir.listSync();

    // Remove all cached audio files (.mp3)
    for (var file in files) {
      if (file is File && file.path.endsWith('.mp3')) {
        await file.delete();
        log('Deleted cached audio file: ${file.path}');
      }
    }
  }

  // Fetch the cached audio file if it exists
  Future<File?> getCachedAudio(String text) async {
    final Directory tempDir = await getTemporaryDirectory();
    // String fileName = generateFileName(text);
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
    // Add voice script and gender from the ListeningQuestions model itself
    if (question.voiceScript != null && question.voiceGender != null) {
      log(question.voiceScript!);
      cachedVoiceList.add(CachedVoiceModel(
        text: question.voiceScript!,
        gender: question.voiceGender!,
      ));
    }

    // Add voice script and gender from dialogues
    for (var dialogue in question.dialogues) {
      if (dialogue.voiceScript != null && dialogue.voiceGender != null) {
        log(dialogue.voiceScript!);
        cachedVoiceList.add(CachedVoiceModel(
          text: dialogue.voiceScript!,
          gender: dialogue.voiceGender!,
        ));
      }
    }

    // Add voice script and gender from options
    for (var option in question.options) {
      if (option.voiceScript != null && option.voiceGender != null) {
        log(option.voiceScript!);
        cachedVoiceList.add(CachedVoiceModel(
          text: option.voiceScript!,
          gender: option.voiceGender!,
        ));
      }
    }
  }
  log("-----------------${cachedVoiceList.length} number of texts");

  return cachedVoiceList;
}


class CachedVoiceModel {
  String text;
  String gender;

  CachedVoiceModel({required this.text, required this.gender});
}


