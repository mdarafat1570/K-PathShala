import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/model/question_model/reading_question_page_model.dart';
import 'package:kpathshala/view/common_widget/custom_text.dart.dart';
import 'package:kpathshala/view/exam_main_page/quiz_attempt_page/widgets/played_audio_object.dart';
import 'package:lottie/lottie.dart';

Widget buildQuestionSection({
  required BuildContext context,
  required String title,
  required String subTitle,
  required String imageCaption,
  required String question,
  required String imageUrl,
  String? currentPlayingAnswerId,
  required String voiceModel,
  required String listeningQuestionType,
  required List<Dialogue> dialogue,
  required List<String> audioQueue,
  required int questionId,
  bool? isSpeaking = false,
  bool? exists = false,
  required bool isAutoPlay,
  bool? isInReviewMode = false,
  required bool isLoading,
  required Function showZoomedImage,
  required Map<String, Uint8List> cachedImages,
  List<PlayedAudios>? playedAudiosList,
  required Function(List<String>) speak,
  required Function() stopSpeaking,
  Function? onImageTap,
}) {
  return SizedBox(
    width: isInReviewMode! ? double.maxFinite : MediaQuery.sizeOf(context).width * 0.45,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) _buildTextBlock(title, TextType.paragraphTitle),
        if (subTitle.isNotEmpty) _buildTextBlock(subTitle, TextType.subtitle),
        if (imageCaption.isNotEmpty && listeningQuestionType != 'listening_image')
          _buildTextBlock(imageCaption, TextType.subtitle),
        if (question.isNotEmpty ||
            imageUrl.isNotEmpty ||
            audioQueue.isNotEmpty ||
            dialogue.isNotEmpty)
          _buildQuestionSection(
            context,
            question: question,
            imageUrl: imageUrl,
            imageCaption: imageCaption,
            voiceModel: voiceModel,
            currentPlayingAnswerId: currentPlayingAnswerId,
            dialogue: dialogue,
            audioQueue: audioQueue,
            listeningQuestionType: listeningQuestionType,
            questionId: questionId,
            isSpeaking: isSpeaking!,
            isAutoPlay: isAutoPlay,
            exists: exists!,
            isLoading: isLoading,
            cachedImages: cachedImages,
            showZoomedImage: showZoomedImage,
            playedAudiosList: playedAudiosList ?? [],
            speak: speak,
            stopSpeaking: stopSpeaking,
            onImageTap: onImageTap,
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
      required String voiceModel,
      required List<Dialogue> dialogue,
      required List<String> audioQueue,
      required String listeningQuestionType,
      String? currentPlayingAnswerId,
      required int questionId,
      required bool isSpeaking,
      required bool exists,
      required bool isLoading,
      required bool isAutoPlay,
      required Map<String, Uint8List> cachedImages,
      required Function showZoomedImage,
      required List<PlayedAudios> playedAudiosList,
      required Function(List<String>) speak,
      required Function() stopSpeaking,
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
            customText(question, TextType.paragraphTitle, textAlign: TextAlign.center, fontSize: 18),
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
          if (listeningQuestionType == 'listening_image')
            const Divider(
              color: Colors.black54,
              height: 20,
              thickness: 1,
            ),
          if (listeningQuestionType == 'dialogues' || listeningQuestionType == 'listening_image' || listeningQuestionType == 'voice')
            isLoading ? const Center(
              child: SizedBox(
                height: 40,
                child: CircularProgressIndicator(),
              ),
            ) :
            InkWell(
              onTap: exists
                  ? null
                  : () async {
                if (isSpeaking) {
                  await stopSpeaking();
                }
                playedAudiosList.add(PlayedAudios(audioId: questionId, audioType: "question"));
                await speak(audioQueue);
              },
              child: (isSpeaking &&
                  currentPlayingAnswerId != null &&
                  currentPlayingAnswerId.contains(RegExp(r'(question|dialogue|image_caption|text_with_voice|option--)')) &&
                  (currentPlayingAnswerId.contains('$questionId') || isAutoPlay)) ?
              Lottie.asset("assets/sound.json", height: 50,)
                  : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Image.asset(
                        "assets/sound.png",
                        height: 40, color: exists ? Colors.black54 : null,
                    ),
                  ),
            ),
        ],
      ),
    ),
  );
}


