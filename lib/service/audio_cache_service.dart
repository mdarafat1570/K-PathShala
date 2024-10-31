import 'dart:io';
import 'dart:typed_data';
import 'package:kpathshala/model/question_model/reading_question_page_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer';
import 'package:kpathshala/service/azure_tts_service.dart';

class AudioCacheService {
  final AzureTTS _azureTTS = AzureTTS();
  bool isDisposed = false;
  bool isLoading = false;

  Future<void> cacheAudioFiles({
    required List<CachedVoiceModel> cachedVoiceModelList,
  }) async {
    isLoading = true; // Start loading
    final Directory tempDir = await getTemporaryDirectory();

    // Prepare a list of futures for concurrent caching
    List<Future<void>> cachingTasks = cachedVoiceModelList.map((model) => _cacheSingleAudio(tempDir, model)).toList();

    // Wait for all caching tasks to complete
    await Future.wait(cachingTasks);
    isLoading = false; // End loading after all tasks complete
  }

  Future<void> _cacheSingleAudio(Directory tempDir, CachedVoiceModel model) async {
    if (isDisposed) {
      log('Page is disposed. Stopping the caching process.');
      return;
    }

    String fileName = "${model.voiceType}-${model.id}-${model.gender}";
    File audioFile = File('${tempDir.path}/$fileName.mp3');

    if (await audioFile.exists()) {
      log('Audio file for "${model.text}" is already cached.');
      return;
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
        log("filename: $fileName");
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

  Future<void> clearCache({required bool isCachingDisposed}) async {
    isDisposed = isCachingDisposed;
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


List<CachedVoiceModel> extractCachedVoiceModels({
  required List<ListeningQuestions> listeningQuestionList,
}) {
  List<CachedVoiceModel> cachedVoiceList = [];

  // Add predefined Korean options
  final koreanTexts = ['일', '이', '삼', '사'];
  for (int i = 1; i <= koreanTexts.length; i++) {
    String koreanText = koreanTexts[i - 1];
    cachedVoiceList.addAll([
      CachedVoiceModel(text: koreanText, gender: "male", id: "-1$i", voiceType: 'option'),
      CachedVoiceModel(text: koreanText, gender: "female", id: "-2$i", voiceType: 'option'),
    ]);
  }

  // Helper to add CachedVoiceModel with a check
  void addVoiceModel(String? text, String gender, String voiceType, String id) {
    if (text != null && text.isNotEmpty) {
      cachedVoiceList.add(CachedVoiceModel(text: text, gender: gender, voiceType: voiceType, id: id));
      log(text);
    }
  }

  // Iterate through questions and add relevant CachedVoiceModels
  for (var question in listeningQuestionList) {
    String questionGender = question.voiceGender?.isNotEmpty == true ? question.voiceGender! : 'female';
    String questionId = question.id.toString();

    addVoiceModel(question.voiceScript, questionGender, 'question', questionId);
    addVoiceModel(question.imageCaption, questionGender, 'image_caption', questionId);

    // Add dialogues with sequence-questionId as ID
    for (var dialogue in question.dialogues) {
      if (dialogue.voiceGender != null) {
        addVoiceModel(dialogue.voiceScript, dialogue.voiceGender!, 'dialogue', "${dialogue.sequence}-$questionId");
      }
    }

    // Add options based on type and gender
    for (var option in question.options) {
      String optionId = option.id.toString();
      if (option.optionType == 'text_with_voice' && option.voiceGender != null) {
        addVoiceModel(option.title, option.voiceGender!, "option", optionId);
      } else if (option.voiceScript != null && option.voiceGender != null) {
        addVoiceModel(option.voiceScript, option.voiceGender!, "option", optionId);
      }
    }
  }

  return cachedVoiceList;
}

class CachedVoiceModel {
  String text;
  String gender;
  String voiceType;
  String id;

  CachedVoiceModel({required this.text, required this.gender, required this.voiceType, required this.id});
}


