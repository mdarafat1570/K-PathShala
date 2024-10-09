import 'package:flutter_tts/flutter_tts.dart';
import 'dart:developer';

class TtsService {
  late FlutterTts flutterTts;
  bool isSpeaking = false;
  bool isInDelay = false;
  bool firstSpeechCompleted = false;
  String? selectedVoice;
  String? _newVoiceText;
  List<Map<String, String>> availableVoices = [];
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;

  TtsService() {
    initTts();
  }

  Future<void> initTts() async {
    flutterTts = FlutterTts();
    await flutterTts.setLanguage("ko-KR");
    await flutterTts.setEngine("com.google.android.tts");
    await flutterTts.setVolume(volume);
    await flutterTts.setPitch(pitch);
    await flutterTts.setSpeechRate(rate);
    await _getVoices();
  }

  Future<void> _getVoices() async {
    List<dynamic> voices = await flutterTts.getVoices as List<dynamic>;
    availableVoices = voices.where((voice) {
      if (voice is Map &&
          voice.containsKey('locale') &&
          voice.containsKey('name')) {
        return voice['locale'] == 'ko-KR';
      }
      return false;
    }).map((voice) {
      return {
        'name': voice['name'] as String,
        'locale': voice['locale'] as String,
      };
    }).toList();
    selectedVoice = availableVoices.isNotEmpty ? availableVoices[0]['name'] : null;
  }

  Future<void> speak(String? model, String voiceScript, {bool? isDialogue = false}) async {
    _newVoiceText = voiceScript;

    if (_newVoiceText == null || _newVoiceText!.isEmpty) {
      log("No text provided for speech.");
      return;
    }

    selectedVoice = (model == "female" || model == null)
        ? "ko-kr-x-ism-local"
        : "ko-kr-x-kod-local";

    Map<String, String>? voice = availableVoices.firstWhere(
          (v) => v['name'] == selectedVoice,
      orElse: () => {'name': '', 'locale': ''},
    );

    if (voice['name']!.isNotEmpty) {
      await flutterTts.setVoice(voice);
      log("Using voice: ${voice['name']}");
    } else {
      log("Selected voice not found.");
      return;
    }

    if (isSpeaking || isInDelay) {
      log("Audio is already playing or in delay. Ignoring click.");
      return;
    }

    isInDelay = true;

    await flutterTts.speak(_newVoiceText!);

    await Future.delayed(const Duration(seconds: 3));

    if (firstSpeechCompleted && !isDialogue!) {
      await flutterTts.speak(_newVoiceText!);
    }

    isInDelay = false;
  }

  Future<void> stopSpeaking() async {
    if (isSpeaking || isInDelay) {
      await flutterTts.stop();
      firstSpeechCompleted = false;
      log("Speech stopped");
    }
  }

  void initializeTtsHandlers() {
    flutterTts.setStartHandler(() {
      log("Speech started");
      isSpeaking = true;
    });

    flutterTts.setCompletionHandler(() {
      log("Speech completed");
      isSpeaking = false;
      firstSpeechCompleted = true;
    });

    flutterTts.setCancelHandler(() {
      log("Speech canceled");
      isSpeaking = false;
    });

    flutterTts.setErrorHandler((msg) {
      log("An error occurred: $msg");
      isSpeaking = false;
    });
  }

  void dispose() {
    flutterTts.stop();

    flutterTts.setStartHandler(() {});
    flutterTts.setCompletionHandler(() {});
    flutterTts.setCancelHandler(() {});
    flutterTts.setErrorHandler((dynamic error) {});

  }

}
