import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:kpathshala/view/exam_main_page/quiz_attempt_page//quiz_attempt_page_imports.dart';

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
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;

  Timer? _timer;
  late FlutterTts flutterTts;

  Map<int, Widget>? questionImages;

  final QuestionsRepository _repository = QuestionsRepository();
  final AuthService _authService = AuthService();

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

  bool dataFound = false, shuffleOptions = false;
  bool isListViewVisible = true;
  bool firstSpeechCompleted = false;
  bool isInDelay = false;
  bool isSpeaking = false;
  bool _isTimeUp = false;
  bool isSubmitted = false;

  String? selectedLanguage;
  String? selectedEngine;
  String? selectedVoice;
  String? _newVoiceText;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    readCredentials();
    initTts();
    _initializeTtsHandlers();
    _fetchReadingQuestions();
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

  Future<void> initTts() async {
    flutterTts = FlutterTts();

    // Set defaults (Korean language, Google TTS engine)
    await flutterTts.setLanguage("ko-KR");
    await flutterTts.setEngine("com.google.android.tts");
    _getVoices();
    await flutterTts.setVolume(volume);
    await flutterTts.setPitch(pitch);
    await flutterTts.setSpeechRate(rate);
  }

  Future<void> _getVoices() async {
    List<dynamic> voices = await flutterTts.getVoices as List<dynamic>;

    // Filter only Korean voices
    setState(() {
      availableVoices = voices.where((voice) {
        // Check if the voice is a Map and has the correct keys
        if (voice is Map &&
            voice.containsKey('locale') &&
            voice.containsKey('name')) {
          return voice['locale'] == 'ko-KR';
        }
        return false;
      }).map((voice) {
        // Ensure the map is correctly typed
        return {
          'name': voice['name'] as String,
          'locale': voice['locale'] as String,
        };
      }).toList();

      // Set default voice if available
      selectedVoice =
          availableVoices.isNotEmpty ? availableVoices[0]['name'] : null;
    });
  }

  Future<void> speak(String? model, String voiceScript,
      {bool? isDialogue = false}) async {
    _newVoiceText = voiceScript;

    if (_newVoiceText == null || _newVoiceText!.isEmpty) {
      log("No text provided for speech.");
      return;
    }

    if (model == "female" || model == null) {
      selectedVoice = "ko-kr-x-ism-local";
    } else {
      selectedVoice = "ko-kr-x-kod-local";
    }

    if (selectedVoice != null) {
      // Safely retrieve the voice map
      Map<String, String>? voice = availableVoices.firstWhere(
        (v) => v['name'] == selectedVoice,
        orElse: () =>
            {'name': '', 'locale': ''}, // Return a default map instead of null
      ) as Map<String, String>?; // Ensure the correct type

      if (voice != null && voice['name']!.isNotEmpty) {
        await flutterTts.setVoice(voice);
        log("Using voice: ${voice['name']}");
      } else {
        log("Selected voice not found.");
        return;
      }
    }
    if (isSpeaking || isInDelay) {
      log("Audio is already playing or in delay. Ignoring click.");
      return; // Prevent playing if already speaking or in delay
    }

    // Mark the speaking state as true
    setState(() {
      isInDelay = true; // Start delay period
    });

    // Start the first speech
    log("Speaking first: $_newVoiceText");
    await flutterTts.speak(_newVoiceText!);

    await Future.delayed(const Duration(seconds: 3));

    if (firstSpeechCompleted && !isDialogue!) {
      log("Speaking second: $_newVoiceText");
      await flutterTts.speak(_newVoiceText!);
    } else if (!isDialogue!) {
      log("First speech was interrupted, second speech will not be played.");
    }

    setState(() {
      isInDelay = false;
    });
  }

  Future<void> _stopSpeaking() async {
    if (isSpeaking || isInDelay) {
      await flutterTts.stop();
      firstSpeechCompleted = false;
      log("Speech stopped");
    }
  }

  void _initializeTtsHandlers() {
    flutterTts.setStartHandler(() {
      log("Speech started");
      setState(() {
        isSpeaking = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      log("Speech completed");
      setState(() {
        isSpeaking = false;
        firstSpeechCompleted = true;
      });
    });

    flutterTts.setCancelHandler(() {
      log("Speech canceled");
      setState(() {
        isSpeaking = false;
      });
    });

    flutterTts.setErrorHandler((msg) {
      log("An error occurred: $msg");
      setState(() {
        isSpeaking = false;
      });
    });
  }

  Future<void> _fetchReadingQuestions() async {
    try {
      // Fetch the questions asynchronously
      QuestionsModel? questionsModel = await _repository.fetchReadingQuestions(
          widget.questionSetId, context);

      // After fetching the questions, check if the widget is still mounted
      if (!mounted) return;

      if (questionsModel != null && questionsModel.data != null) {
        readingQuestions = questionsModel.data?.readingQuestions ?? [];
        listeningQuestions = questionsModel.data?.listeningQuestions ?? [];

        await _preloadImages();

        totalQuestion = questionsModel.data?.totalQuestion ?? 0;
        _remainingTime = (questionsModel.data?.duration ?? 60) * 60;
        // _remainingTime = 5;
        _examTime = (questionsModel.data?.duration ?? 60) * 60;

        // Now that the widget is still mounted, safely update the state
        setState(() {
          dataFound = true;
          _startTimer();
        });
      } else {
        log('Questions model or data is null');
        if (mounted) {
          dataFound = true;
          setState(() {});
        }
      }
    } catch (error, stackTrace) {
      log('Error fetching reading questions: $error');
      log('Stack trace: $stackTrace');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Failed to load reading questions. Please try again.'),
          ),
        );
      }
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

    // Wait for all images to be cached
    await Future.wait(preloadFutures);
  }

  Future<void> _cacheImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        // Cache image bytes
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
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Perform extra navigation if needed
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
            // Stay on the page
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            // Exit the page
            child: const Text(
              "Exit",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
    }
    super.dispose();
    flutterTts.stop();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
                    //  Content for the selected tab
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
        bottomNavigationBar: !dataFound
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
    // int index = isListening
    //     ? _listeningQuestions.indexOf(_selectedListeningQuestionData!)
    //     : _readingQuestions.indexOf(_selectedReadingQuestionData!);
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
    final voiceScript = selectedListeningQuestionData?.voiceScript ?? "";
    dialogue = selectedListeningQuestionData?.dialogues ?? [];
    final listeningQuestionType =
        selectedListeningQuestionData?.questionType ?? "";
    final options = isListening
        ? selectedListeningQuestionData?.options ?? []
        : selectedReadingQuestionData?.options ?? [];
    bool isTextType = options.isNotEmpty && options.first.optionType == 'text';
    bool isVoiceType =
        options.isNotEmpty && options.first.optionType == 'voice';
    int questionId = isListening
        ? selectedListeningQuestionData?.id ?? -1
        : selectedReadingQuestionData?.id ?? -1;
    int selectedSolvedIndex = -1;
    if (!isListening &&
        (solvedReadingQuestions.any((answer) =>
            answer.questionId == selectedReadingQuestionData?.id))) {
      // Find the solved question's matching index in options
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
                  buildQuestionSection(
                      context: context,
                      title: title,
                      subTitle: subTitle,
                      imageCaption: imageCaption,
                      question: question,
                      imageUrl: imageUrl,
                      voiceScript: voiceScript,
                      listeningQuestionType: listeningQuestionType,
                      dialogue: dialogue,
                      questionId: questionId,
                      isSpeaking: isSpeaking,
                      isInDelay: isInDelay,
                      exists: exists,
                      showZoomedImage: showZoomedImage,
                      cachedImages: cachedImages,
                      playedAudiosList: playedAudiosList,
                      speak: speak,
                      changeInDelayStatus: changeInDelayStatus,
                      isSpeechCompleted: firstSpeechCompleted),
                  SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.45,
                      child: isTextType || isVoiceType
                          ? buildOptionsList(
                              context: context,
                              options: options,
                              selectedSolvedIndex: selectedSolvedIndex,
                              isTextType: isTextType,
                              isVoiceType: isVoiceType,
                              isSpeaking: isSpeaking,
                              isInDelay: isInDelay,
                              playedAudiosList: playedAudiosList,
                              selectionHandling: selectionHandling,
                              speak: speak,
                              selectedListeningQuestionData:
                                  selectedListeningQuestionData)
                          : buildOptionsGrid(
                              context: context,
                              options: options,
                              selectedSolvedIndex: selectedSolvedIndex,
                              selectionHandling: selectionHandling,
                              showZoomedImage: showZoomedImage,
                              cachedImages: cachedImages)),
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

  void changeInDelayStatus() {
    setState(() {
      isInDelay = !isInDelay;
    });
  }
}
