import '../../quiz_attempt_page_imports.dart';

Widget buildOptionsList({
  required BuildContext context,
  required List<Options> options,
  required int selectedSolvedIndex,
  int? correctAnswerId,
  int? submissionId,
  required bool isTextType,
  required bool isVoiceType,
  required bool isTextWithVoice,
  required bool isSpeaking,
  required bool isInReviewMode,
  required List<PlayedAudios> playedAudiosList,
  required Function(int, int) selectionHandling,
  required Function(List<String>) speak,
  required Function() stopSpeaking,
  ListeningQuestions? selectedListeningQuestionData,
}) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: options.length,
    itemBuilder: (context, index) {
      String answer = options[index].title ?? '';
      int answerId = options[index].id ?? -1;
      String voiceScript = options[index].voiceScript ?? '';
      bool optionExists = playedAudiosList.any(
        (audio) => audio.audioId == answerId && audio.audioType == 'option',
      );

      Color containerColor = isInReviewMode
          ? (correctAnswerId == answerId && submissionId == answerId
              ? Colors.green.withOpacity(0.5)
              : correctAnswerId == answerId
                  ? Colors.green.withOpacity(0.5)
                  : submissionId == answerId
                      ? Colors.red.withOpacity(0.5)
                      : Colors.white.withOpacity(0.5))
          : Colors.transparent;

      return Container(
        padding: const EdgeInsets.all(6),
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: containerColor, borderRadius: BorderRadius.circular(8)),
        child: InkWell(
          onTap: isInReviewMode
              ? null
              : () {
                  selectionHandling(index, answerId);
                },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildOptionCircle(index, selectedSolvedIndex),
              const SizedBox(width: 8),
              if (answer.isNotEmpty && isTextType)
                Expanded(
                  child: Text(
                    answer,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              if (voiceScript.isNotEmpty && isVoiceType)
                _buildVoiceIcon(
                  context: context,
                  optionExists: optionExists,
                  isSpeaking: isSpeaking,
                  voiceScript: voiceScript,
                  answerId: answerId,
                  playedAudiosList: playedAudiosList,
                  speak: speak,
                  stopSpeaking: stopSpeaking,
                  selectedListeningQuestionData: selectedListeningQuestionData,
                ),
              if (isTextWithVoice && answer.isNotEmpty)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildVoiceIcon(
                        context: context,
                        optionExists: optionExists,
                        isSpeaking: isSpeaking,
                        voiceScript: answer,
                        answerId: answerId,
                        playedAudiosList: playedAudiosList,
                        speak: speak,
                        stopSpeaking: stopSpeaking,
                        selectedListeningQuestionData: selectedListeningQuestionData,
                      ),
                      const Gap(5),
                      Expanded(
                        child: Text(
                          answer,
                          style: const TextStyle(fontSize: 18),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}

Widget buildOptionsGrid({
  required BuildContext context,
  required List<Options> options,
  required int selectedSolvedIndex,
  int? correctAnswerId,
  int? submissionId,
  required bool isInReviewMode,
  required Function(int, int) selectionHandling,
  required Function(BuildContext, String, Map<String, Uint8List>)
      showZoomedImage,
  required Map<String, Uint8List> cachedImages,
}) {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 1,
    ),
    itemCount: options.length,
    itemBuilder: (context, index) {
      return _buildGridItem(
        context,
        options[index],
        index,
        selectedSolvedIndex,
        correctAnswerId,
        submissionId,
        isInReviewMode,
        selectionHandling,
        showZoomedImage,
        cachedImages,
      );
    },
  );
}

Widget _buildGridItem(
  BuildContext context,
  Options option,
  int index,
  int selectedSolvedIndex,
  int? correctAnswerId,
  int? submissionId,
  bool isInReviewMode,
  Function(int, int) selectionHandling,
  Function(BuildContext, String, Map<String, Uint8List>) showZoomedImage,
  Map<String, Uint8List> cachedImages,
) {
  String answerImage = option.imageUrl ?? "";
  int answerId = option.id ?? -1;
  Color containerColor = isInReviewMode
      ? (correctAnswerId == answerId && submissionId == answerId
          ? Colors.green.withOpacity(0.5)
          : correctAnswerId == answerId
              ? Colors.green.withOpacity(0.5)
              : submissionId == answerId
                  ? Colors.red.withOpacity(0.5)
                  : Colors.white.withOpacity(0.5))
      : Colors.transparent;

  return Container(
    padding: const EdgeInsets.all(6),
    margin: const EdgeInsets.all(2),
    decoration: BoxDecoration(
        color: containerColor, borderRadius: BorderRadius.circular(8)),
    child: InkWell(
      onTap: isInReviewMode
          ? null
          : () {
              selectionHandling(index, answerId);
            },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildOptionCircle(index, selectedSolvedIndex),
          const SizedBox(width: 8),
          if (answerImage.isNotEmpty)
            Expanded(
              child: InkWell(
                onTap: () {
                  showZoomedImage(context, answerImage, cachedImages);
                },
                child: _buildImage(answerImage, cachedImages),
              ),
            ),
        ],
      ),
    ),
  );
}

Widget _buildImage(String imageUrl, Map<String, Uint8List> cachedImages) {
  return cachedImages.containsKey(imageUrl)
      ? Image.memory(
          cachedImages[imageUrl]!,
          fit: BoxFit.cover,
        )
      : const Padding(
          padding: EdgeInsets.all(1.0),
          child: CircularProgressIndicator(),
        );
}

Widget _buildOptionCircle(int index, int selectedSolvedIndex) {
  return Container(
    width: 35,
    height: 35,
    decoration: BoxDecoration(
      color: (selectedSolvedIndex == index) ? AppColor.black : Colors.white,
      shape: BoxShape.circle,
      border: Border.all(width: 2, color: AppColor.black),
    ),
    child: Center(
      child: Text(
        '${index + 1}',
        style: TextStyle(
          color: (selectedSolvedIndex == index) ? Colors.white : AppColor.black,
        ),
      ),
    ),
  );
}

Widget _buildVoiceIcon({
  required BuildContext context,
  required bool optionExists,
  required bool isSpeaking,
  required String voiceScript,
  required int answerId,
  required List<PlayedAudios> playedAudiosList,
  required Function(List<String>) speak,
  required Function() stopSpeaking,
  required ListeningQuestions? selectedListeningQuestionData,
}) {
  return Container(
    margin: const EdgeInsets.only(left: 20),
    child: InkWell(
      onTap: optionExists
          ? null
          : () async {
              if (isSpeaking) {
                await stopSpeaking();
              }
              playedAudiosList.add(
                PlayedAudios(audioId: answerId, audioType: 'option'),
              );
              await speak([voiceScript, voiceScript]);
            },
      child: Image.asset(
        'assets/speaker.png',
        height: 40,
        color: optionExists ? Colors.black54 : AppColor.navyBlue,
      ),
    ),
  );
}
