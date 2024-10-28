import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kpathshala/model/question_model/reading_question_page_model.dart';
import 'package:kpathshala/view/exam_main_page/quiz_attempt_page/widgets/played_audio_object.dart';

import 'build_options_list.dart';

Widget buildOptionSection({
  required BuildContext context,
  required List<Options> options,
  required int selectedSolvedIndex,
  int? correctAnswerId,
  int? submissionId,
  required bool isTextType,
  required bool isVoiceType,
  required bool isTextWithVoice,
  bool? isInReviewMode = false,
  required bool isSpeaking,
  required bool isLoading,
  required List<PlayedAudios> playedAudiosList,
  required Function(int, int) selectionHandling,
  required Function(List<String>) speak,
  required Function() stopSpeaking,
  ListeningQuestions? selectedListeningQuestionData,
  required Function(BuildContext, String, Map<String, Uint8List>) showZoomedImage,
  required Map<String, Uint8List> cachedImages,
}) {
  return SizedBox(
      width: isInReviewMode! ? null : MediaQuery.sizeOf(context).width * 0.45,
      child: isTextType || isVoiceType || isTextWithVoice
          ? buildOptionsList(
              context: context,
              options: options,
              selectedSolvedIndex: selectedSolvedIndex,
              isTextType: isTextType,
              isVoiceType: isVoiceType,
              isSpeaking: isSpeaking,
              isInReviewMode: isInReviewMode,
              isTextWithVoice: isTextWithVoice,
              isLoading: isLoading,
              correctAnswerId: correctAnswerId,
              submissionId: submissionId,
              playedAudiosList: playedAudiosList,
              selectionHandling: selectionHandling,
              speak: speak,
              stopSpeaking: stopSpeaking,
              selectedListeningQuestionData: selectedListeningQuestionData)
          : buildOptionsGrid(
              context: context,
              options: options,
              selectedSolvedIndex: selectedSolvedIndex,
              correctAnswerId: correctAnswerId,
              submissionId: submissionId,
              isInReviewMode: isInReviewMode,
              selectionHandling: selectionHandling,
              showZoomedImage: showZoomedImage,
              cachedImages: cachedImages));
}
