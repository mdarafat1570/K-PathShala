import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:kpathshala/model/question_model/result_model.dart';
import 'package:kpathshala/repository/question/answer_review_repository.dart';
import 'package:kpathshala/view/exam_main_page/quiz_attempt_page/quiz_attempt_page_imports.dart';

import '../common_widget/common_app_bar.dart';

class ReviewPage extends StatefulWidget {
  final String appBarTitle;
  final int questionSetId;

  const ReviewPage(
      {super.key, required this.appBarTitle, required this.questionSetId});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  bool dataFound = false;
  ResultData? result;
  late TtsService ttsService;

  List<ReadingQuestions> readingQuestions = [];
  List<ListeningQuestions> listeningQuestions = [];

  @override
  void initState() {
    super.initState();
    ttsService = TtsService();
    ttsService.initializeTtsHandlers();
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
    ttsService.dispose();
  }

  void fetchData() async {
    try {
      AnswerReviewRepository repository = AnswerReviewRepository();

      ResultData? resultData = await repository.fetchResults(
          questionSetId: widget.questionSetId, context: context);
      QuestionsModel? questionsModel = await repository.fetchAnswer(questionSetId: widget.questionSetId, context: context);

      result = resultData;
      readingQuestions = questionsModel?.data?.readingQuestions ?? [];
      listeningQuestions = questionsModel?.data?.listeningQuestions ?? [];
      await _preloadImages();

      setState(() {
        dataFound = true;
      });
      log("----------");
    } catch (e) {
      log(e.toString()); // Handle the exception
    }
  }

  Future<void> _preloadImages() async {
    log("Loading Image");
    List<Future<void>> preloadFutures = [];

    for (ReadingQuestions question in readingQuestions) {
      if (question.imageUrl != null && question.imageUrl!.isNotEmpty) {
        preloadFutures.add(_cacheImage(question.imageUrl!));
      }

      for (var option in question.options) {
        if (option.imageUrl != null && option.imageUrl!.isNotEmpty) {
          preloadFutures.add(_cacheImage(option.imageUrl!));
        }
      }
    }

    for (ListeningQuestions question in listeningQuestions) {
      if (question.imageUrl != null && question.imageUrl!.isNotEmpty) {
        preloadFutures.add(_cacheImage(question.imageUrl!));
      }

      for (var option in question.options) {
        if (option.imageUrl != null && option.imageUrl!.isNotEmpty) {
          preloadFutures.add(_cacheImage(option.imageUrl!));
        }
      }
    }

    await Future.wait(preloadFutures);
  }

  Future<void> _cacheImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        cachedImages[imageUrl] = response.bodyBytes;
        log("Cached image: $imageUrl");
      } else {
        log("Failed to load image: $imageUrl");
      }
    } catch (e) {
      log("Error caching image: $e");
    }
  }

  Map<String, Uint8List> cachedImages = {};

  Future<void> speak(String? model, String voiceScript,
      {bool? isDialogue = false}) async {
    ttsService.speak(model, voiceScript);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CommonAppBar(title: "Review ${widget.appBarTitle}"),
      body: SafeArea(
        child: !dataFound
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  buildIconWaterMark(context),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: ListView(
                      children: [
                        buildScoreContainer(),
                        const Divider(),
                        buildReadingQuestionListView(),
                        const Divider(),
                        buildListeningQuestionListView(),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildReadingQuestionListView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/book-open.png", height: 16),
            Text(
              "읽기 (${readingQuestions.length} Questions)",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: readingQuestions.length,
          itemBuilder: (context, index) {
            final optionType = readingQuestions[index].options.first.optionType;
            final selectedSolvedIndex = readingQuestions[index].options.indexWhere((option) =>
            option.id == (readingQuestions[index].submission?.questionOptionId ?? -1));
            return Column(
              children: [
                buildQuestionSection(
                  context: context,
                  title: readingQuestions[index].title ?? '',
                  subTitle: readingQuestions[index].subtitle ?? '',
                  imageCaption: readingQuestions[index].imageCaption ?? '',
                  question: readingQuestions[index].question ?? '',
                  imageUrl: readingQuestions[index].imageUrl ?? '',
                  voiceScript: '',
                  voiceModel: '',
                  listeningQuestionType: '',
                  dialogue: [],
                  questionId: readingQuestions[index].id ?? -1,
                  showZoomedImage: showZoomedImage,
                  cachedImages: cachedImages,
                  speak: speak,
                  isInReviewMode: true,
                ),
                buildOptionSection(
                  context: context,
                  options: readingQuestions[index].options,
                  selectedSolvedIndex: selectedSolvedIndex,
                  correctAnswerId: readingQuestions[index].answerOption?.questionOptionId ?? -1,
                  submissionId: readingQuestions[index].submission?.questionOptionId ?? -1,
                  isTextType: optionType == 'text',
                  isVoiceType: optionType == 'voice',
                  isTextWithVoice: optionType == 'text_with_voice',
                  isInReviewMode: true,
                  isSpeaking: ttsService.isInDelay,
                  isInDelay: ttsService.isInDelay,
                  playedAudiosList: [],
                  selectionHandling: (v,c){},
                  speak: speak,
                  showZoomedImage: showZoomedImage,
                  cachedImages: cachedImages,
                ),
              ],
            );
          },
          separatorBuilder: (context, index){
            return Divider(
              color: Colors.grey[200],
            );
          },
        ),
      ],
    );
  }

  Widget buildListeningQuestionListView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/headphones.png", height: 16),
            Text(
              "듣기 (${listeningQuestions.length} Questions)",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: listeningQuestions.length,
          itemBuilder: (context, index) {
            final optionType = listeningQuestions[index].options.first.optionType;
            final selectedSolvedIndex = listeningQuestions[index].options.indexWhere((option) =>
            option.id == (listeningQuestions[index].submission?.questionOptionId ?? -1));
            return Column(
              children: [
                buildQuestionSection(
                  context: context,
                  title: listeningQuestions[index].title ?? '',
                  subTitle: listeningQuestions[index].subtitle ?? '',
                  imageCaption: listeningQuestions[index].imageCaption ?? '',
                  question: '',
                  imageUrl: listeningQuestions[index].imageUrl ?? '',
                  voiceScript: listeningQuestions[index].voiceScript ?? '',
                  voiceModel: listeningQuestions[index].voiceGender ?? '',
                  listeningQuestionType: listeningQuestions[index].questionType ?? '',
                  dialogue: listeningQuestions[index].dialogues,
                  questionId: listeningQuestions[index].id ?? -1,
                  showZoomedImage: showZoomedImage,
                  cachedImages: cachedImages,
                  speak: speak,
                  isInReviewMode: true,
                ),
                buildOptionSection(
                  context: context,
                  options: listeningQuestions[index].options,
                  selectedSolvedIndex: selectedSolvedIndex,
                  correctAnswerId: listeningQuestions[index].answerOption?.questionOptionId ?? -1,
                  submissionId: listeningQuestions[index].submission?.questionOptionId ?? -1,
                  isTextType: optionType == 'text',
                  isVoiceType: optionType == 'voice',
                  isTextWithVoice: optionType == 'text_with_voice',
                  isInReviewMode: true,
                  isSpeaking: ttsService.isInDelay,
                  isInDelay: ttsService.isInDelay,
                  playedAudiosList: [],
                  selectionHandling: (v,c){},
                  speak: speak,
                  showZoomedImage: showZoomedImage,
                  cachedImages: cachedImages,
                ),
              ],
            );
          },
          separatorBuilder: (context, index){
            return Divider(
              color: Colors.grey[200],
            );
          },
        ),
      ],
    );
  }

  Opacity buildIconWaterMark(BuildContext context) {
    return Opacity(
      opacity: 0.1,
      child: Center(
        child: Image.asset(
          'assets/new_App_icon.png',
          height: MediaQuery.sizeOf(context).width * 0.7,
        ),
      ),
    );
  }

  Container buildScoreContainer() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border.all(color: AppColor.skyBlue, width: 1),
          borderRadius: BorderRadius.circular(16.0),
          gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(238, 240, 255, 1),
              Color.fromRGBO(145, 209, 236, 1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            // crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${result?.totalGotScore ?? 0}",
                style: const TextStyle(
                  fontSize: 48,
                  color: AppColor.navyBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                children: [
                  const Gap(20),
                  Text(
                    "/${result?.maximumScore ?? 0}",
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              )
            ],
          ),
          const Text(
            "Final score",
            style: TextStyle(color: AppColor.navyBlue, fontSize: 12),
          ),
          const Gap(10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(1),
            child: Row(
              children: [
                // First card: only left border radius
                Expanded(
                  child: _buildScoreContainer(
                      "${result?.gotReadingScore ?? 0} of ${result?.maxReadingScore ?? 0}",
                      "Reading Test",
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      )),
                ),
                const SizedBox(width: 1),

                // Middle card: no border radius
                Expanded(
                  child: _buildScoreContainer(
                      "${result?.gotListeningScore ?? 0} of ${result?.maxListeningScore ?? 0}",
                      "Listening Test",
                      borderRadius: BorderRadius.zero),
                ),
                const SizedBox(width: 1),
                // Last card: only right border radius
                Expanded(
                  child: _buildScoreContainer(
                      "${result?.takenTime ?? 0} min", "Time taken",
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      )),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          customText(
              "${result?.totalRetake ?? 0} Retakes taken", TextType.normal,
              color: AppColor.navyBlue, fontSize: 10),
          customText(
              "${result?.totalSpendTime ?? 0} spent in total", TextType.normal,
              color: AppColor.navyBlue, fontSize: 10),
          const Gap(10),
        ],
      ),
    );
  }

  Widget _buildScoreContainer(String score, String label,
      {required BorderRadius borderRadius}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: const Color.fromRGBO(135, 206, 235, 0.2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Text(
              score,
              style: const TextStyle(
                color: AppColor.navyBlue,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: AppColor.black, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
