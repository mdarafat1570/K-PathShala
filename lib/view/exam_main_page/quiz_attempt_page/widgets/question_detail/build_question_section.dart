import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/model/question_model/reading_question_page_model.dart';
import 'package:kpathshala/view/common_widget/custom_text.dart.dart';
import 'package:kpathshala/view/exam_main_page/quiz_attempt_page/widgets/played_audio_object.dart';

Widget buildQuestionSection({
  required BuildContext context,
  required String title,
  required String subTitle,
  required String imageCaption,
  required String question,
  required String imageUrl,
  required String voiceScript,
  required String listeningQuestionType,
  required List<Dialogue> dialogue,
  required int questionId,
  required bool isSpeaking,
  required bool isInDelay,
  required bool isSpeechCompleted,
  required bool exists,
  required Function showZoomedImage,
  required Map<String, Uint8List> cachedImages,
  required List<PlayedAudios> playedAudiosList,
  required Function(String?, String, {bool isDialogue}) speak,
  required VoidCallback changeInDelayStatus,
  Function? onImageTap,
}) {
  return SizedBox(
    width: MediaQuery.sizeOf(context).width * 0.45,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) _buildTextBlock(title, TextType.paragraphTitle),
        if (subTitle.isNotEmpty) _buildTextBlock(subTitle, TextType.subtitle),
        if (imageCaption.isNotEmpty)
          _buildTextBlock(imageCaption, TextType.subtitle),
        if (question.isNotEmpty ||
            imageUrl.isNotEmpty ||
            voiceScript.isNotEmpty ||
            dialogue.isNotEmpty)
          _buildQuestionSection(
            context,
            question: question,
            imageUrl: imageUrl,
            voiceScript: voiceScript,
            dialogue: dialogue,
            listeningQuestionType: listeningQuestionType,
            questionId: questionId,
            isSpeaking: isSpeaking,
            isInDelay: isInDelay,
            exists: exists,
            cachedImages: cachedImages,
            showZoomedImage: showZoomedImage,
            playedAudiosList: playedAudiosList,
            speak: speak,
            onImageTap: onImageTap,
            changeInDelayStatus: changeInDelayStatus,
            isSpeechCompleted: isSpeechCompleted
          ),
      ],
    ),
  );
}

Widget _buildTextBlock(String text, TextType textType) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: customText(
      text,
      textType,
      fontSize: 20,
    ),
  );
}

Widget _buildQuestionSection(
    BuildContext context, {
      required String question,
      required String imageUrl,
      required String voiceScript,
      required List<Dialogue> dialogue,
      required String listeningQuestionType,
      required int questionId,
      required bool isSpeaking,
      required bool isInDelay,
      required bool isSpeechCompleted,
      required bool exists,
      required Map<String, Uint8List> cachedImages,
      required Function showZoomedImage,
      required List<PlayedAudios> playedAudiosList,
      required Function(String?, String, {bool isDialogue}) speak,
      required VoidCallback changeInDelayStatus,
      Function? onImageTap,
    }) {
  return Container(
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.symmetric(vertical: 10),
    width: double.maxFinite,
    decoration: BoxDecoration(
      border: Border.all(color: const Color.fromRGBO(100, 100, 100, 1), width: 1),
      color: const Color.fromRGBO(26, 35, 126, 0.2),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Center(
      child: Column(
        children: [
          if (question.isNotEmpty)
            customText(question, TextType.paragraphTitle, textAlign: TextAlign.center),
          if (imageUrl.isNotEmpty)
            InkWell(
              onTap: () {
                showZoomedImage(context, imageUrl, cachedImages);
              },
              child: cachedImages.containsKey(imageUrl)
                  ? Image.memory(
                cachedImages[imageUrl]!,
                fit: BoxFit.cover,
              )
                  : const CircularProgressIndicator(),
            ),
          if ((imageUrl.isNotEmpty && voiceScript.isNotEmpty) ||
              (question.isNotEmpty && voiceScript.isNotEmpty))
            const Divider(
              color: Colors.black54,
              height: 20,
              thickness: 1,
            ),
          if (listeningQuestionType != 'dialogues'
              ? voiceScript.isNotEmpty
              : dialogue.isNotEmpty)
            InkWell(
              onTap: exists
                  ? null
                  : () async {
                if (!isSpeaking && !isInDelay) {
                  playedAudiosList.add(
                      PlayedAudios(audioId: questionId, audioType: "question"));
                  if (listeningQuestionType != "dialogues") {
                    speak(null, voiceScript);
                  } else {
                    await _playDialogue(dialogue, speak, changeInDelayStatus, isSpeechCompleted);
                  }
                }
              },
              child: Image.asset(
                "assets/speaker.png",
                height: 40,
                color: exists ? Colors.black54 : AppColor.navyBlue,
              ),
            ),
        ],
      ),
    ),
  );
}

Future<void> _playDialogue(
    List<Dialogue> dialogue,
    Function(String?, String, {bool isDialogue}) speak,
    VoidCallback changeInDelayStatus, bool isSpeechCompleted
    ) async {
  for (int i = 0; i < 2; i++) {
    for (var voice in dialogue) {
      await speak(voice.voiceGender, voice.voiceScript ?? '', isDialogue: true);
      if(isSpeechCompleted == false){
        return;
      }
    }
    changeInDelayStatus();
    await Future.delayed(const Duration(seconds: 3));
    changeInDelayStatus();
  }
}


