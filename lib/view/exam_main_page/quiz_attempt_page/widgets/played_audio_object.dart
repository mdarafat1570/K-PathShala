class PlayedAudios {
  // Properties
  final String audioType;
  final int audioId;

  // Constructor
  PlayedAudios({
    required this.audioType,
    required this.audioId,
  });

  // Override toString for easier debugging
  @override
  String toString() {
    return 'PlayedAudios(audioType: $audioType, audioId: $audioId)';
  }
}