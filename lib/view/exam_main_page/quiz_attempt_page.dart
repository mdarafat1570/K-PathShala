import 'dart:async';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/view/exam_main_page/questionDetailPage.dart';
import 'package:kpathshala/view/exam_main_page/readingQuestions/reading_questions_bottom_list.dart'; // Adjust as per your project

class RetakeTestPage extends StatefulWidget {
  final String title;
  final String description;

  const RetakeTestPage({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  _RetakeTestPageState createState() => _RetakeTestPageState();
}

class _RetakeTestPageState extends State<RetakeTestPage> {
  int _remainingTime = 3600; // 1 hour in seconds
  late Timer _timer;
  int _currentTabIndex = 0; // Index to track the selected tab
  int _selectedTotalIndex =
      -1; // To track the selected question button in total questions
  int _selectedSolvedIndex = -1;
  int _selectedTotalIndex2 =
      -1; // To track the selected question button in total questions
  int _selectedSolvedIndex2 =
      -1; // To track the selected question button in solved questions
  Map<String, dynamic>? _selectedQuestionData;
  @override
  void initState() {
    super.initState();
    _startTimer();
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
              child: const Text('OK'),
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
      body: Column(
        children: [
          const Gap(20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Container(
                            height: 40,
                            width: 80,
                            child: const FittedBox(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        AssetImage('assets/new_App_icon.png'),
                                  ),
                                  Gap(10),
                                  Center(child: Text("Trying")),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      bool isClickable = index == 0;
                      return GestureDetector(
                        onTap: () {
                          isClickable
                              ? () {
                                  setState(() {
                                    _currentTabIndex = index;
                                  });
                                }
                              : null;
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            border: const Border(
                              right: BorderSide(
                                width: 3,
                                color: AppColor.navyBlue,
                              ),
                            ),
                            color: _currentTabIndex == index
                                ? AppColor.navyBlue
                                : Colors.grey[300],
                            borderRadius: _currentTabIndex == index
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10))
                                : BorderRadius.zero,
                          ),
                          child: Text(
                            index == 0
                                ? 'Total Questions'
                                : index == 1
                                    ? 'Solved Questions'
                                    : 'Unsolved Questions',
                            style: TextStyle(
                              color: _currentTabIndex == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      );
                    })
                      ..add(
                        GestureDetector(
                          onTap: null,
                          child: FittedBox(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(12.0),
                              decoration: const BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        width: 1, color: AppColor.navyBlue),
                                    bottom: BorderSide(
                                        width: 1, color: AppColor.navyBlue),
                                    right: BorderSide(
                                        width: 1, color: AppColor.navyBlue)),
                                color: Color.fromRGBO(26, 35, 126, 0.2),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15)),
                              ),
                              child: Text(
                                _formattedTime,
                                style: const TextStyle(
                                  color: AppColor.navyBlue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ),
                ),
                const Gap(80),
              ],
            ),
          ),
          const Divider(
            color: AppColor.navyBlue,
            thickness: 0.8,
          ),

          //  Content for the selected tab
          Expanded(
            child: buildTabContent(_currentTabIndex),
          ),
        ],
      ),
    );
  }

  //Helper method to generate content for each tab
  Widget buildTabContent(int index) {
    if (_selectedQuestionData != null) {
      // If a question is selected, show the question details
      return buildQuestionDetailContent();
    }
    switch (index) {
      case 0:
        return buildGridContent(
          title: 'Sample Title',
          description: 'This is a sample description.',
          questionCount: 10,
          isSolved: false,
          questionSetId: 1,
        );
      case 1:
        return buildGridContent(
          title: 'Sample Title',
          description: 'This is a sample description.',
          questionCount: 10,
          isSolved: false,
          questionSetId: 1,
        );
      case 2:
        return buildGridContent(
          title: 'Sample Title',
          description: 'This is a sample description.',
          questionCount: 10,
          isSolved: false,
          questionSetId: 1,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget buildQuestionDetailContent(
      // required bool isSolved,
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
                          child: Container(
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
                                  )), // Displaying 1, 2, 3, 4
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
                          child: Text("Total questions"),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromRGBO(26, 35, 126, 0.1)), // Wrap color
                          ),
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
    required String title,
    required String description,
    required int questionCount,
    required bool isSolved,
    required int questionSetId, // Add the required questionSetId parameter
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  // Use 'const' if the widget is constant and has no dynamic state.
                  child: ReadingQuestionsPage(questionSetId: 3),
                ),
              ],
            ),
          ),
          const SizedBox(width: 40), // Add spacing between the two columns
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  // Assuming ListeningQuestionList is also a widget that takes parameters
                  child: ListeningQuestionList(questionCount, isSolved),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  GridView ListeningQuestionList(int questionCount, bool isSolved) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      itemCount: questionCount,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSolved) {
                _selectedSolvedIndex2 = index;
              } else {
                _selectedTotalIndex2 = index;
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSolved
                  ? (_selectedSolvedIndex2 == index
                      ? AppColor.skyBlue
                      : const Color.fromRGBO(245, 247, 250, 1))
                  : (_selectedTotalIndex2 == index
                      ? AppColor.skyBlue
                      : const Color.fromRGBO(245, 247, 250, 1)),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                '${index + 1}', // Button text (1, 2, 3, ...)
                style: TextStyle(
                  fontSize: 18,
                  color: isSolved
                      ? (_selectedSolvedIndex2 == index
                          ? const Color.fromRGBO(245, 247, 250, 1)
                          : AppColor.skyBlue)
                      : (_selectedTotalIndex2 == index
                          ? AppColor.black
                          : AppColor.skyBlue),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
