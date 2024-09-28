import 'package:flutter/material.dart';
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/model/question_model/answer_model.dart';
import 'package:kpathshala/model/question_model/reading_question_page_model.dart';
import 'package:kpathshala/view/common_widget/custom_text.dart.dart';

class QuestionDetailContent extends StatefulWidget {
  final ReadingQuestions? selectedQuestionData;
  final List<Answers> solvedReadingQuestions;
  bool shuffleOptions;

  QuestionDetailContent({super.key,
    required this.selectedQuestionData,
    required this.solvedReadingQuestions,
    this.shuffleOptions = false,
  });

  @override
  QuestionDetailContentState createState() => QuestionDetailContentState();
}

class QuestionDetailContentState extends State<QuestionDetailContent> {
  int selectedSolvedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.selectedQuestionData == null) return const SizedBox.shrink();

    final options = widget.selectedQuestionData?.options ?? [];
    bool isTextType = options.isNotEmpty && options.first.optionType == 'text';

    if (widget.solvedReadingQuestions.any((answer) => answer.questionId == widget.selectedQuestionData?.id)) {
      // Find the solved question's matching index in options
      selectedSolvedIndex = options.indexWhere((option) =>
      option.id == widget.solvedReadingQuestions.firstWhere(
              (answer) => answer.questionId == widget.selectedQuestionData?.id).questionOptionId);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Watermark Image
        Positioned(
          child: Opacity(
            opacity: 0.1, // Adjust opacity for the watermark effect
            child: Image.asset(
              'assets/new_App_icon.png',
              height: MediaQuery.sizeOf(context).height * 0.7,
            ),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.45,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if ((widget.selectedQuestionData?.title ?? "").isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: customText(
                              widget.selectedQuestionData?.title ?? "",
                              TextType.paragraphTitle,
                              fontSize: 20,
                            ),
                          ),
                        if ((widget.selectedQuestionData?.subtitle ?? "").isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: customText(
                              widget.selectedQuestionData?.subtitle ?? "",
                              TextType.subtitle,
                              fontSize: 20,
                            ),
                          ),
                        if ((widget.selectedQuestionData?.imageCaption ?? "").isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: customText(
                              widget.selectedQuestionData?.imageCaption ?? "",
                              TextType.subtitle,
                              fontSize: 20,
                            ),
                          ),
                        if ((widget.selectedQuestionData?.question ?? "").isNotEmpty || (widget.selectedQuestionData?.imageUrl ?? "").isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromRGBO(100, 100, 100, 1),
                                width: 1,
                              ),
                              color: const Color.fromRGBO(26, 35, 126, 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  if ((widget.selectedQuestionData?.question ?? "").isNotEmpty)
                                    customText(
                                        widget.selectedQuestionData?.question ?? "",
                                        TextType.paragraphTitle,
                                        textAlign: TextAlign.center),
                                  if ((widget.selectedQuestionData?.imageUrl ?? "").isNotEmpty)
                                    InkWell(
                                      onTap: () {
                                        showZoomedImage(widget.selectedQuestionData?.imageUrl ?? "");
                                      },
                                      child: Image.network(
                                        widget.selectedQuestionData?.imageUrl ?? "",
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.broken_image,
                                                  color: AppColor.navyBlue,
                                                  size: 50),
                                              SizedBox(height: 10),
                                              Text(
                                                "Image failed to load",
                                                style: TextStyle(color: AppColor.navyBlue, fontSize: 16),
                                              ),
                                            ],
                                          );
                                        },
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return const CircularProgressIndicator();
                                          }
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.45,
                    child: isTextType
                        ? _buildTextOptions(options)
                        : _buildImageOptions(options),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextOptions(List<Options> options) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: options.length,
      itemBuilder: (context, index) {
        if (widget.shuffleOptions) {
          options.shuffle();
          widget.shuffleOptions = false;
        }

        String answer = options[index].title ?? '';
        int answerId = options[index].id ?? -1;

        return Padding(
          padding: const EdgeInsets.all(8),
          child: InkWell(
            onTap: () {
              setState(() {
                selectedSolvedIndex = index;
                _updateSolvedAnswer(answerId);
              });
            },
            child: Row(
              children: [
                _buildOptionCircle(index),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(answer, style: const TextStyle(fontSize: 18)),
                      if ((options[index].subtitle ?? "").isNotEmpty)
                        Expanded(
                          child: Text(
                            options[index].subtitle ?? "",
                            style: const TextStyle(fontSize: 14, color: AppColor.grey500),
                          ),
                        )
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

  Widget _buildImageOptions(List<Options> options) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        String answer = options[index].imageUrl ?? "";
        int answerId = options[index].id ?? -1;

        return Padding(
          padding: const EdgeInsets.all(8),
          child: InkWell(
            onTap: () {
              setState(() {
                selectedSolvedIndex = index;
                _updateSolvedAnswer(answerId);
              });
            },
            child: Column(
              children: [
                _buildOptionCircle(index),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      showZoomedImage(answer);
                    },
                    child: Image.network(
                      answer,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, color: AppColor.navyBlue, size: 20);
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        return loadingProgress == null
                            ? child
                            : const CircularProgressIndicator();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionCircle(int index) {
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

  void _updateSolvedAnswer(int answerId) {
    Answers selectedAnswer = Answers(
      questionId: widget.selectedQuestionData?.id,
      questionOptionId: answerId,
    );

    int existingAnswerIndex = widget.solvedReadingQuestions.indexWhere(
          (answer) => answer.questionId == selectedAnswer.questionId,
    );

    if (existingAnswerIndex != -1) {
      widget.solvedReadingQuestions[existingAnswerIndex].questionOptionId = answerId;
    } else {
      widget.solvedReadingQuestions.add(selectedAnswer);
    }
  }

  void showZoomedImage (imageUrl){
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Image.network(
              imageUrl,
              errorBuilder: (context, error, stackTrace) {
                // Show something when the image fails to load
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image,
                        color: AppColor.navyBlue,
                        size: 80),
                  ],
                );
              },
              loadingBuilder:
                  (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child; // Image loaded successfully
                } else {
                  // Show a loading indicator while the image is being loaded
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        );
      },
    );
  }
}
