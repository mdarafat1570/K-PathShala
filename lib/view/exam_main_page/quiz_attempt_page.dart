import 'dart:async';
import 'dart:developer';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/model/question_model/reading_question_page_model.dart';
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

class RetakeTestPageState extends State<RetakeTestPage> {
  int _remainingTime = 3600;

  late Timer _timer;
  int _currentTabIndex = 0;

  int _selectedTotalIndex = -1;
  int _selectedSolvedIndex = -1;
  int _selectedTotalIndex2 = -1;
  int _selectedSolvedIndex2 = -1;
  ReadingQuestions? _selectedQuestionData;
  final ReadingQuestionsRepository _repository = ReadingQuestionsRepository();
  List<ReadingQuestions> _readingQuestions = [];
  bool dataFound = false;
  bool isListViewVisible = true;

  @override
  void initState() {
    super.initState();
    // _startTimer();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _fetchReadingQuestions();
  }

  Future<void> _fetchReadingQuestions() async {
    try {
      // Attempt to fetch the questions
      QuestionsModel? questionsModel =
          await _repository.fetchReadingQuestions(widget.questionSetId);

      if (questionsModel != null && questionsModel.data != null) {
        _readingQuestions = questionsModel.data!.readingQuestions ?? [];
        log(jsonEncode(_readingQuestions));
        setState(() {
          dataFound = true;
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Failed to load reading questions. Please try again.')),
      );
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

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
            isListViewVisible = true;
          });
        } else {
          Navigator.pop(context);
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space between items
              children: [
                if (!isListViewVisible)
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.2,
                    child: ElevatedButton(
                      onPressed: () {
                        isListViewVisible = true;
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: AppColor.grey400, width: 1),
                        ),
                        backgroundColor: AppColor.grey200, // Change color as needed
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
                const Spacer(),// Spacing between buttons
                if (!isListViewVisible && _selectedQuestionData != null && _readingQuestions.indexOf(_selectedQuestionData!) > 0)
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
                      backgroundColor: AppColor.grey300, // Change color as needed
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
                if ((isListViewVisible || (_selectedQuestionData != null && _readingQuestions.indexOf(_selectedQuestionData!) == _readingQuestions.length -1)))
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.2,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: AppColor.navyBlue, // Change color as needed
                    ),
                    child: const Text('Submit Answer',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if ((!isListViewVisible && (_selectedQuestionData != null && _readingQuestions.indexOf(_selectedQuestionData!) < _readingQuestions.length -1)))
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.2,
                  child: ElevatedButton(
                    onPressed:moveToNext,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: AppColor.navyBlue, // Change color as needed
                    ),
                    child: const Text('Next',
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

  Column pageHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/new_App_icon.png'),
                    ),
                    Gap(10),
                    Expanded(
                        child: Text(
                      "Mahmud Ebne Zaman",
                      style: TextStyle(color: AppColor.grey700, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    )),
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
                        decoration: isListViewVisible ? const BoxDecoration(
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
                            )) : null,
                        child: Text(
                          'Total Questions',
                          style: TextStyle(color: isListViewVisible ? Colors.white : AppColor.grey700, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        )),
                    if (!isListViewVisible)
                    Container(
                      height: 20,
                      width: 2,
                      color: AppColor.grey400,
                    ),
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      child: const Text(
                        'Solved Questions',
                        style: TextStyle(color: AppColor.grey700, fontSize: 14),
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
                      child: const Text(
                        'Unsolved Questions',
                        style: TextStyle(color: AppColor.grey700, fontSize: 14),
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
                          fontSize: 14,
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
    if (_selectedQuestionData == null) return const SizedBox.shrink();
    final options = _selectedQuestionData?.options ?? [];
    bool isTextType = options.isNotEmpty && options.first.optionType == 'text';
    return Stack(
      children: [
        // Watermark Image
        Positioned.fill(
          child: Opacity(
            opacity: 0.1, // Adjust opacity for the watermark effect
            child: Image.asset(
              'assets/new_App_icon.png',
              height: 80,
              width: 150,
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
                        if ((_selectedQuestionData?.title ?? "")
                            .isNotEmpty) // Check for null or empty
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: customText(
                              _selectedQuestionData?.title ?? "",
                              TextType.paragraphTitle,
                              fontSize: 20,
                            ),
                          ),
                        if ((_selectedQuestionData?.subtitle ?? "")
                            .isNotEmpty) // Check for null or empty
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: customText(
                              _selectedQuestionData?.subtitle ?? "",
                              TextType.subtitle,
                              fontSize: 20,
                            ),
                          ),
                        if ((_selectedQuestionData?.imageCaption ?? "")
                            .isNotEmpty) // Check for null or empty
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: customText(
                              _selectedQuestionData?.imageCaption ?? "",
                              TextType.subtitle,
                              fontSize: 20,
                            ),
                          ),
                        if ((_selectedQuestionData?.question ?? "")
                            .isNotEmpty) // Check for null or empty
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
                              child: customText(
                                  _selectedQuestionData?.question ?? "",
                                  TextType.paragraphTitle,
                                  textAlign: TextAlign.center),
                            ),
                          ),
                        if ((_selectedQuestionData?.imageUrl ?? "")
                            .isNotEmpty) // Check for null or empty
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
                              child: Image.network(
                                _selectedQuestionData?.imageUrl ?? "",
                                errorBuilder: (context, error, stackTrace) {
                                  // Show something when the image fails to load
                                  return const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.broken_image,
                                          color: AppColor.navyBlue,
                                          size: 50), // Error icon
                                      SizedBox(height: 10),
                                      Text(
                                        "Image failed to load",
                                        style: TextStyle(
                                            color: AppColor.navyBlue, fontSize: 16),
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
                              String answer =
                                  options[index].title; // Access option title
                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedSolvedIndex = index;
                                    });
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
                                              color: (_selectedSolvedIndex ==
                                                      index)
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
                                              color: (_selectedSolvedIndex ==
                                                      index)
                                                  ? const Color.fromRGBO(
                                                      255, 255, 255, 1)
                                                  : AppColor.black,
                                            ),
                                          )),
                                        ),
                                        const SizedBox(width: 8),
                                        // Spacing between circle and text
                                        Expanded(
                                          child: Text(
                                            answer,
                                            style: const TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        if((options[index].subtitle ?? "").isNotEmpty)
                                        Expanded(
                                          child: Text(
                                            options[index].subtitle ?? "",
                                            style: const TextStyle(fontSize: 18),
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
                              String answer =
                                  options[index].imageUrl ?? ""; // Access option title
                              return Padding(
                                padding: const EdgeInsets.all(8),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedSolvedIndex = index;
                                    });
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
                                              color: (_selectedSolvedIndex ==
                                                      index)
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
                                              color: (_selectedSolvedIndex ==
                                                      index)
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
                                            Expanded(
                                              child: Image.network(
                                                answer,
                                                errorBuilder: (context, error, stackTrace) {
                                                  // Show something when the image fails to load
                                                  return const Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.broken_image,
                                                          color: AppColor.navyBlue,
                                                          size: 30), // Error icon
                                                      SizedBox(height: 5),
                                                      Text(
                                                        "Image failed to load",
                                                        style: TextStyle(
                                                            color: AppColor.navyBlue, fontSize: 12),
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
                                            if((options[index].subtitle ?? "").isNotEmpty)
                                            Expanded(
                                              child: Text(
                                                options[index].subtitle ?? "",
                                                style: const TextStyle(fontSize: 18),
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
                      " 듣기 (${_readingQuestions.length}Question)",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 10),
                  child: questionsGrid(20, true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<int> solvedReadingQuestions = [];
  List<int> solvedListeningQuestions = [];

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
        // Check if this index is selected
        bool isSelected = (!isListening)
            ? solvedReadingQuestions.contains(index)
            : solvedListeningQuestions.contains(index);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (!isListening) {
                if (isSelected) {
                  // If already selected, remove from selectedIndexes
                  solvedReadingQuestions.remove(index);
                  _selectedQuestionData = null;
                } else {
                  // If not selected, add to selectedIndexes
                  solvedReadingQuestions.add(index);
                  _selectedQuestionData = _readingQuestions[index];
                  isListViewVisible = false;
                }
              } else {
                if (isSelected) {
                  // If already selected, remove from selectedIndexes
                  solvedListeningQuestions.remove(index);
                } else {
                  // If not selected, add to selectedIndexes
                  solvedListeningQuestions.add(index);
                }
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColor.skyBlue // Selected color
                  : const Color.fromRGBO(245, 247, 250, 1), // Default color
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                '${index + 1}', // Button text (1, 2, 3, ...)
                style: TextStyle(
                  fontSize: 18,
                  color: isSelected
                      ? const Color.fromRGBO(
                          245, 247, 250, 1) // Text color when selected
                      : AppColor.navyBlue, // Default text color
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void moveToPrevious (){
    int index = (_selectedQuestionData != null)
        ? _readingQuestions.indexOf(_selectedQuestionData!)
        : -1;
    if (index > 0 ){
      _selectedQuestionData = _readingQuestions[index-1];
      setState(() {});
    }

  }
  void moveToNext (){
    int index = (_selectedQuestionData != null)
        ? _readingQuestions.indexOf(_selectedQuestionData!)
        : -1;
    if (index < _readingQuestions.length ){
      _selectedQuestionData = _readingQuestions[index + 1];
      setState(() {});
    } else {
      setState(() {});
    }

  }
}
