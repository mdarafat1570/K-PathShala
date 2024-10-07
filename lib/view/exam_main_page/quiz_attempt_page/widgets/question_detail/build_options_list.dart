
import 'package:flutter/material.dart';
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/model/question_model/reading_question_page_model.dart';
import 'package:kpathshala/view/exam_main_page/quiz_attempt_page/widgets/played_audio_object.dart';

Widget buildOptionsList({
  required BuildContext context,
  required List<Options> options,
  required int selectedSolvedIndex,
  required bool isTextType,
  required bool isVoiceType,
  required bool isSpeaking,
  required bool isInDelay,
  required List<PlayedAudios> playedAudiosList,
  required Function(int, int) selectionHandling,
  required Function(String?, String) speak,
  required ListeningQuestions? selectedListeningQuestionData,
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

      return Padding(
        padding: const EdgeInsets.all(8),
        child: InkWell(
          onTap: () {
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
                  context,
                  optionExists,
                  isSpeaking,
                  isInDelay,
                  voiceScript,
                  answerId,
                  playedAudiosList,
                  speak,
                  selectedListeningQuestionData,
                ),
            ],
          ),
        ),
      );
    },
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

Widget _buildVoiceIcon(
    BuildContext context,
    bool optionExists,
    bool isSpeaking,
    bool isInDelay,
    String voiceScript,
    int answerId,
    List<PlayedAudios> playedAudiosList,
    Function(String?, String) speak,
    ListeningQuestions? selectedListeningQuestionData,
    ) {
  return Container(
    margin: const EdgeInsets.only(left: 20),
    child: InkWell(
      onTap: optionExists
          ? null
          : () {
        if (!isSpeaking && !isInDelay) {
          playedAudiosList.add(
            PlayedAudios(audioId: answerId, audioType: 'option'),
          );
          speak(
            selectedListeningQuestionData?.voiceGender,
            voiceScript,
          );
        }
      },
      child: Image.asset(
        'assets/speaker.png',
        height: 40,
        color: optionExists ? Colors.black54 : AppColor.navyBlue,
      ),
    ),
  );
}
