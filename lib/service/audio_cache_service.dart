import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:kpathshala/service/azure_tts_service.dart';
import 'package:path_provider/path_provider.dart';

class AudioCacheService {
  final AzureTTS _azureTTS = AzureTTS();

  Future<void> cacheAudioFiles({required List<CachedVoiceModel> cachedVoiceModelList}) async {
    final Directory tempDir = await getTemporaryDirectory();

    for (CachedVoiceModel model in cachedVoiceModelList) {
      String fileName = _generateFileName(model.text);

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

  String _generateFileName(String text) {
    return text.replaceAll(RegExp(r'[^\w\s]+'), '').replaceAll(' ', '_');
  }

  Future<File?> getCachedAudio(String text) async {
    final Directory tempDir = await getTemporaryDirectory();
    String fileName = _generateFileName(text);
    File audioFile = File('${tempDir.path}/$fileName.mp3');

    if (await audioFile.exists()) {
      return audioFile;
    } else {
      log('No cached audio found for "$text".');
      return null;
    }
  }
}

class CachedVoiceModel {
  String text;
  String gender;

  CachedVoiceModel({required this.text, required this.gender});
}


