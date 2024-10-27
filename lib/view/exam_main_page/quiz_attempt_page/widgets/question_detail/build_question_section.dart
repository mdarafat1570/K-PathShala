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
  required String voiceModel,
  required String listeningQuestionType,
  required List<Dialogue> dialogue,
  required int questionId,
  bool? isSpeaking = false,
  bool? isSpeechCompleted = false,
  bool? exists = false,
  bool? isInReviewMode = false,
  required Function showZoomedImage,
  required Map<String, Uint8List> cachedImages,
  List<PlayedAudios>? playedAudiosList,
  required Function(List<String>) speak,
  required Function() stopSpeaking,
  VoidCallback? changeInDelayStatus,
  Function? onImageTap,
}) {
  return SizedBox(
    width: isInReviewMode! ? double.maxFinite : MediaQuery.sizeOf(context).width * 0.45,
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
            imageCaption: imageCaption,
            voiceScript: voiceScript,
            voiceModel: voiceModel,
            dialogue: dialogue,
            listeningQuestionType: listeningQuestionType,
            questionId: questionId,
            isSpeaking: isSpeaking!,
            exists: exists!,
            cachedImages: cachedImages,
            showZoomedImage: showZoomedImage,
            playedAudiosList: playedAudiosList ?? [],
            speak: speak,
            stopSpeaking: stopSpeaking,
            onImageTap: onImageTap,
            changeInDelayStatus: changeInDelayStatus ?? (){},
            isSpeechCompleted: isSpeechCompleted!
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
      fontWeight: textType == TextType.subtitle ? FontWeight.w400 : null,
      color: textType == TextType.subtitle ? AppColor.neutralGrey : null
    ),
  );
}

Widget _buildQuestionSection(
    BuildContext context, {
      required String question,
      required String imageUrl,
      required String imageCaption,
      required String voiceScript,
      required String voiceModel,
      required List<Dialogue> dialogue,
      required String listeningQuestionType,
      required int questionId,
      required bool isSpeaking,
      required bool isSpeechCompleted,
      required bool exists,
      required Map<String, Uint8List> cachedImages,
      required Function showZoomedImage,
      required List<PlayedAudios> playedAudiosList,
      required Function(List<String>) speak,
      required Function() stopSpeaking,
      required VoidCallback changeInDelayStatus,
      Function? onImageTap,
    }) {
  if (listeningQuestionType == 'listening_image'){
    voiceScript = imageCaption;
  }
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
                  : const Center(child: CircularProgressIndicator()),
            ),
          if ((imageUrl.isNotEmpty && voiceScript.isNotEmpty) || (imageUrl.isNotEmpty && imageCaption.isNotEmpty) ||
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
                if (isSpeaking) {
                  await stopSpeaking();
                }
                playedAudiosList.add(
                    PlayedAudios(audioId: questionId, audioType: "question"));
                if (listeningQuestionType != "dialogues") {
                  speak([voiceScript,voiceScript]);
                } else {
                  await _playDialogue(dialogue, speak, changeInDelayStatus, isSpeechCompleted);
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
    Function(List<String>) speak,
    VoidCallback changeInDelayStatus, bool isSpeechCompleted
    ) async {
  dialogue.sort((a, b) => (a.sequence ?? -1).compareTo(b.sequence ?? -1));
  List<String> voiceScriptQueue = [];

  for (int i = 0; i < 2; i++) {
    for (var voice in dialogue) {
      voiceScriptQueue.add(voice.voiceScript ?? '');
    }
  }
  await speak(voiceScriptQueue);
}


