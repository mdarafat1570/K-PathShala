import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AudioPlaybackService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playCachedAudio(String cacheKey) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$cacheKey.mp3');

    if (file.existsSync()) {
      // Play the cached file
      await _audioPlayer.setSourceDeviceFile(file.path);
      await _audioPlayer.resume();
    } else {
      throw Exception('Audio file not found in cache');
    }
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  // Dispose the audio player
  void dispose() {
    _audioPlayer.dispose();
  }

  void listenForCompletion(VoidCallback onComplete) {
    _audioPlayer.onPlayerComplete.listen((event) {
      onComplete();
    });
  }
}
