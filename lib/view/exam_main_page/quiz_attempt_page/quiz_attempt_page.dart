import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/model/log_in_credentials.dart';
import 'package:kpathshala/model/question_model/answer_model.dart';
import 'package:kpathshala/model/question_model/reading_question_page_model.dart';
import 'package:kpathshala/repository/authentication_repository.dart';
import 'package:kpathshala/repository/question/answer_submission_repository.dart';
import 'package:kpathshala/repository/question/reading_questions_repository.dart';
import 'package:kpathshala/view/common_widget/common_loading_indicator.dart';
import 'package:lottie/lottie.dart';

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

  Timer? _timer;

  Map<int, Widget>? questionImages;

  // int _currentTabIndex = 0;
  //
  // int _selectedTotalIndex = -1;
  // int _selectedTotalIndex2 = -1;
  // int _selectedSolvedIndex2 = -1;
  ReadingQuestions? _selectedReadingQuestionData;
  ListeningQuestions? _selectedListeningQuestionData;
  final QuestionsRepository _repository = QuestionsRepository();
  List<ReadingQuestions> _readingQuestions = [];
  List<ListeningQuestions> _listeningQuestions = [];
  List<Answers> solvedReadingQuestions = [];
  List<Answers> solvedListeningQuestions = [];
  bool dataFound = false, shuffleOptions = false;
  bool isListViewVisible = true;
  bool firstSpeechCompleted = false;
  bool isInDelay = false;
  bool isSpeaking = false;
  bool _isTimeUp = false;
  static const platform =
      MethodChannel('com.inferloom.kpathshala/exit_confirmation');
  final AuthService _authService = AuthService();
  LogInCredentials? credentials;
  late FlutterTts flutterTts;
  String? selectedLanguage;
  String? selectedEngine;
  String? selectedVoice;
  List<dynamic> availableVoices = [];
  List<PlayedAudios> playedAudiosList = [];
  String? _newVoiceText;

  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;

  @override
  void initState() {
    super.initState();
    // _startTimer();
    // WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    // platform.setMethodCallHandler((call) async {
    //
    //   if (call.method == 'onUserLeaveHint') {
    //     // return await _showExitExamConfirmation(context);
    //   }
    //   return null;
    // });
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

  Future<void> _speak(String? model, String voiceScript) async {
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

    // Wait for a 3-second delay before deciding if the second speech should start
    await Future.delayed(const Duration(seconds: 3));

    // Only play the second speech if the first one has completed and wasn't interrupted
    if (firstSpeechCompleted) {
      log("Speaking second: $_newVoiceText");
      await flutterTts.speak(_newVoiceText!);
    } else {
      log("First speech was interrupted, second speech will not be played.");
    }

    setState(() {
      isInDelay = false;
    });
  }

  Future<void> _stopSpeaking() async {
    if (isSpeaking) {
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // The app has come back to the foreground
      // Here you can check if the user was taking an exam
      _showDisqualificationDialog(context);
    }
  }

  Future<void> _showDisqualificationDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Disqualification"),
        content:
            const Text("You have exited the exam. You are now disqualified."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchReadingQuestions() async {
    try {
      // Fetch the questions asynchronously
      QuestionsModel? questionsModel = await _repository.fetchReadingQuestions(
          widget.questionSetId, context);

      // After fetching the questions, check if the widget is still mounted
      if (!mounted) return;

      if (questionsModel != null && questionsModel.data != null) {
        _readingQuestions = questionsModel.data?.readingQuestions ?? [];
        _listeningQuestions = questionsModel.data?.listeningQuestions ?? [];

        await _preloadImages();

        _remainingTime = 3600; // Set your initial remaining time
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
    List<Future> preloadFutures = [];
    int index = 1;

    for (ReadingQuestions question in _readingQuestions) {
      log("Reading question ${index++}");
      if (question.imageUrl != null && question.imageUrl!.isNotEmpty) {
        log("Question Image loading...");
        // Add each image preloading task to the list
        preloadFutures.add(
          precacheImage(NetworkImage(question.imageUrl!), context),
        );
        log("Successful...");
      }
      int optionIndex = 1;
      for (var option in question.options) {
        log("Option ${optionIndex++}");
        if (option.imageUrl != null && option.imageUrl!.isNotEmpty) {
          log("Option Image loading...");
          // Add each image preloading task to the list
          preloadFutures.add(
            precacheImage(NetworkImage(option.imageUrl!), context),
          );
          log("Successful...");
        }
      }
    }

    for (ListeningQuestions question in _listeningQuestions) {
      log("Listening question ${index++}");
      if (question.imageUrl != null && question.imageUrl!.isNotEmpty) {
        log("Image loading...");
        // Add each image preloading task to the list
        preloadFutures.add(
          precacheImage(NetworkImage(question.imageUrl!), context),
        );
        log("Successful...");
      }
      int optionIndex = 1;
      for (var option in question.options) {
        log("Option ${optionIndex++}");
        if (option.imageUrl != null && option.imageUrl!.isNotEmpty) {
          log("Option Image loading...");
          // Add each image preloading task to the list
          preloadFutures.add(
            precacheImage(NetworkImage(option.imageUrl!), context),
          );
          log("Successful...");
        }
      }
    }

    // Wait for all images to be preloaded
    await Future.wait(preloadFutures);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
          _isTimeUp = true;
          _showTimeUpDialog();
        }
      });
    });
  }

  void _showTimeUpDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Time Up'),
          content: const Text(
              'Your time for the test has ended.You have to submit the answer'),
          actions: [
            // TextButton(
            //   onPressed: () {
            //     Navigator.pop(context);
            //     Navigator.pop(context);
            //   },
            //   child: const Text('Cancel'),
            // ),
            TextButton(
              onPressed: () {
                submitAnswer();
              },
              child: const Text('Submit Answer'),
            ),
          ],
        );
      },
    );
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
    log("Disposed");
    super.dispose();
    flutterTts.stop();
    // WidgetsBinding.instance.removeObserver(this);
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
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        if (_isTimeUp) {
          return;
        }
        if (!isListViewVisible) {
          setState(() {
            _selectedReadingQuestionData = null;
            _selectedListeningQuestionData = null;
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
                ? loadingScreen()
                : Column(
                    children: [
                      pageHeader(),
                      //  Content for the selected tab
                      Expanded(
                        child: ListView(children: [
                          Visibility(
                            visible: isListViewVisible,
                            replacement: buildQuestionDetailContent(),
                            child: buildGridContent(
                              isSolved: false,
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
          ),
          bottomNavigationBar: !dataFound
              ? null
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // Distribute space between items
                    children: [
                      if (!isListViewVisible)
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.2,
                          child: ElevatedButton(
                            onPressed: () {
                              isListViewVisible = true;
                              _selectedReadingQuestionData = null;
                              _selectedListeningQuestionData = null;
                              _stopSpeaking();
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                    color: AppColor.grey400, width: 1),
                              ),
                              backgroundColor:
                                  AppColor.grey200, // Change color as needed
                            ),
                            child: const Text(
                              'Total Questions',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor.navyBlue,
                              ),
                            ),
                          ),
                        ),
                      const Spacer(), // Spacing between buttons
                      if (isPreviousButtonVisible())
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.2,
                          child: ElevatedButton(
                            onPressed: moveToPrevious,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor:
                                  AppColor.grey300, // Change color as needed
                            ),
                            child: const Text(
                              'Previous',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor.navyBlue,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(width: 10),
                      if (isSubmitAnswerButtonVisible())
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.2,
                          child: ElevatedButton(
                            onPressed: () {
                              // Combine the lists and calculate total_answer
                              final List<Answers> combinedList = [];
                              combinedList.addAll(solvedReadingQuestions);
                              combinedList.addAll(solvedListeningQuestions);
                              int total_answer = combinedList
                                  .length; // Calculate total number of answers

                              // Calculate the number of missed questions
                              int missedQuestions = 40 - total_answer;
                              // Logic to calculate missed questions should be implemented here

                              // Check if total_answer is less than 40 or if there are missed questions
                              if (total_answer < 40 || missedQuestions > 0) {
                                // Show a dialog if total questions attempted is less than 40 or if there are missed questions
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Warning'),
                                      content: Text(missedQuestions > 0
                                          ? 'You have $missedQuestions missed questions. Do you want to submit anyway?'
                                          : 'You must attempt at least 40 questions before submitting.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                            submitAnswer(); // Proceed with submitting the answer
                                          },
                                          child: const Text('Submit Anyway'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                submitAnswer(); // Proceed with submitting the answer
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor:
                                  AppColor.navyBlue, // Change color as needed
                            ),
                            child: const Text(
                              'Submit Answer',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      if (isNextButtonVisible())
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.2,
                          child: ElevatedButton(
                            onPressed: moveToNext,
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor:
                                  AppColor.navyBlue, // Change color as needed
                            ),
                            child: const Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                )),
    );
  }

  Stack pageHeader() {
    ImageProvider<Object> imageProvider;

    if (credentials?.imagesAddress != null &&
        credentials?.imagesAddress != "") {
      imageProvider = NetworkImage(credentials!.imagesAddress ?? '');
    } else {
      imageProvider = const AssetImage('assets/new_App_icon.png');
    }
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: Row(
                  children: [
                    CircleAvatar(radius: 20, backgroundImage: imageProvider),
                    const Gap(10),
                    if (credentials?.name != null &&
                        credentials!.name!.isNotEmpty)
                      Expanded(
                        child: Text(
                          credentials?.name ?? 'User',
                          style: const TextStyle(
                              fontSize: 12, color: AppColor.grey700),
                        ),
                      ),
                  ],
                ),
              ),
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: isListViewVisible
                          ? const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  width: 3,
                                  color: AppColor.navyBlue,
                                ),
                              ),
                              color: AppColor.navyBlue,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ))
                          : null,
                      child: Text(
                        isListViewVisible
                            ? "Total Questions"
                            : "Total Questions - ${_readingQuestions.length + _listeningQuestions.length}",
                        style: TextStyle(
                          color: isListViewVisible
                              ? Colors.white
                              : AppColor.grey700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (!isListViewVisible)
                      Container(
                        height: 20,
                        width: 2,
                        color: AppColor.grey400,
                      ),
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Solved Questions-${calculateSolved()}',
                        style: const TextStyle(
                            color: AppColor.grey700, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      height: 20,
                      width: 2,
                      color: AppColor.grey400,
                    ),
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Unsolved Questions-${calculateUnsolved()}',
                        style: const TextStyle(
                            color: AppColor.grey700, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(11.0),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 1, color: AppColor.navyBlue),
                          right: BorderSide(width: 1, color: AppColor.navyBlue),
                          left: BorderSide(width: 1, color: AppColor.navyBlue),
                        ),
                        color: Color.fromRGBO(26, 35, 126, 0.2),
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(15)),
                      ),
                      child: Text(
                        _formattedTime,
                        style: const TextStyle(
                          color: AppColor.navyBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          color: AppColor.navyBlue,
          width: double.maxFinite,
          height: 1,
        ),
      ],
    );
  }

  Widget buildQuestionDetailContent() {
    if (_selectedReadingQuestionData == null &&
        _selectedListeningQuestionData == null) return const SizedBox.shrink();
    bool isListening = _selectedReadingQuestionData == null;
    int index = isListening
        ? _listeningQuestions.indexOf(_selectedListeningQuestionData!)
        : _readingQuestions.indexOf(_selectedReadingQuestionData!);
    final title = isListening
        ? _selectedListeningQuestionData?.title ?? ""
        : _selectedReadingQuestionData?.title ?? "";
    final subTitle = isListening
        ? _selectedListeningQuestionData?.subtitle ?? ""
        : _selectedReadingQuestionData?.subtitle ?? "";
    final imageCaption = isListening
        ? _selectedListeningQuestionData?.imageCaption ?? ""
        : _selectedReadingQuestionData?.imageCaption ?? "";
    final question = _selectedReadingQuestionData?.question ?? "";
    final imageUrl = isListening
        ? _selectedListeningQuestionData?.imageUrl ?? ""
        : _selectedReadingQuestionData?.imageUrl ?? "";
    final voiceScript = _selectedListeningQuestionData?.voiceScript ?? "";
    final options = isListening
        ? _selectedListeningQuestionData?.options ?? []
        : _selectedReadingQuestionData?.options ?? [];
    bool isTextType = options.isNotEmpty && options.first.optionType == 'text';
    bool isVoiceType =
        options.isNotEmpty && options.first.optionType == 'voice';
    int questionId = isListening
        ? _selectedListeningQuestionData?.id ?? -1
        : _selectedReadingQuestionData?.id ?? -1;
    int selectedSolvedIndex = -1;
    if (!isListening &&
        (solvedReadingQuestions.any((answer) =>
            answer.questionId == _selectedReadingQuestionData?.id))) {
      // Find the solved question's matching index in options
      selectedSolvedIndex = options.indexWhere((option) =>
          option.id ==
          solvedReadingQuestions
              .firstWhere((answer) =>
                  answer.questionId == _selectedReadingQuestionData?.id)
              .questionOptionId);
    } else if ((solvedListeningQuestions.any(
        (answer) => answer.questionId == _selectedListeningQuestionData?.id))) {
      selectedSolvedIndex = options.indexWhere((option) =>
          option.id ==
          solvedListeningQuestions
              .firstWhere((answer) =>
                  answer.questionId == _selectedListeningQuestionData?.id)
              .questionOptionId);
    }

    void selectionHandling(index, answerId) {
      setState(() {
        selectedSolvedIndex = index;

        // Create a new Answers object based on the selected option
        Answers selectedAnswer = Answers(
          questionId: questionId,
          questionOptionId: answerId,
        );

        // Check if the answer already exists in solvedReadingQuestions
        int existingAnswerIndex = -1;
        if (isListening) {
          existingAnswerIndex = solvedListeningQuestions.indexWhere(
              (answer) => answer.questionId == selectedAnswer.questionId);
        } else {
          existingAnswerIndex = solvedReadingQuestions.indexWhere(
              (answer) => answer.questionId == selectedAnswer.questionId);
        }

        if (existingAnswerIndex != -1) {
          // Update the existing answer with the new selected option ID
          isListening
              ? solvedListeningQuestions[existingAnswerIndex].questionOptionId =
                  answerId
              : solvedReadingQuestions[existingAnswerIndex].questionOptionId =
                  answerId;
        } else {
          // Add the new answer to the list if it doesn't exist
          isListening
              ? solvedListeningQuestions.add(selectedAnswer)
              : solvedReadingQuestions.add(selectedAnswer);
        }
      });
    }

    bool exists = playedAudiosList.any((audio) =>
        audio.audioId == _selectedListeningQuestionData?.id &&
        audio.audioType == 'question');

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
                        // Text("Is Listening $isListening", style: TextStyle(color: Colors.red),),
                        // Text("Index ${index+1}", style: TextStyle(color: Colors.red),),
                        if (title.isNotEmpty) // Check for null or empty
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: customText(
                              title,
                              TextType.paragraphTitle,
                              fontSize: 20,
                            ),
                          ),
                        if (subTitle.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: customText(
                              subTitle,
                              TextType.subtitle,
                              fontSize: 20,
                            ),
                          ),
                        if (imageCaption.isNotEmpty) // Check for null or empty
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: customText(
                              imageCaption,
                              TextType.subtitle,
                              fontSize: 20,
                            ),
                          ),
                        if (question.isNotEmpty ||
                            imageUrl.isNotEmpty ||
                            voiceScript.isNotEmpty) // Check for null or empty
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
                                  if (question.isNotEmpty)
                                    customText(
                                        question, TextType.paragraphTitle,
                                        textAlign: TextAlign.center),
                                  if (imageUrl.isNotEmpty)
                                    InkWell(
                                      onTap: () {
                                        showZoomedImage(imageUrl);
                                      },
                                      child: Image.network(
                                        imageUrl,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          // Show something when the image fails to load
                                          return const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.broken_image,
                                                  color: AppColor.navyBlue,
                                                  size: 50), // Error icon
                                              SizedBox(height: 10),
                                              Text(
                                                "Image failed to load",
                                                style: TextStyle(
                                                    color: AppColor.navyBlue,
                                                    fontSize: 16),
                                              ),
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
                                  if ((imageUrl.isNotEmpty &&
                                          voiceScript.isNotEmpty) ||
                                      (question.isNotEmpty &&
                                          voiceScript.isNotEmpty))
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      height: 1,
                                      width: double.maxFinite,
                                      color: Colors.black54,
                                    ),
                                  if (voiceScript.isNotEmpty)
                                    InkWell(
                                      onTap: exists
                                          ? null
                                          : () {
                                              playedAudiosList.add(PlayedAudios(
                                                  audioId: questionId,
                                                  audioType: "question"));
                                              if (!isSpeaking) {
                                                _speak(
                                                    _selectedListeningQuestionData
                                                        ?.voiceGender,
                                                    voiceScript);
                                              }
                                            },
                                      child: Image.asset(
                                        "assets/speaker.png",
                                        height: 40,
                                        color: exists
                                            ? Colors.black54
                                            : AppColor.navyBlue,
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.45,
                    child: isTextType || isVoiceType
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              // if (shuffleOptions) {
                              //   options.shuffle();
                              //   shuffleOptions = false;
                              // }
                              String answer = options[index].title ?? '';
                              int answerId = options[index].id ?? -1;
                              String voiceScript =
                                  options[index].voiceScript ?? "";
                              bool optionExists = playedAudiosList.any(
                                  (audio) =>
                                      audio.audioId == answerId &&
                                      audio.audioType == 'option');

                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: InkWell(
                                  onTap: () {
                                    selectionHandling(index, answerId);
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 35,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: (selectedSolvedIndex == index)
                                              ? AppColor.black
                                              : const Color.fromRGBO(
                                                  255, 255, 255, 1),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 2, color: AppColor.black),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${index + 1}',
                                            style: TextStyle(
                                              color:
                                                  (selectedSolvedIndex == index)
                                                      ? const Color.fromRGBO(
                                                          255, 255, 255, 1)
                                                      : AppColor.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      if (answer.isNotEmpty && isTextType)
                                        Expanded(
                                          child: Text(
                                            answer,
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                        ),
                                      if (voiceScript.isNotEmpty && isVoiceType)
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 20),
                                          child: InkWell(
                                            onTap: optionExists
                                                ? null
                                                : () {
                                                    playedAudiosList.add(
                                                        PlayedAudios(
                                                            audioId: answerId,
                                                            audioType:
                                                                "option"));
                                                    if (!isSpeaking &&
                                                        !isInDelay) {
                                                      _speak(
                                                          _selectedListeningQuestionData
                                                              ?.voiceGender,
                                                          voiceScript);
                                                    }
                                                  },
                                            child: Image.asset(
                                              "assets/speaker.png",
                                              height: 40,
                                              color: optionExists
                                                  ? Colors.black54
                                                  : AppColor.navyBlue,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 2,
                            ),
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              String answerImage =
                                  options[index].imageUrl ?? "";
                              int answerId = options[index].id;
                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: InkWell(
                                  onTap: () {
                                    selectionHandling(index, answerId);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 35,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            color:
                                                (selectedSolvedIndex == index)
                                                    ? AppColor.black
                                                    : const Color.fromRGBO(
                                                        255, 255, 255, 1),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 2,
                                                color: AppColor.black)),
                                        child: Center(
                                            child: Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            color:
                                                (selectedSolvedIndex == index)
                                                    ? const Color.fromRGBO(
                                                        255, 255, 255, 1)
                                                    : AppColor.black,
                                          ),
                                        )),
                                      ),
                                      const SizedBox(width: 8),
                                      // Spacing between circle and text
                                      if (answerImage.isNotEmpty)
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              showZoomedImage(answerImage);
                                            },
                                            child: Image.network(
                                              answerImage,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                // Show something when the image fails to load
                                                return const Icon(
                                                    Icons.broken_image,
                                                    color: AppColor.navyBlue,
                                                    size: 20);
                                              },
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child; // Image loaded successfully
                                                } else {
                                                  // Show a loading indicator while the image is being loaded
                                                  return const CircularProgressIndicator();
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildGridContent({
    required bool isSolved, // Add the required questionSetId parameter
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.45,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/book-open.png",
                      height: 16,
                    ),
                    Text(
                      " 읽기 (${_readingQuestions.length}Question)",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 10),
                  child: dataFound == false
                      ? const Center(child: CircularProgressIndicator())
                      : _readingQuestions.isEmpty
                          ? const Center(child: Text("No Questions Available"))
                          : questionsGrid(_readingQuestions.length, false),
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.45,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/headphones.png",
                      height: 16,
                    ),
                    Text(
                      " 듣기 (${_listeningQuestions.length}Question)",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 10),
                  child: dataFound == false
                      ? const Center(child: CircularProgressIndicator())
                      : _listeningQuestions.isEmpty
                          ? const Center(child: Text("No Questions Available"))
                          : questionsGrid(_listeningQuestions.length, true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  GridView questionsGrid(int questionCount, bool isListening) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      itemCount: questionCount,
      itemBuilder: (context, index) {
        bool isSelected = isListening
            ? solvedListeningQuestions.any(
                (answer) => answer.questionId == _listeningQuestions[index].id)
            : solvedReadingQuestions.any(
                (answer) => answer.questionId == _readingQuestions[index].id);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isListening) {
                _selectedListeningQuestionData = _listeningQuestions[index];
                _selectedReadingQuestionData = null;
                isListViewVisible = false;
              } else {
                _selectedReadingQuestionData = _readingQuestions[index];
                _selectedListeningQuestionData = null;
                isListViewVisible = false;
                // shuffleOptions = true;
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColor.skyBlue
                  : const Color.fromRGBO(245, 247, 250, 1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                isListening
                    ? '${_readingQuestions.length + index + 1}'
                    : '${index + 1}',
                style: TextStyle(
                  fontSize: 18,
                  color: isSelected
                      ? const Color.fromRGBO(245, 247, 250, 1)
                      : AppColor.navyBlue,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool isPreviousButtonVisible() {
    if (!isListViewVisible &&
        _selectedReadingQuestionData != null &&
        _selectedListeningQuestionData == null) {
      return (_readingQuestions.indexOf(_selectedReadingQuestionData!) > 0);
    } else if (!isListViewVisible && _selectedListeningQuestionData != null) {
      return true;
    } else {
      return false;
    }
  }

  bool isNextButtonVisible() {
    if (!isListViewVisible &&
        _selectedReadingQuestionData == null &&
        _selectedListeningQuestionData != null) {
      return (_listeningQuestions.indexOf(_selectedListeningQuestionData!) <
          _listeningQuestions.length - 1);
    } else if (!isListViewVisible && _selectedReadingQuestionData != null) {
      return true;
    } else {
      return false;
    }
  }

  bool isSubmitAnswerButtonVisible() {
    return isListViewVisible ||
        (_selectedListeningQuestionData != null &&
            _listeningQuestions.indexOf(_selectedListeningQuestionData!) ==
                _listeningQuestions.length - 1);
  }

  void moveToPrevious() {
    _stopSpeaking();
    void updateSelectedData<T>(
        List<T> questions, T? selectedData, Function(T?) setSelectedData) {
      int index = questions.indexOf(selectedData as T);
      if (index > 0) {
        // Ensure it's not the first item
        setSelectedData(questions[index - 1]);
      } else {
        setSelectedData(null);
      }
      setState(() {});
    }

    if (_selectedListeningQuestionData != null) {
      updateSelectedData(_listeningQuestions, _selectedListeningQuestionData,
          (data) {
        _selectedListeningQuestionData = data;
        if (data == null && _readingQuestions.isNotEmpty) {
          _selectedReadingQuestionData =
              _readingQuestions[_readingQuestions.length - 1];
        }
      });
    } else if (_selectedReadingQuestionData != null) {
      updateSelectedData(_readingQuestions, _selectedReadingQuestionData,
          (data) {
        _selectedReadingQuestionData = data;
      });
    }
  }

  void moveToNext() {
    _stopSpeaking();
    void updateSelectedData<T>(
        List<T> questions, T? selectedData, Function(T?) setSelectedData) {
      int index = questions.indexOf(selectedData as T);
      if (index != -1 && index < questions.length - 1) {
        setSelectedData(questions[index + 1]);
      } else {
        setSelectedData(null);
      }
      setState(() {});
    }

    if (_selectedReadingQuestionData != null) {
      updateSelectedData(_readingQuestions, _selectedReadingQuestionData,
          (data) {
        _selectedReadingQuestionData = data;
        if (data == null) {
          _selectedListeningQuestionData =
              _listeningQuestions.isNotEmpty ? _listeningQuestions[0] : null;
        }
      });
    } else if (_selectedListeningQuestionData != null) {
      updateSelectedData(_listeningQuestions, _selectedListeningQuestionData,
          (data) {
        _selectedListeningQuestionData = data;
      });
    }
  }

  int calculateSolved() {
    return solvedReadingQuestions.length + solvedListeningQuestions.length;
  }

  int calculateUnsolved() {
    return (_readingQuestions.length + _listeningQuestions.length) -
        calculateSolved();
  }

  void showZoomedImage(imageUrl) {
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
                        color: AppColor.navyBlue, size: 80),
                  ],
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
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

  void submitAnswer() async {
    _stopSpeaking();
    int duration = (_examTime - _remainingTime) ~/ 60;
    final List<Answers> combinedList = [];
    combinedList.addAll(solvedReadingQuestions);
    combinedList.addAll(solvedListeningQuestions);
    AnswerModel finalAnswer = AnswerModel(
      answers: combinedList,
      duration: duration < 1 ? 1 : duration,
      questionSetId: widget.questionSetId,
    );

    log("------------");
    log((duration.toString()));
    log(jsonEncode(finalAnswer));

    if (combinedList.isEmpty) {
      _showNOAnswerSubmissionDialog(context);
      return;
    }

    try {
      showLoadingIndicator(context: context, showLoader: true);

      final response = await AnswerSubmissionRepository()
          .submitAnswers(answers: finalAnswer, context: context);

      log(jsonEncode(response));

      // Process the response
      if ((response['error'] == null || !response['error']) && mounted) {
        // Hide loading indicator
        showLoadingIndicator(context: context, showLoader: false);

        _showSuccessDialog(context);

        log("Submission Successful");
        // Optionally store token or any other data
        // final prefs = await SharedPreferences.getInstance();
        // prefs.setString('paymentToken', response['payment_token'] ?? '');

        // Perform any other success actions
      } else {
        if (mounted) {
          showLoadingIndicator(context: context, showLoader: false);
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text("Payment failed: ${response['message']}")),
          // );
          log("Submission Failed: ${response['message']}");
        }
      }
    } catch (e) {
      if (mounted) {
        showLoadingIndicator(context: context, showLoader: false);
        _showErrorDialog(context);
        log("An error occurred: $e");
      }
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.check, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Success!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Answer Submitted Successfully",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Background color
                  ),
                  child: const Text("See Result!"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.close, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Error!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Something went wrong while submitting!",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Background color
                  ),
                  child: const Text("TRY AGAIN"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showNOAnswerSubmissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.close, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 20),
                const Text(
                  "No Answer Select",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Please select a answer",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Background color
                  ),
                  child: const Text("Ok"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget loadingScreen() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/exam_loading_2.json", height: 150),
            const Gap(5),
            const Text(
              "Hang tight! We’re getting your exam ready for you.",
              style: TextStyle(fontSize: 16),
            ),
            const Gap(10),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.5,
              child: const LinearProgressIndicator(),
            ),
            const Gap(20)
          ],
        ),
      ],
    );
  }
}

class PlayedAudios {
  // Properties
  final String audioType;
  final int audioId;

  // Constructor
  PlayedAudios({
    required this.audioType,
    required this.audioId,
  });

  // Override toString for easier debugging
  @override
  String toString() {
    return 'PlayedAudios(audioType: $audioType, audioId: $audioId)';
  }
}
