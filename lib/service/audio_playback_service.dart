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
  String? currentPlayingAudioId;
  String? nextAudioKey;

  Future<void> playAudioQueue(List<String> audioKeys) async {
    // Stop any currently playing queue and reset state
    await stop();

    _audioQueue = List.from(audioKeys);
    _shouldStop = false;
    _isPlaying = true; // Set isPlaying to true for the entire queue duration

    for (int i = 0; i < _audioQueue.length; i++) {
      if (_shouldStop) break; // Exit loop if playback is stopped

      currentPlayingAudioId = _audioQueue[i];
      nextAudioKey = (i + 1 < _audioQueue.length) ? _audioQueue[i + 1] : null;

      await _playSingleAudio(currentPlayingAudioId!);

      // Delay between audios
      if (!_shouldStop) {
        await Future.delayed(const Duration(milliseconds: 300));
      }
    }

    // Reset when queue is finished or stopped
    currentPlayingAudioId = null;
    nextAudioKey = null;
    _isPlaying = false; // Only set isPlaying to false after the entire queue has finished
  }

  Future<void> _playSingleAudio(String cacheKey) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$cacheKey.mp3');

    if (file.existsSync()) {
      _audioPlayer.setVolume(_volume);
      await _audioPlayer.setSourceDeviceFile(file.path);
      await _audioPlayer.setPlaybackRate(_speed);
      await _audioPlayer.resume();

      await _audioPlayer.onPlayerComplete.first;
    } else {
      throw Exception('Audio file not found in cache');
    }
  }

  Future<void> stop() async {
    _shouldStop = true;
    _audioQueue.clear();
    await _audioPlayer.stop();
    currentPlayingAudioId = null;
    _isPlaying = false; // Also set isPlaying to false immediately if stop is called
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
