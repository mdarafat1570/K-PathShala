import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

class AudioPlaybackService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final double _speed = 1.0;
  final double _volume = 1.0;

  List<String> _audioQueue = [];
  bool _isPlaying = false;
  bool _shouldStop = false;

  String? currentPlayingAudioId; // To store the extracted ID

  Future<void> playAudioQueue(List<String> audioKeys) async {
    _audioQueue = List.from(audioKeys);
    _shouldStop = false;

    await _playNextAudio();
  }

  Future<void> _playNextAudio() async {
    if (_audioQueue.isEmpty || _shouldStop) {
      currentPlayingAudioId = null; // Reset when queue is empty or stopped
      return;
    }

    String nextAudioKey = _audioQueue.removeAt(0);
    currentPlayingAudioId = nextAudioKey; // Extract ID and assign
    await _playSingleAudio(nextAudioKey);

    if (_audioQueue.isNotEmpty && !_shouldStop) {
      for (int i = 0; i < 5; i++) {
        await Future.delayed(const Duration(milliseconds: 100));
        if (_shouldStop) {
          currentPlayingAudioId = null; // Reset if stopped
          return;
        }
      }

      await _playNextAudio();
    }
  }

  Future<void> _playSingleAudio(String cacheKey) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$cacheKey.mp3');

    if (file.existsSync()) {
      _isPlaying = true;
      _audioPlayer.setVolume(_volume);
      await _audioPlayer.setSourceDeviceFile(file.path);
      await _audioPlayer.setPlaybackRate(_speed);
      await _audioPlayer.resume();

      await _audioPlayer.onPlayerComplete.first;
      _isPlaying = false;
      currentPlayingAudioId = null; // Clear after completion
    } else {
      throw Exception('Audio file not found in cache');
    }
  }

  Future<void> stop() async {
    _shouldStop = true;
    _audioQueue.clear();
    await _audioPlayer.stop();
    currentPlayingAudioId = null; // Clear when stopped
  }

  void dispose() {
    _audioPlayer.dispose();
  }

  String? getCurrentPlayingAudioId() {
    return currentPlayingAudioId;
  }

  bool isPlaying() {
    return _isPlaying;
  }
}
