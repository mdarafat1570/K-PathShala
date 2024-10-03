import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
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
import 'package:kpathshala/view/exam_main_page/quiz_attempt_page/widgets/build_question_navbar_button.dart';
import 'package:kpathshala/view/exam_main_page/quiz_attempt_page/widgets/exam_loading_screen.dart';
import 'package:kpathshala/view/exam_main_page/quiz_attempt_page/widgets/exam_page_dialogs.dart';
import 'package:kpathshala/view/exam_main_page/quiz_attempt_page/widgets/played_audio_object.dart';
import 'package:kpathshala/view/exam_main_page/quiz_attempt_page/widgets/show_zoom_image.dart';

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

  ReadingQuestions? _selectedReadingQuestionData;
  ListeningQuestions? _selectedListeningQuestionData;
  LogInCredentials? credentials;

  List<ReadingQuestions> _readingQuestions = [];
  List<ListeningQuestions> _listeningQuestions = [];
  List<Dialogue> dialogue = [];
  List<Answers> solvedReadingQuestions = [];
  List<Answers> solvedListeningQuestions = [];
  List<dynamic> availableVoices = [];
  List<PlayedAudios> playedAudiosList = [];

  bool dataFound = false,
      shuffleOptions = false;
  bool isListViewVisible = true;
  bool firstSpeechCompleted = false;
  bool isInDelay = false;
  bool isSpeaking = false;
  bool _isTimeUp = false;

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

  Future<void> _speak(String? model, String voiceScript,
      {bool? isDialogue = false}) async
  {
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
    if (firstSpeechCompleted && !isDialogue!) {
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
        _readingQuestions = questionsModel.data?.readingQuestions ?? [];
        _listeningQuestions = questionsModel.data?.listeningQuestions ?? [];

        await _preloadImages();

        totalQuestion = questionsModel.data?.totalQuestion ?? 0;
        _remainingTime = (questionsModel.data?.duration ?? 60) *
            60; // Set your initial remaining time
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

    for (ReadingQuestions question in _readingQuestions) {
      if (question.imageUrl != null && question.imageUrl!.isNotEmpty) {
        preloadFutures.add(_cacheImage(question.imageUrl!));
      }

      for (var option in question.options) {
        if (option.imageUrl != null && option.imageUrl!.isNotEmpty) {
          preloadFutures.add(_cacheImage(option.imageUrl!));
        }
      }
    }

    for (ListeningQuestions question in _listeningQuestions) {
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
            showTimeUpDialog: true,
            onPrimaryAction: () {
              submitAnswer(isTimeUp: true);
              Navigator.pop(context);
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
      builder: (context) =>
          AlertDialog(
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
                ? loadingScreen(context)
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
              : buildBottomNavBar(),
      ),
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
                            : "Total Questions - ${_readingQuestions.length +
                            _listeningQuestions.length}",
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
    // int index = isListening
    //     ? _listeningQuestions.indexOf(_selectedListeningQuestionData!)
    //     : _readingQuestions.indexOf(_selectedReadingQuestionData!);
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
    dialogue = _selectedListeningQuestionData?.dialogues ?? [];
    final listeningQuestionType =
        _selectedListeningQuestionData?.questionType ?? "";
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
            (answer) =>
        answer.questionId == _selectedListeningQuestionData?.id))) {
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
              height: MediaQuery
                  .sizeOf(context)
                  .height * 0.7,
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
                    width: MediaQuery
                        .sizeOf(context)
                        .width * 0.45,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            voiceScript.isNotEmpty ||
                            dialogue.isNotEmpty) // Check for null or empty
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
                                        showZoomedImage(context, imageUrl, cachedImages);
                                      },
                                      child: cachedImages.containsKey(imageUrl)
                                          ? Image.memory(
                                        cachedImages[imageUrl]!,
                                        fit: BoxFit
                                            .cover, // Ensure the image fits well in its container
                                      )
                                          : const CircularProgressIndicator(), // Show loading if image is not yet cached
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
                                  if (listeningQuestionType != 'dialogues'
                                      ? voiceScript.isNotEmpty
                                      : dialogue.isNotEmpty)
                                    InkWell(
                                      onTap: exists
                                          ? null
                                          : () async {
                                        if (!isSpeaking && !isInDelay) {
                                          playedAudiosList.add(
                                              PlayedAudios(
                                                  audioId: questionId,
                                                  audioType: "question"));
                                          if (listeningQuestionType !=
                                              "dialogues") {
                                            _speak(
                                                _selectedListeningQuestionData
                                                    ?.voiceGender,
                                                voiceScript);
                                          } else {
                                            int i = 1;
                                            dialogue.sort((a, b) =>
                                                (a.sequence ?? 0).compareTo(
                                                    b.sequence ?? 0));
                                            for (var voice in dialogue) {
                                              log(
                                                  "play sequence ${i++}______________");
                                              await _speak(voice.voiceGender,
                                                  voice.voiceScript ?? '',
                                                  isDialogue: true);
                                            }
                                            await Future.delayed(
                                                const Duration(seconds: 3));
                                            for (var voice in dialogue) {
                                              log(
                                                  "play sequence ${i++}______________");
                                              await _speak(voice.voiceGender,
                                                  voice.voiceScript ?? '',
                                                  isDialogue: true);
                                            }
                                          }
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
                    width: MediaQuery
                        .sizeOf(context)
                        .width * 0.45,
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
                                        if (!isSpeaking &&
                                            !isInDelay) {
                                          playedAudiosList.add(
                                              PlayedAudios(
                                                  audioId: answerId,
                                                  audioType:
                                                  "option"));
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
                        int answerId = options[index].id ?? -1;
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
                                        showZoomedImage(context, answerImage, cachedImages);
                                      },
                                      child: cachedImages.containsKey(
                                          answerImage)
                                          ? Image.memory(
                                        cachedImages[answerImage]!,
                                        fit: BoxFit
                                            .cover, // Ensure the image fits well in its container
                                      )
                                          : const Padding(
                                        padding: EdgeInsets.all(1.0),
                                        child: CircularProgressIndicator(),
                                      ), // Show loading if image is not yet cached
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

  Widget buildGridContent({
    required bool isSolved,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionColumn(
            image: "assets/book-open.png",
            title: "읽기 (${_readingQuestions.length} Questions)",
            questions: _readingQuestions,
            isReading: true,
          ),
          _buildQuestionColumn(
            image: "assets/headphones.png",
            title: "듣기 (${_listeningQuestions.length} Questions)",
            questions: _listeningQuestions,
            isReading: false,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionColumn({
    required String image,
    required String title,
    required List questions,
    required bool isReading,
  }) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(image, height: 16),
              Text(
                title,
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
                : questions.isEmpty
                ? const Center(child: Text("No Questions Available"))
                : questionsGrid(questions.length, isReading),
          ),
        ],
      ),
    );
  }

  Padding buildBottomNavBar(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!isListViewVisible)
            buildQuestionNavbarButton(
              context,
              'Total Questions',
              AppColor.grey200,
                  () {
                isListViewVisible = true;
                _selectedReadingQuestionData = null;
                _selectedListeningQuestionData = null;
                _stopSpeaking();
                setState(() {});
              },
            ),
          const Spacer(), // Spacing between buttons
          if (isPreviousButtonVisible())
            buildQuestionNavbarButton(
              context,
              'Previous',
              AppColor.grey300,
              moveToPrevious,
            ),
          const SizedBox(width: 10),
          if (isSubmitAnswerButtonVisible())
            buildQuestionNavbarButton(
              context,
              'Submit Answer',
              AppColor.navyBlue,
              checkAnswerLength,
              textColor: Colors.white,
            ),
          if (isNextButtonVisible())
            buildQuestionNavbarButton(
              context,
              'Next',
              AppColor.navyBlue,
              moveToNext,
              textColor: Colors.white,
            ),
        ],
      ),
    );
  }

  bool isPreviousButtonVisible() {
    if (isListViewVisible) return false;

    if (_selectedListeningQuestionData != null) return true;

    return _selectedReadingQuestionData != null &&
        _readingQuestions.indexOf(_selectedReadingQuestionData!) > 0;
  }

  bool isNextButtonVisible() {
    if (isListViewVisible) return false;

    if (_selectedReadingQuestionData != null) return true;

    return _selectedListeningQuestionData != null &&
        _listeningQuestions.indexOf(_selectedListeningQuestionData!) <
            _listeningQuestions.length - 1;
  }

  bool isSubmitAnswerButtonVisible() {
    return isListViewVisible ||
        (_selectedListeningQuestionData != null &&
            _listeningQuestions.indexOf(_selectedListeningQuestionData!) ==
                _listeningQuestions.length - 1);
  }

  void moveToPrevious() {
    _stopSpeaking();

    void updateSelectedData<T>(List<T> questions, T? selectedData, Function(T?) setSelectedData) {
      int index = questions.indexOf(selectedData as T);
      setSelectedData((index > 0) ? questions[index - 1] : null);
      setState(() {});
    }

    if (_selectedListeningQuestionData != null) {
      updateSelectedData(_listeningQuestions, _selectedListeningQuestionData, (data) {
        _selectedListeningQuestionData = data;
        if (data == null && _readingQuestions.isNotEmpty) {
          _selectedReadingQuestionData = _readingQuestions.last;
        }
      });
    } else if (_selectedReadingQuestionData != null) {
      updateSelectedData(_readingQuestions, _selectedReadingQuestionData, (data) {
        _selectedReadingQuestionData = data;
      });
    }
  }

  void moveToNext() {
    _stopSpeaking();

    void updateSelectedData<T>(List<T> questions, T? selectedData, Function(T?) setSelectedData) {
      int index = questions.indexOf(selectedData as T);
      setSelectedData((index != -1 && index < questions.length - 1) ? questions[index + 1] : null);
      setState(() {});
    }

    if (_selectedReadingQuestionData != null) {
      updateSelectedData(_readingQuestions, _selectedReadingQuestionData, (data) {
        _selectedReadingQuestionData = data;
        if (data == null) {
          _selectedListeningQuestionData = _listeningQuestions.isNotEmpty ? _listeningQuestions[0] : null;
        }
      });
    } else if (_selectedListeningQuestionData != null) {
      updateSelectedData(_listeningQuestions, _selectedListeningQuestionData, (data) {
        _selectedListeningQuestionData = data;
      });
    }
  }

  int calculateSolved() {
    return solvedReadingQuestions.length + solvedListeningQuestions.length;
  }

  int calculateUnsolved() {
    return (_readingQuestions.length + _listeningQuestions.length) - calculateSolved();
  }

  void checkAnswerLength() {
    _stopSpeaking();
    int answerLength = solvedReadingQuestions.length +
        solvedListeningQuestions.length;
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

    final combinedList = [...solvedReadingQuestions, ...solvedListeningQuestions];

    if (combinedList.isEmpty) {
      showCustomDialog(
        context: context,
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
