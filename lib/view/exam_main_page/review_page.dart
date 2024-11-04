import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:kpathshala/model/question_model/result_model.dart';
import 'package:kpathshala/repository/question/answer_review_repository.dart';
import 'package:kpathshala/service/audio_cache_service.dart';
import 'package:kpathshala/service/audio_playback_service.dart';
import 'package:kpathshala/view/exam_main_page/quiz_attempt_page/quiz_attempt_page_imports.dart';
import 'package:shimmer/shimmer.dart';

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
  AnswerReviewRepository repository = AnswerReviewRepository();

  bool dataFound = false;
  bool resultDataFound = false;
  bool isDisposed = false;
  ResultData? result;
  final AudioCacheService _audioCacheService = AudioCacheService();
  final AudioPlaybackService _audioPlaybackService = AudioPlaybackService();
  late TtsService ttsService;

  List<ReadingQuestions> readingQuestions = [];
  List<ListeningQuestions> listeningQuestions = [];

  @override
  void initState() {
    super.initState();
    ttsService = TtsService();
    ttsService.initializeTtsHandlers();
    fetchData();
    fetchResultData();
  }

  @override
  void dispose() {
    isDisposed = true;
    ttsService.dispose();
    _audioCacheService.clearCache(isCachingDisposed: isDisposed);
    _audioPlaybackService.dispose();
    super.dispose();
  }

  void fetchData() async {
    try {
      QuestionsModel? questionsModel = await repository.fetchAnswer(
          questionSetId: widget.questionSetId, context: context);

      readingQuestions = questionsModel?.data?.readingQuestions ?? [];
      listeningQuestions = questionsModel?.data?.listeningQuestions ?? [];

      setState(() {
        dataFound = true;
      });
      await Future.wait([
        _preloadFiles(),
        preloadAudio(),
      ]);
    } catch (e) {
      log(e.toString()); // Handle the exception
    }
  }

  void fetchResultData() async {
    try {
      ResultData? resultData = await repository.fetchResults(
          questionSetId: widget.questionSetId, context: context);

      result = resultData;

      setState(() {
        resultDataFound = true;
      });
    } catch (e) {
      log(e.toString()); // Handle the exception
    }
  }

  String formatTime(int totalMinutes) {
    if (totalMinutes > 59) {
      int hours = totalMinutes ~/ 60;
      int minutes = totalMinutes % 60;
      return '${hours}h-${minutes}m';
    } else {
      return '${totalMinutes}m';
    }
  }

  Future<void> _preloadFiles() async {
    log("Loading Images");

    // Helper to add cache tasks only for valid URLs
    void addCacheTask(String? imageUrl, List<Future<void>> tasks) {
      if (imageUrl?.isNotEmpty ?? false) {
        tasks.add(_cacheImage(imageUrl!));
      }
    }

    // Prepare futures for all caching tasks
    List<Future<void>> preloadFutures = [];

    // Cache reading question images and options
    for (var question in readingQuestions) {
      addCacheTask(question.imageUrl, preloadFutures);
      for (var option in question.options) {
        addCacheTask(option.imageUrl, preloadFutures);
      }
    }

    // Cache listening question images and options concurrently
    for (var question in listeningQuestions) {
      addCacheTask(question.imageUrl, preloadFutures);
      for (var option in question.options) {
        addCacheTask(option.imageUrl, preloadFutures);
      }
    }

    // Await all tasks to complete
    await Future.wait(preloadFutures);
  }

  Future<void> preloadAudio ()async{
    await _audioCacheService.cacheAudioFiles(
      cachedVoiceModelList: extractCachedVoiceModels(
        listeningQuestionList: listeningQuestions,
      ),
    );
    setState(() {});
  }

  Future<void> _cacheImage(String imageUrl) async {
    if (isDisposed) return;

    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (isDisposed) return;

      if (response.statusCode == 200) {
        cachedImages[imageUrl] = response.bodyBytes;
        log("Cached image: $imageUrl");
        setState(() {});
      } else {
        log("Failed to load image: $imageUrl");
      }
    } catch (e) {
      log("Error caching image: $e");
    }
  }

  Map<String, Uint8List> cachedImages = {};

  Future<void> speak(List<String> voiceScriptQueue) async {
    Timer? timer;
    await _audioPlaybackService.stop();

    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      log(_audioPlaybackService.currentPlayingAudioId ?? 'no');
      setState(() {});
    });

    await _audioPlaybackService.playAudioQueue(voiceScriptQueue);
    timer.cancel();

    setState(() {});
  }

  Future<void> _stopSpeaking() async {
    await _audioPlaybackService.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CommonAppBar(title: "Review ${widget.appBarTitle}"),
      body: SafeArea(
        child: Stack(
          children: [
            buildIconWaterMark(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ListView(
                children: [
                  !resultDataFound
                      ? _buildShimmerContainer(height: 230)
                      : buildScoreContainer(),
                  const Divider(),
                  !dataFound
                      ? buildShimmerLoadingEffect()
                      : Column(
                          children: [
                            buildReadingQuestionListView(),
                            const Divider(),
                            buildListeningQuestionListView(),
                          ],
                        ),
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
            final selectedSolvedIndex = readingQuestions[index]
                .options
                .indexWhere((option) =>
                    option.id ==
                    (readingQuestions[index].submission?.questionOptionId ??
                        -1));
            return Column(
              children: [
                buildQuestionSection(
                  context: context,
                  title: readingQuestions[index].title ?? '',
                  subTitle: readingQuestions[index].subtitle ?? '',
                  imageCaption: readingQuestions[index].imageCaption ?? '',
                  question: readingQuestions[index].question ?? '',
                  imageUrl: readingQuestions[index].imageUrl ?? '',
                  currentPlayingAnswerId: _audioPlaybackService.currentPlayingAudioId,
                  audioQueue: [],
                  voiceModel: '',
                  listeningQuestionType: '',
                  dialogue: [],
                  questionId: readingQuestions[index].id ?? -1,
                  showZoomedImage: showZoomedImage,
                  cachedImages: cachedImages,
                  speak: speak,
                  stopSpeaking: _stopSpeaking,
                  isInReviewMode: true,
                  isAutoPlay: false,
                  isLoading: _audioCacheService.isLoading,
                ),
                buildOptionSection(
                  context: context,
                  options: readingQuestions[index].options,
                  selectedSolvedIndex: selectedSolvedIndex,
                  correctAnswerId: readingQuestions[index].answerOption?.questionOptionId ?? -1,
                  submissionId: readingQuestions[index].submission?.questionOptionId ?? -1,
                  currentPlayingAudioId: _audioPlaybackService.currentPlayingAudioId,
                  isTextType: optionType == 'text',
                  isVoiceType: optionType == 'voice',
                  isTextWithVoice: optionType == 'text_with_voice',
                  isLoading: _audioCacheService.isLoading,
                  isInReviewMode: true,
                  isSpeaking: _audioPlaybackService.isPlaying(),
                  playedAudiosList: [],
                  selectionHandling: (v, c) {},
                  speak: speak,
                  stopSpeaking: _stopSpeaking,
                  showZoomedImage: showZoomedImage,
                  cachedImages: cachedImages,
                ),
              ],
            );
          },
          separatorBuilder: (context, index) {
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
            final optionType = listeningQuestions[index].options.first.optionType ?? 'question';
            final selectedSolvedIndex = listeningQuestions[index].options
                .indexWhere((option) =>
                    option.id == (listeningQuestions[index].submission?.questionOptionId ?? -1));
            List<String> playDialogue(List<Dialogue> dialogue, int questionId,){
              dialogue.sort((a, b) => (a.sequence ?? -1).compareTo(b.sequence ?? -1));
              List<String> voiceScriptQueue = [];

              for (var voice in dialogue) {
                String voiceScript = "dialogue-${voice.sequence}-$questionId-${voice.voiceGender}";
                voiceScriptQueue.add(voiceScript);
              }
              return voiceScriptQueue;
            }

            String voiceScript = '';
            List <String> audioQueue= [];

            final options = listeningQuestions[index].options;
            bool isTextWithVoice = options.isNotEmpty && options.first.optionType == 'text_with_voice';

            bool isAnnounce = options.first.isAnnounce == true || options.first.isAnnounce == 1;

            List<String> generateOptionScript(var option, int index) {
              String announceScript = option.voiceGender == "male"
                  ? "option--1${index + 1}-male"
                  : "option--2${index + 1}-female";
              String optionScript = "text_with_voice-${option.id}-${listeningQuestions[index].id ?? -1}-${option.voiceGender}";
              return isAnnounce ? [announceScript, optionScript] : [optionScript];
            }

            void addVoiceScript(String type, String script, List<String> optionsScripts) {
              audioQueue.addAll([script, ...optionsScripts]);
            }

            List<String> generateOptionsScripts(List options) {
              List<String> scripts = [];
              for (var i = 0; i < options.length; i++) {
                scripts.addAll(generateOptionScript(options[i], i));
              }
              return scripts;
            }

            if (optionType == "voice" || optionType == "listening_image") {
              String prefix = optionType == "voice" ? "question-${listeningQuestions[index].id}-${listeningQuestions[index].voiceGender ?? ''}" : 'image_caption-${listeningQuestions[index].id}';
              voiceScript = "$prefix-${listeningQuestions[index].voiceGender ?? ''}";

              if (isTextWithVoice) {
                List<String> optionsScripts = generateOptionsScripts(options);
                addVoiceScript(optionType, voiceScript, optionsScripts);
              } else {
                audioQueue.addAll([voiceScript, voiceScript]);
              }
            } else if (optionType == 'dialogues') {
              audioQueue.addAll(playDialogue(listeningQuestions[index].dialogues, listeningQuestions[index].id));
              if (isTextWithVoice) {
                List<String> optionsScripts = generateOptionsScripts(options);
                audioQueue.addAll(optionsScripts);
              }
            }
            return Column(
              children: [
                buildQuestionSection(
                  context: context,
                  title: listeningQuestions[index].title ?? '',
                  subTitle: listeningQuestions[index].subtitle ?? '',
                  imageCaption: listeningQuestions[index].imageCaption ?? '',
                  question: '',
                  currentPlayingAnswerId: _audioPlaybackService.currentPlayingAudioId,
                  imageUrl: listeningQuestions[index].imageUrl ?? '',
                  audioQueue: audioQueue,
                  voiceModel: listeningQuestions[index].voiceGender ?? 'female',
                  listeningQuestionType: listeningQuestions[index].questionType ?? '',
                  dialogue: listeningQuestions[index].dialogues,
                  questionId: listeningQuestions[index].id ?? -1,
                  showZoomedImage: showZoomedImage,
                  cachedImages: cachedImages,
                  speak: speak,
                  stopSpeaking: _stopSpeaking,
                  isInReviewMode: true,
                  isAutoPlay: isTextWithVoice,
                  isLoading: _audioCacheService.isLoading,
                  isSpeaking: _audioPlaybackService.isPlaying(),
                ),
                buildOptionSection(
                  context: context,
                  options: listeningQuestions[index].options,
                  selectedSolvedIndex: selectedSolvedIndex,
                  correctAnswerId: listeningQuestions[index].answerOption?.questionOptionId ?? -1,
                  submissionId: listeningQuestions[index].submission?.questionOptionId ?? -1,
                  currentPlayingAudioId: _audioPlaybackService.currentPlayingAudioId,
                  isTextType: optionType == 'text',
                  isVoiceType: optionType == 'voice',
                  isTextWithVoice: optionType == 'text_with_voice',
                  isLoading: _audioCacheService.isLoading,
                  isInReviewMode: true,
                  isSpeaking: _audioPlaybackService.isPlaying(),
                  playedAudiosList: [],
                  selectionHandling: (v, c) {},
                  speak: speak,
                  stopSpeaking: _stopSpeaking,
                  showZoomedImage: showZoomedImage,
                  cachedImages: cachedImages,
                ),
              ],
            );
          },
          separatorBuilder: (context, index) {
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
                      //H _Mint

                      formatTime(result?.takenTime ?? 0),
                      "Time taken",
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
              "${formatTime(result?.totalSpendTime ?? 0)} spent in total",
              TextType.normal,
              color: AppColor.navyBlue,
              fontSize: 10),
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

  Widget buildShimmerLoadingEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildShimmerContainer(height: 40, width: double.infinity),
            _buildShimmerContainer(height: 40, width: double.infinity),
            const SizedBox(height: 10),
            ..._buildShimmerRows(4),
            const SizedBox(height: 5),
            _buildShimmerContainer(height: 40, width: double.infinity),
            _buildShimmerContainer(height: 40, width: double.infinity),
            const SizedBox(height: 10),
            ..._buildShimmerRows(4),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerContainer({
    required double height,
    double? width,
  }) {
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  List<Widget> _buildShimmerRows(int count) {
    return List.generate(
      count,
      (index) => Row(
        children: [
          _buildShimmerContainer(height: 35, width: 35),
          _buildShimmerContainer(height: 35, width: 200),
        ],
      ),
    );
  }
}
