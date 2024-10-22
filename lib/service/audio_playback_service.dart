import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AudioPlaybackService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final double _speed = 1.0;
  final double _volume = 1.0;

  PlayerState _currentState = PlayerState.stopped;

  AudioPlaybackService() {
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      _currentState = state;
    });
  }

  Future<void> playCachedAudio(String cacheKey) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$cacheKey.mp3');

    if (file.existsSync()) {
      _audioPlayer.setVolume(_volume);
      await _audioPlayer.setSourceDeviceFile(file.path);
      await _audioPlayer.setPlaybackRate(_speed);
      await _audioPlayer.resume();
    } else {
      throw Exception('Audio file not found in cache');
    }
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  void dispose() {
    _audioPlayer.dispose();
  }

  void listenForCompletion(VoidCallback onComplete) {
    _audioPlayer.onPlayerComplete.listen((event) {
      onComplete();
    });
  }

  bool isPlaying() {
    return _currentState == PlayerState.playing;
  }
}
