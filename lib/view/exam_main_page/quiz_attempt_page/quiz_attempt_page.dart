import 'dart:async';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/model/log_in_credentials.dart';
import 'package:kpathshala/model/question_model/answer_model.dart';
import 'package:kpathshala/model/question_model/reading_question_page_model.dart';
import 'package:kpathshala/repository/authentication_repository.dart';
import 'package:kpathshala/repository/question/reading_questions_repository.dart';

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

  late Timer _timer;

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
  bool dataFound = false, shuffleOptions = false;
  bool isListViewVisible = true;
  static const platform =
      MethodChannel('com.inferloom.kpathshala/exit_confirmation');
  final AuthService _authService = AuthService();
  LogInCredentials? credentials;
  late FlutterTts flutterTts;
  String? selectedLanguage;
  String? selectedEngine;
  String? selectedVoice;
  List<dynamic> availableVoices = [];
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
    //   log("Ureka------------------------");
    //   if (call.method == 'onUserLeaveHint') {
    //     // return await _showExitExamConfirmation(context);
    //   }
    //   return null;
    // });
    readCredentials();
    initTts();
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
  }

  Future<void> _getVoices() async {
    List<dynamic> voices = await flutterTts.getVoices as List<dynamic>;

    // Filter only Korean voices
    setState(() {
      availableVoices = voices.where((voice) {
        // Check if the voice is a Map and has the correct keys
        if (voice is Map && voice.containsKey('locale') && voice.containsKey('name')) {
          return voice['locale'] == 'ko-KR';
        }
        return false;
      }).map((voice) {
        // Ensure the map is correctly typed
        return {
          'name': voice['name'] as String,
          'locale': voice['locale'] as String,
        } as Map<String, String>;
      }).toList();

      // Set default voice if available
      selectedVoice = availableVoices.isNotEmpty ? availableVoices[0]['name'] : null;
    });
  }


  Future<void> _speak(String? model, String voiceScript) async {
    _newVoiceText = voiceScript;
    if (_newVoiceText == null || _newVoiceText!.isEmpty) {
      log("No text provided for speech.");
      return;
    }

    await flutterTts.setVolume(volume);
    await flutterTts.setPitch(pitch);
    await flutterTts.setSpeechRate(rate);

    if (model == "female" || model == null){
      selectedVoice = "ko-kr-x-ism-local";
    } else {
      selectedVoice = "ko-kr-x-kod-local";
    }

    if (selectedVoice != null) {
      // Safely retrieve the voice map
      Map<String, String>? voice = availableVoices.firstWhere(
            (v) => v['name'] == selectedVoice,
        orElse: () => {'name': '', 'locale': ''}, // Return a default map instead of null
      ) as Map<String, String>?; // Ensure the correct type

      if (voice != null && voice['name']!.isNotEmpty) {
        await flutterTts.setVoice(voice);
        log("Using voice: ${voice['name']}");
      } else {
        log("Selected voice not found.");
        return;
      }
    }

    log("Speaking: $_newVoiceText");
    await flutterTts.speak(_newVoiceText!);
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
      // Attempt to fetch the questions
      QuestionsModel? questionsModel =
          await _repository.fetchReadingQuestions(widget.questionSetId,context);

      if (questionsModel != null && questionsModel.data != null) {
        _readingQuestions = questionsModel.data?.readingQuestions ?? [];
        _listeningQuestions = questionsModel.data?.listeningQuestions ?? [];
        _remainingTime = (questionsModel.data?.duration ?? 60)* 60;
        setState(() {
          dataFound = true;
          _startTimer();
        });
      } else {
        log('Questions model or data is null');
        setState(() {
          dataFound = true;
        });
      }
    } catch (error, stackTrace) {
      // Log the error and stack trace for debugging purposes
      log('Error fetching reading questions: $error');
      log('Stack trace: $stackTrace');

      // Optionally, show an error message to the user (Snackbar, Dialog, etc.)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Failed to load reading questions. Please try again.')),
        );
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer.cancel();
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
          content: const Text('Your time for the test has ended.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
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
    _timer.cancel();
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
            child: Column(
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
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
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
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
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
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
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
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
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
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
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
                              fontSize: 12,
                              color: AppColor.grey700),
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

  Widget buildQuestionDetailContent(// required bool isSolved,
      ) {
    if (_selectedReadingQuestionData == null && _selectedListeningQuestionData == null) return const SizedBox.shrink();
    bool isListening = _selectedReadingQuestionData == null;
    int index = isListening ? _listeningQuestions.indexOf(_selectedListeningQuestionData!) : _readingQuestions.indexOf(_selectedReadingQuestionData!);
    final title = isListening ?_selectedListeningQuestionData?.title ?? ""  : _selectedReadingQuestionData?.title ?? "";
    final subTitle = isListening ?_selectedListeningQuestionData?.subtitle ?? ""  : _selectedReadingQuestionData?.subtitle ?? "";
    final imageCaption = isListening ?_selectedListeningQuestionData?.imageCaption ?? ""  : _selectedReadingQuestionData?.imageCaption ?? "";
    final question = _selectedReadingQuestionData?.question ?? "";
    final imageUrl = isListening ?_selectedListeningQuestionData?.imageUrl ?? ""  : _selectedReadingQuestionData?.imageUrl ?? "";
    final voiceScript = _selectedListeningQuestionData?.voiceScript ?? "";
    final options = isListening ?_selectedListeningQuestionData?.options ?? []  : _selectedReadingQuestionData?.options ?? [];
    bool isTextType = options.isNotEmpty && options.first.optionType == 'text';
    int questionId = isListening ? _selectedListeningQuestionData?.id ?? -1 :  _selectedReadingQuestionData?.id ?? -1;
    int selectedSolvedIndex = -1;
    if (!isListening && (solvedReadingQuestions.any((answer) => answer.questionId == _selectedReadingQuestionData?.id))) {
      // Find the solved question's matching index in options
      selectedSolvedIndex = options.indexWhere((option) =>
          option.id ==
          solvedReadingQuestions
              .firstWhere(
                  (answer) => answer.questionId == _selectedReadingQuestionData?.id)
              .questionOptionId);
    }
    else if ((solvedListeningQuestions.any((answer) => answer.questionId == _selectedListeningQuestionData?.id))){
      selectedSolvedIndex = options.indexWhere((option) =>
      option.id ==
          solvedListeningQuestions
              .firstWhere(
                  (answer) => answer.questionId == _selectedListeningQuestionData?.id)
              .questionOptionId);
    }

    void selectionHandling (index, answerId) {
      setState(() {
        selectedSolvedIndex = index;

        // Create a new Answers object based on the selected option
        Answers selectedAnswer = Answers(
          questionId: questionId,
          questionOptionId: answerId,
        );

        // Check if the answer already exists in solvedReadingQuestions
        int existingAnswerIndex = -1;
        if (isListening){
          existingAnswerIndex = solvedListeningQuestions.indexWhere((answer) => answer.questionId == selectedAnswer.questionId);
        } else{
          existingAnswerIndex = solvedReadingQuestions.indexWhere((answer) => answer.questionId == selectedAnswer.questionId);
        }

        if (existingAnswerIndex != -1) {
          // Update the existing answer with the new selected option ID
          isListening ? solvedListeningQuestions[existingAnswerIndex].questionOptionId = answerId : solvedReadingQuestions[existingAnswerIndex].questionOptionId = answerId;
        } else {
          // Add the new answer to the list if it doesn't exist
          isListening ? solvedListeningQuestions.add(selectedAnswer) : solvedReadingQuestions.add(selectedAnswer);
        }
      });
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
                        if (question.isNotEmpty || imageUrl.isNotEmpty || voiceScript.isNotEmpty) // Check for null or empty
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
                                        question,
                                        TextType.paragraphTitle,
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
                                  if (voiceScript.isNotEmpty)
                                    InkWell(
                                      onTap: (){
                                        _speak(_selectedListeningQuestionData?.voiceGender, voiceScript);
                                      },
                                      child: Image.asset("assets/speaker.png",height: 100, color: AppColor.navyBlue,),
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
                    child: isTextType
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

                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: InkWell(
                                  onTap: (){
                                    selectionHandling(index, answerId);
                                  },
                                  child: SizedBox(
                                    height: 45,
                                    width: 355,
                                    child: Row(
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
                                                color: AppColor.black),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${index + 1}',
                                              style: TextStyle(
                                                color: (selectedSolvedIndex ==
                                                        index)
                                                    ? const Color.fromRGBO(
                                                        255, 255, 255, 1)
                                                    : AppColor.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (answer.isNotEmpty)
                                                Expanded(
                                                child: Text(
                                                  answer,
                                                  style: const TextStyle(
                                                      fontSize: 18),
                                                ),
                                              ),
                                              if ((options[index].subtitle ??
                                                      "")
                                                  .isNotEmpty)
                                                Expanded(
                                                  child: Text(
                                                    options[index].subtitle ??
                                                        "",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            AppColor.grey500),
                                                  ),
                                                )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
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
                              crossAxisCount:
                                  2, // Number of columns in grid view
                              childAspectRatio:
                                  2, // Adjust this to control item size
                            ),
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              String answer = options[index].title ?? "";
                              String answerImage = options[index].imageUrl ?? "";
                              int answerId = options[index].id ?? -1;
                              String voiceScript = options[index].voiceScript ?? "";
                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: InkWell(
                                  onTap: (){
                                    selectionHandling(index, answerId);
                                  },
                                  child: SizedBox(
                                    // height: 45,
                                    // width: 355,
                                    child: Row(
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
                                        Column(
                                          children: [
                                            if (answerImage.isNotEmpty)
                                              Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  showZoomedImage(answerImage);
                                                },
                                                child: Image.network(
                                                  answerImage,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    // Show something when the image fails to load
                                                    return const Icon(Icons.broken_image,
                                                        color: AppColor
                                                            .navyBlue,
                                                        size: 20);
                                                  },
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child; // Image loaded successfully
                                                    } else {
                                                      // Show a loading indicator while the image is being loaded
                                                      return const CircularProgressIndicator();
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                            if (voiceScript.isNotEmpty)
                                              InkWell(
                                                onTap: (){
                                                  _speak(_selectedListeningQuestionData?.voiceGender, voiceScript);
                                                },
                                                child: Image.asset("assets/speaker.png",height: 40, color: AppColor.navyBlue,),
                                              ),
                                            if (answer.isNotEmpty)
                                              Expanded(
                                                child: Text(
                                                  answer,
                                                  style: const TextStyle(
                                                      fontSize: 18),
                                                ),
                                              ),
                                            if ((options[index].subtitle ?? "")
                                                .isNotEmpty)
                                              Expanded(
                                                child: Text(
                                                  options[index].subtitle ?? "",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: AppColor.grey500),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
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

  List<Answers> solvedReadingQuestions = [];
  List<Answers> solvedListeningQuestions = [];

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
                isListening ? '${_readingQuestions.length+index+1}' : '${index + 1}',
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

  bool isPreviousButtonVisible(){
    if (!isListViewVisible && _selectedReadingQuestionData != null && _selectedListeningQuestionData == null) {
      return (_readingQuestions.indexOf(_selectedReadingQuestionData!) > 0);
    } else if (!isListViewVisible &&_selectedListeningQuestionData != null) {
      return true;
    } else {
      return false;
    }
  }

  bool isNextButtonVisible(){
    if (!isListViewVisible && _selectedReadingQuestionData == null && _selectedListeningQuestionData != null) {
      return (_listeningQuestions.indexOf(_selectedListeningQuestionData!) < _listeningQuestions.length -1);
    } else if (!isListViewVisible && _selectedReadingQuestionData != null) {
      return true;
    } else {
      return false;
    }
  }

  bool isSubmitAnswerButtonVisible (){
    return isListViewVisible || (_selectedListeningQuestionData != null &&
        _listeningQuestions.indexOf(_selectedListeningQuestionData!) ==
            _listeningQuestions.length - 1);
  }

  void moveToPrevious() {
    void updateSelectedData<T>(List<T> questions, T? selectedData, Function(T?) setSelectedData) {
      int index = questions.indexOf(selectedData!);
      if (index > 0) {  // Ensure it's not the first item
        setSelectedData(questions[index - 1]);
      } else {
        setSelectedData(null);
      }
      setState(() {});
    }

    if (_selectedListeningQuestionData != null) {
      updateSelectedData(_listeningQuestions, _selectedListeningQuestionData, (data) {
        _selectedListeningQuestionData = data;
        if (data == null && _readingQuestions.isNotEmpty) {
          _selectedReadingQuestionData = _readingQuestions[_readingQuestions.length - 1];
        }
      });
    } else if (_selectedReadingQuestionData != null) {
      updateSelectedData(_readingQuestions, _selectedReadingQuestionData, (data) {
        _selectedReadingQuestionData = data;
      });
    }
  }

  void moveToNext() {
    void updateSelectedData<T>(List<T> questions, T? selectedData, Function(T?) setSelectedData) {
      int index = questions.indexOf(selectedData!);
      if (index != -1 && index < questions.length - 1) {
        setSelectedData(questions[index + 1]);
      } else {
        setSelectedData(null);
      }
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

  int calculateSolved (){
    return solvedReadingQuestions.length + solvedListeningQuestions.length;
  }

  int calculateUnsolved (){
    return (_readingQuestions.length + _listeningQuestions.length) -calculateSolved();
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
}
