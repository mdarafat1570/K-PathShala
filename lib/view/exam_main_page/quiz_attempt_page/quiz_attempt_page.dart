import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:kpathshala/service/audio_cache_service.dart';
import 'package:kpathshala/service/audio_playback_service.dart';
import 'package:kpathshala/view/exam_main_page/quiz_attempt_page/quiz_attempt_page_imports.dart';

class RetakeTestPage extends StatefulWidget {
  final int questionSetId;
  final String title;
  final String description;

  const RetakeTestPage({
    super.key,
    required this.questionSetId,
    required this.title,
    required this.description,
  });

  @override
  RetakeTestPageState createState() => RetakeTestPageState();
}

class RetakeTestPageState extends State<RetakeTestPage>
    with WidgetsBindingObserver {
  int _remainingTime = 3600;
  int _examTime = 3600;
  int totalQuestion = 0;

  Timer? _timer;

  Map<int, Widget>? questionImages;

  final QuestionsRepository _repository = QuestionsRepository();
  final AuthService _authService = AuthService();
  final AudioCacheService _audioCacheService = AudioCacheService();
  final AudioPlaybackService _audioPlaybackService = AudioPlaybackService();

  ReadingQuestions? selectedReadingQuestionData;
  ListeningQuestions? selectedListeningQuestionData;
  LogInCredentials? credentials;

  List<ReadingQuestions> readingQuestions = [];
  List<ListeningQuestions> listeningQuestions = [];
  List<Dialogue> dialogue = [];
  List<Answers> solvedReadingQuestions = [];
  List<Answers> solvedListeningQuestions = [];
  List<dynamic> availableVoices = [];
  List<PlayedAudios> playedAudiosList = [];
  List<Options> previousOptions = [];

  bool dataFound = false, shuffleOptions = false;
  bool isListViewVisible = true;
  bool _isTimeUp = false;
  bool isSubmitted = false;
  bool isDisposed = false;

  String? selectedLanguage;
  String? selectedEngine;
  String? selectedVoice;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    readCredentials();
    _fetchQuestions();
  }

  @override
  void dispose() {
    isDisposed = true;
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
    }
    _audioCacheService.clearCache(isCachingDisposed: isDisposed);
    _audioPlaybackService.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future<void> readCredentials() async {
    credentials = await _authService.getLogInCredentials();

    if (credentials == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No credentials found")),
      );
    }
    setState(() {});
  }

  Future<void> speak(List<String> voiceScriptQueue) async {
    log("playing$voiceScriptQueue");
    await _audioPlaybackService.playAudioQueue(voiceScriptQueue);
  }

  Future<void> _stopSpeaking() async {
    await _audioPlaybackService.stop();
  }

  Future<void> _fetchQuestions() async {
    try {
      QuestionsModel? questionsModel = await _repository.fetchReadingQuestions(
          widget.questionSetId, context);

      if (!mounted) return;

      if (questionsModel != null && questionsModel.data != null) {
        readingQuestions = questionsModel.data?.readingQuestions ?? [];
        listeningQuestions = questionsModel.data?.listeningQuestions ?? [];

        await _preloadFiles();
        await preloadAudio();

        totalQuestion = questionsModel.data?.totalQuestion ?? 0;
        _remainingTime = (questionsModel.data?.duration ?? 60) * 60;
        _examTime = (questionsModel.data?.duration ?? 60) * 60;

        if (mounted){
          setState(() {
            dataFound = true;
            _startTimer();
          });
        }
      } else {
        log('Questions model or data is null');
        if (mounted) {
          dataFound = true;
          setState(() {});
        }
      }
    } catch (error, stackTrace) {
      log('Error fetching questions: $error');
      log('Stack trace: $stackTrace');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Failed to load questions. Please try again.'),
          ),
        );
      }
    }
  }

  Future<void> _preloadFiles() async {
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

  Future<void> preloadAudio ()async{
    await _audioCacheService.cacheAudioFiles(
      cachedVoiceModelList: extractCachedVoiceModels(
        listeningQuestionList: listeningQuestions,
      ),
    );
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

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
          _isTimeUp = true;
          showCustomDialog(
            context: context,
            isPopScope: true,
            showTimeUpDialog: true,
            onPrimaryAction: () {
              Navigator.pop(context);
              submitAnswer(isTimeUp: true);
            },
            onSecondaryAction: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
        }
      });
    });
  }

  Future<bool?> _showExitExamConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Exit Exam"),
        content: const Text(
          "If you close this page, all your progress will be permanently lost. "
          "Are you sure you want to exit the exam?",
          style: TextStyle(fontSize: 16.0),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              "Exit",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String get _formattedTime {
    final minutes = ((_remainingTime % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: (isSubmitted || _isTimeUp),
      onPopInvoked: (bool didPop) async {
        if (didPop || _isTimeUp || isSubmitted) {
          return;
        }
        if (!isListViewVisible) {
          setState(() {
            selectedReadingQuestionData = null;
            selectedListeningQuestionData = null;
            isListViewVisible = true;
          });
        } else {
          final bool shouldPop =
              await _showExitExamConfirmation(context) ?? false;
          if (context.mounted && shouldPop) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        body: SafeArea(
          child: !dataFound
              ? loadingScreen(context)
              : Column(
                  children: [
                    PageHeader(
                      isListViewVisible: isListViewVisible,
                      formattedTime: _formattedTime,
                      totalQuestions: totalQuestion,
                      solvedQuestions: calculateSolved(),
                      unsolvedQuestions: calculateUnsolved(),
                      userImageUrl: credentials?.imagesAddress ?? '',
                      userName: credentials?.name ?? '',
                    ),
                    Expanded(
                      child: ListView(children: [
                        Visibility(
                          visible: isListViewVisible,
                          replacement: buildQuestionDetailContent(),
                          child: QuestionGrid(
                            dataFound: dataFound,
                            readingQuestionsLength: readingQuestions.length,
                            listeningQuestionsLength: listeningQuestions.length,
                            isQuestionSolved: isQuestionSolved,
                            updateSelectedQuestion: updateSelectedQuestion,
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
        ),
        bottomNavigationBar: !dataFound || totalQuestion == 0
            ? null
            : BottomNavBar(
                isListViewVisible: isListViewVisible,
                isPreviousButtonVisible: isPreviousButtonVisible(),
                isSubmitAnswerButtonVisible: isSubmitAnswerButtonVisible(),
                isNextButtonVisible: isNextButtonVisible(),
                moveToPrevious: moveToPrevious,
                checkAnswerLength: checkAnswerLength,
                moveToNext: moveToNext,
                onTotalQuestionsPress: onTotalQuestionsPress,
              ),
      ),
    );
  }

  Widget buildQuestionDetailContent() {
    if (selectedReadingQuestionData == null &&
        selectedListeningQuestionData == null) return const SizedBox.shrink();
    bool isListening = selectedReadingQuestionData == null;
    final title = isListening
        ? selectedListeningQuestionData?.title ?? ""
        : selectedReadingQuestionData?.title ?? "";
    final subTitle = isListening
        ? selectedListeningQuestionData?.subtitle ?? ""
        : selectedReadingQuestionData?.subtitle ?? "";
    final imageCaption = isListening
        ? selectedListeningQuestionData?.imageCaption ?? ""
        : selectedReadingQuestionData?.imageCaption ?? "";
    final question = selectedReadingQuestionData?.question ?? "";
    final imageUrl = isListening
        ? selectedListeningQuestionData?.imageUrl ?? ""
        : selectedReadingQuestionData?.imageUrl ?? "";
    final voiceModel = selectedListeningQuestionData?.voiceGender ?? 'female';
    final voiceScript = "question-${selectedListeningQuestionData?.id}-$voiceModel";
    dialogue = selectedListeningQuestionData?.dialogues ?? [];
    final listeningQuestionType =
        selectedListeningQuestionData?.questionType ?? "";
    final options = isListening
        ? selectedListeningQuestionData?.options ?? []
        : selectedReadingQuestionData?.options ?? [];
    if (!listEquals(options, previousOptions)) {
      options.shuffle(); // Shuffle only if options have changed
      previousOptions = List.from(options); // Update the previous options list
    }
    bool isTextType = options.isNotEmpty && options.first.optionType == 'text';
    bool isVoiceType =
        options.isNotEmpty && options.first.optionType == 'voice';
    bool isTextWithVoice =
        options.isNotEmpty && options.first.optionType == 'text_with_voice';
    int questionId = isListening
        ? selectedListeningQuestionData?.id ?? -1
        : selectedReadingQuestionData?.id ?? -1;
    int selectedSolvedIndex = -1;
    if (!isListening &&
        (solvedReadingQuestions.any((answer) =>
            answer.questionId == selectedReadingQuestionData?.id))) {
      selectedSolvedIndex = options.indexWhere((option) =>
          option.id ==
          solvedReadingQuestions
              .firstWhere((answer) =>
                  answer.questionId == selectedReadingQuestionData?.id)
              .questionOptionId);
    } else if ((solvedListeningQuestions.any(
        (answer) => answer.questionId == selectedListeningQuestionData?.id))) {
      selectedSolvedIndex = options.indexWhere((option) =>
          option.id ==
          solvedListeningQuestions
              .firstWhere((answer) =>
                  answer.questionId == selectedListeningQuestionData?.id)
              .questionOptionId);
    }

    void selectionHandling(int index, int answerId) {
      setState(() {
        selectedSolvedIndex = index;

        Answers selectedAnswer = Answers(
          questionId: questionId,
          questionOptionId: answerId,
        );

        List<Answers> currentSolvedQuestions =
            isListening ? solvedListeningQuestions : solvedReadingQuestions;

        int existingAnswerIndex = currentSolvedQuestions.indexWhere(
          (answer) => answer.questionId == selectedAnswer.questionId,
        );

        if (existingAnswerIndex != -1) {
          currentSolvedQuestions[existingAnswerIndex].questionOptionId =
              answerId;
        } else {
          currentSolvedQuestions.add(selectedAnswer);
        }
      });
    }

    bool exists = selectedListeningQuestionData != null &&
        playedAudiosList.any(
          (audio) =>
              audio.audioId == selectedListeningQuestionData!.id &&
              audio.audioType == 'question',
        );

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          child: Opacity(
            opacity: 0.1,
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
                  buildQuestionSection(
                      context: context,
                      title: title,
                      subTitle: subTitle,
                      imageCaption: imageCaption,
                      question: question,
                      imageUrl: imageUrl,
                      voiceScript: voiceScript,
                      voiceModel: voiceModel,
                      currentPlayingAnswerId: _audioPlaybackService.currentPlayingAudioId,
                      listeningQuestionType: listeningQuestionType,
                      dialogue: dialogue,
                      questionId: questionId,
                      isSpeaking: _audioPlaybackService.isPlaying(),
                      isLoading: _audioCacheService.isLoading,
                      exists: exists,
                      showZoomedImage: showZoomedImage,
                      cachedImages: cachedImages,
                      playedAudiosList: playedAudiosList,
                      speak: speak,
                      stopSpeaking: _stopSpeaking),
                  buildOptionSection(
                    context: context,
                    options: options,
                    selectedSolvedIndex: selectedSolvedIndex,
                    currentPlayingAudioId: _audioPlaybackService.currentPlayingAudioId,
                    isTextType: isTextType,
                    isVoiceType: isVoiceType,
                    isTextWithVoice: isTextWithVoice,
                    isSpeaking: _audioPlaybackService.isPlaying(),
                    isLoading: _audioCacheService.isLoading,
                    playedAudiosList: playedAudiosList,
                    selectionHandling: selectionHandling,
                    speak: speak,
                    stopSpeaking: _stopSpeaking,
                    selectedListeningQuestionData:
                        selectedListeningQuestionData,
                    showZoomedImage: showZoomedImage,
                    cachedImages: cachedImages,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool isPreviousButtonVisible() {
    if (isListViewVisible) return false;

    if (selectedListeningQuestionData != null) return true;

    return selectedReadingQuestionData != null &&
        readingQuestions.indexOf(selectedReadingQuestionData!) > 0;
  }

  bool isNextButtonVisible() {
    if (isListViewVisible) return false;

    if (selectedReadingQuestionData != null) return true;

    return selectedListeningQuestionData != null &&
        listeningQuestions.indexOf(selectedListeningQuestionData!) <
            listeningQuestions.length - 1;
  }

  bool isSubmitAnswerButtonVisible() {
    return isListViewVisible ||
        (selectedListeningQuestionData != null &&
            listeningQuestions.indexOf(selectedListeningQuestionData!) ==
                listeningQuestions.length - 1);
  }

  void onTotalQuestionsPress() {
    isListViewVisible = true;
    selectedReadingQuestionData = null;
    selectedListeningQuestionData = null;
    _stopSpeaking();
    setState(() {});
  }

  void moveToPrevious() {
    _stopSpeaking();

    void updateSelectedData<T>(
        List<T> questions, T? selectedData, Function(T?) setSelectedData) {
      int index = questions.indexOf(selectedData as T);
      setSelectedData((index > 0) ? questions[index - 1] : null);
      setState(() {});
    }

    if (selectedListeningQuestionData != null) {
      updateSelectedData(listeningQuestions, selectedListeningQuestionData,
          (data) {
        selectedListeningQuestionData = data;
        if (data == null && readingQuestions.isNotEmpty) {
          selectedReadingQuestionData = readingQuestions.last;
        }
      });
    } else if (selectedReadingQuestionData != null) {
      updateSelectedData(readingQuestions, selectedReadingQuestionData, (data) {
        selectedReadingQuestionData = data;
      });
    }
  }

  void moveToNext() {
    _stopSpeaking();

    void updateSelectedData<T>(
        List<T> questions, T? selectedData, Function(T?) setSelectedData) {
      int index = questions.indexOf(selectedData as T);
      setSelectedData((index != -1 && index < questions.length - 1)
          ? questions[index + 1]
          : null);
      setState(() {});
    }

    if (selectedReadingQuestionData != null) {
      updateSelectedData(readingQuestions, selectedReadingQuestionData, (data) {
        selectedReadingQuestionData = data;
        if (data == null) {
          selectedListeningQuestionData =
              listeningQuestions.isNotEmpty ? listeningQuestions[0] : null;
        }
      });
    } else if (selectedListeningQuestionData != null) {
      updateSelectedData(listeningQuestions, selectedListeningQuestionData,
          (data) {
        selectedListeningQuestionData = data;
      });
    }
  }

  int calculateSolved() {
    return solvedReadingQuestions.length + solvedListeningQuestions.length;
  }

  int calculateUnsolved() {
    return (readingQuestions.length + listeningQuestions.length) -
        calculateSolved();
  }

  void updateSelectedQuestion(int index, bool isListening) {
    setState(() {
      selectedListeningQuestionData =
          isListening ? listeningQuestions[index] : null;
      selectedReadingQuestionData =
          isListening ? null : readingQuestions[index];
      isListViewVisible = false;
    });
  }

  bool isQuestionSolved(int index, bool isListening) {
    return isListening
        ? solvedListeningQuestions
            .any((answer) => answer.questionId == listeningQuestions[index].id)
        : solvedReadingQuestions
            .any((answer) => answer.questionId == readingQuestions[index].id);
  }

  void checkAnswerLength() {
    _stopSpeaking();
    int answerLength =
        solvedReadingQuestions.length + solvedListeningQuestions.length;
    if (answerLength == 0) {
      showCustomDialog(
        context: context,
        showNoAnswerSelectedDialog: true,
        onPrimaryAction: () {
          Navigator.pop(context);
        },
      );
      return;
    } else if (answerLength < totalQuestion) {
      showCustomDialog(
        context: context,
        showWarningDialog: true,
        missedQuestions: totalQuestion - answerLength,
        onPrimaryAction: () {
          Navigator.pop(context);
          submitAnswer();
        },
        onSecondaryAction: () {
          Navigator.pop(context);
        },
      );
    } else {
      submitAnswer();
    }
  }

  void submitAnswer({bool isTimeUp = false}) async {
    int duration = (_examTime - _remainingTime) ~/ 60;
    duration = duration < 1 ? 1 : duration;

    final combinedList = [
      ...solvedReadingQuestions,
      ...solvedListeningQuestions
    ];

    if (combinedList.isEmpty) {
      showCustomDialog(
        context: context,
        isPopScope: isTimeUp,
        showNoAnswerSelectedDialog: true,
        onPrimaryAction: () {
          if (isTimeUp) Navigator.pop(context);
          Navigator.pop(context);
        },
      );
      return;
    }

    AnswerModel finalAnswer = AnswerModel(
      answers: combinedList,
      duration: duration,
      questionSetId: widget.questionSetId,
    );

    log("------------");
    log(duration.toString());
    log(jsonEncode(finalAnswer));

    try {
      showLoadingIndicator(context: context, showLoader: true);
      final response = await AnswerSubmissionRepository().submitAnswers(
        answers: finalAnswer,
        context: context,
      );

      if (mounted) {
        showLoadingIndicator(context: context, showLoader: false);
        if (response['error'] == null || !response['error']) {
          showCustomDialog(
            context: context,
            showSuccessDialog: true,
            isPopScope: true,
            onPrimaryAction: () {
              if (_remainingTime > 0) {
                _timer?.cancel();
              }
              isSubmitted = true;
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
          log("Submission Successful");
        } else {
          log("Submission Failed: ${response['message']}");
        }
      }
    } catch (e) {
      if (mounted) {
        showLoadingIndicator(context: context, showLoader: false);
        showCustomDialog(
          context: context,
          showErrorDialog: true,
          isPopScope: true,
          onPrimaryAction: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
        log("An error occurred: $e");
      }
    }
  }
}
