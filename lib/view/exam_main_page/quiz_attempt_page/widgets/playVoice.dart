import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kpathshala/app_theme/app_color.dart';

class PlayVoice extends StatefulWidget {
  final double size;
  final String? script;
  final String? model;
  const PlayVoice({super.key, required this.size, this.model = "female", this.script = ""});

  @override
  State<PlayVoice> createState() => _PlayVoiceState();
}

class _PlayVoiceState extends State<PlayVoice> {
  late FlutterTts flutterTts;
  String? selectedLanguage;
  String? selectedEngine;
  String? selectedVoice;
  List<dynamic> availableVoices = [];
  String? _newVoiceText;

  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;

  @override
  void initState() {
    super.initState();
    initTts();
    _newVoiceText = widget.script;
  }

  // Initialize TTS with default settings
  Future<void> initTts() async {
    flutterTts = FlutterTts();

    // Set defaults (Korean language, Google TTS engine)
    await flutterTts.setLanguage("ko-KR");
    await flutterTts.setEngine("com.google.android.tts");

    _getVoices();
  }

  Future<void> _getVoices() async {
    List<dynamic> voices = await flutterTts.getVoices as List<dynamic>;

    // Filter only Korean voices
    setState(() {
      availableVoices = voices.where((voice) {
        // Check if the voice is a Map and has the correct keys
        if (voice is Map && voice.containsKey('locale') && voice.containsKey('name')) {
          return voice['locale'] == 'ko-KR';
        }
        return false;
      }).map((voice) {
        // Ensure the map is correctly typed
        return {
          'name': voice['name'] as String,
          'locale': voice['locale'] as String,
        } as Map<String, String>;
      }).toList();

      // Set default voice if available
      selectedVoice = availableVoices.isNotEmpty ? availableVoices[0]['name'] : null;
    });
  }


  Future<void> _speak() async {
    if (_newVoiceText == null || _newVoiceText!.isEmpty) {
      print("No text provided for speech.");
      return;
    }

    await flutterTts.setVolume(volume);
    await flutterTts.setPitch(pitch);
    await flutterTts.setSpeechRate(rate);

    if (widget.model == "female"){
      selectedVoice = "ko-kr-x-ism-local";
    } else {
      selectedVoice = "ko-kr-x-kod-local";
    }

    if (selectedVoice != null) {
      // Safely retrieve the voice map
      Map<String, String>? voice = availableVoices.firstWhere(
            (v) => v['name'] == selectedVoice,
        orElse: () => {'name': '', 'locale': ''}, // Return a default map instead of null
      ) as Map<String, String>?; // Ensure the correct type

      if (voice != null && voice['name']!.isNotEmpty) {
        await flutterTts.setVoice(voice);
        print("Using voice: ${voice['name']}");
      } else {
        print("Selected voice not found.");
        return;
      }
    }

    print("Speaking: $_newVoiceText");
    await flutterTts.speak(_newVoiceText!);
  }


  // Future<void> _stop() async {
  //   await flutterTts.stop();
  // }
  //
  // Future<void> _pause() async {
  //   await flutterTts.pause();
  // }
  //
  // void _onTextChanged(String text) {
  //   setState(() {
  //     _newVoiceText = text;
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: InkWell(
        onTap: _speak,
        child: Image.asset("assets/speaker.png",height: 40, color: AppColor.navyBlue,),
      ),
    );
  }
}
