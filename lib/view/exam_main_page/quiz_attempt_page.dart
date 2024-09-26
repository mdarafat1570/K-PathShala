import 'dart:async';
import 'dart:developer';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/model/question_model/reading_question_page_model.dart';
import 'package:kpathshala/repository/question/reading_questions_repository.dart';
import 'package:kpathshala/view/exam_main_page/readingQuestions/reading_questions_bottom_list.dart';

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

  // late Timer _timer;
  int _currentTabIndex = 0;

  int _selectedTotalIndex = -1;
  int _selectedSolvedIndex = -1;
  int _selectedTotalIndex2 = -1;
  int _selectedSolvedIndex2 = -1;
  Map<String, dynamic>? _selectedQuestionData;
  final ReadingQuestionsRepository _repository = ReadingQuestionsRepository();
  List<ReadingQuestions> _readingQuestions = [];
  bool dataFound = false;

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

  // void _startTimer() {
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     setState(() {
  //       if (_remainingTime > 0) {
  //         _remainingTime--;
  //       } else {
  //         _timer.cancel();
  //         _showTimeUpDialog();
  //       }
  //     });
  //   });
  // }
  //
  // void _showTimeUpDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('Time Up'),
  //         content: const Text('Your time for the test has ended.'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: const Text('OK'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  void dispose() {
    // _timer.cancel();
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
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: SafeArea(
        child: Column(
          children: [
            pageHeader(),
            //  Content for the selected tab
            Expanded(
              child: ListView(children: [
                buildGridContent(
                  description: 'This is a sample description.',
                  isSolved: false,
                ),
              ]),
            ),
          ],
        ),
      ),
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
                        decoration: const BoxDecoration(
                            border: const Border(
                              right: BorderSide(
                                width: 3,
                                color: AppColor.navyBlue,
                              ),
                            ),
                            color: AppColor.navyBlue,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            )),
                        child: const Text(
                          'Total Questions',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        )),
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
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(_selectedQuestionData!['title'],
                          TextType.paragraphTitle,
                          fontSize: 20),
                      const Gap(8),
                      customText(_selectedQuestionData!['description'],
                          TextType.subtitle,
                          fontSize: 20),
                      const Gap(28),
                      Container(
                        height: 135,
                        width: 355,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromRGBO(
                                  100,
                                  100,
                                  100,
                                  1,
                                ),
                                width: 1.5),
                            color: const Color.fromRGBO(26, 35, 126, 0.2),
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                            child: customText(
                                _selectedQuestionData!['Question'],
                                TextType.paragraphTitle)),
                      )
                    ],
                  ),
                  const Gap(48),
                  Column(
                    children:
                        (_selectedQuestionData!['answers'] as List<String>)
                            .asMap()
                            .entries
                            .map((entry) {
                      int index = entry.key; // Get the index
                      String answer = entry.value; // Get the answer
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
                                      color: (_selectedSolvedIndex == index)
                                          ? AppColor.black
                                          : const Color.fromRGBO(
                                              255, 255, 255, 1),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 2, color: AppColor.black)),
                                  child: Center(
                                      child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: (_selectedSolvedIndex == index)
                                          ? const Color.fromRGBO(
                                              255, 255, 255, 1)
                                          : AppColor.black,
                                    ),
                                  )),
                                ),
                                const SizedBox(
                                    width:
                                        8), // Add spacing between circle and text
                                Text(
                                  answer,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(245, 245, 245, 1)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 5, left: 24, right: 25, top: 5),
                    child: Row(
                      children: [
                        OutlinedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                const Color.fromRGBO(
                                    26, 35, 126, 0.1)), // Wrap color
                          ),
                          child: const Text("Total questions"),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget buildGridContent({
    required String description,
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
                          ? Center(child: Text("No Questions Available"))
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
                } else {
                  // If not selected, add to selectedIndexes
                  solvedReadingQuestions.add(index);
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
}
