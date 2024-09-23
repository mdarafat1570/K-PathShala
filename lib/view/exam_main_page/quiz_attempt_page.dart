import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kpathshala/app_base/common_imports.dart'; // Adjust as per your project

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
    return GradientBackground(
      child: Scaffold(
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
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentTabIndex = index;
                            });
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
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(12.0),
                              decoration: const BoxDecoration(
                                color: AppColor.navyBlue,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15),
                                ),
                              ),
                              child: Text(
                                _formattedTime,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
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

            // Content for the selected tab
            Expanded(
              child: buildTabContent(_currentTabIndex),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to generate content for each tab
  Widget buildTabContent(int index) {
    switch (index) {
      case 0:
        return buildGridContent(
          title: '읽기 (20 Question)',
          description: 'Here are all the questions.',
          questionCount: 20, // Total number of questions
          isSolved: false,
        );
      case 1:
        return buildGridContent(
          title: '듣기 (20 Question)',
          description: 'Here are all the solved questions.',
          questionCount: 10, // Example: 10 solved questions
          isSolved: true,
        );
      case 2:
        return buildGridContent(
          title: 'Unsolved Questions',
          description: 'Here are all the unsolved questions.',
          questionCount: 10, // Example: 10 unsolved questions
          isSolved: false,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  // Helper widget to generate content for a tab with grid buttons
  Widget buildGridContent({
    required String title,
    required String description,
    required int questionCount,
    required bool isSolved,
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
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                              _selectedSolvedIndex = index;
                            } else {
                              _selectedTotalIndex = index;
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSolved
                                ? (_selectedSolvedIndex == index
                                    ? AppColor.skyBlue
                                    : Color.fromRGBO(245, 247, 250, 1))
                                : (_selectedTotalIndex == index
                                    ? AppColor.skyBlue
                                    : Color.fromRGBO(245, 247, 250, 1)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}', // Button text (1, 2, 3, ...)
                              style: TextStyle(
                                fontSize: 18,
                                color: isSolved
                                    ? (_selectedSolvedIndex == index
                                        ? Color.fromRGBO(245, 247, 250, 1)
                                        : AppColor.skyBlue)
                                    : (_selectedTotalIndex == index
                                        ? AppColor.black
                                        : AppColor.skyBlue),
                              ),
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
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                                    : Color.fromRGBO(245, 247, 250, 1))
                                : (_selectedTotalIndex2 == index
                                    ? AppColor.skyBlue
                                    : Color.fromRGBO(245, 247, 250, 1)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}', // Button text (1, 2, 3, ...)
                              style: TextStyle(
                                fontSize: 18,
                                color: isSolved
                                    ? (_selectedSolvedIndex2 == index
                                        ? Color.fromRGBO(245, 247, 250, 1)
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
