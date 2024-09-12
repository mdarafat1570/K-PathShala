import 'dart:developer';

import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/view/exam_main_page/bottom_sheets/main_bottom_sheet.dart';
import 'package:kpathshala/view/exam_main_page/quiz_attempt_page.dart';
import 'package:kpathshala/view/exam_main_page/ubt_exam_row.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kpathshala/model/item_list.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({super.key});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  final List<Map<String, dynamic>> courses = courseList();
  Map<String, int> testStartCounts = {};

  @override
  void initState() {
    super.initState();
    _loadStartCounts();
  }

  Future<void> _loadStartCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final loadedCounts = <String, int>{};
    for (var key in prefs.getKeys()) {
      final value = prefs.getInt(key);
      if (value != null) {
        loadedCounts[key] = value;
      }
    }
    setState(() {
      testStartCounts = loadedCounts;
    });
  }

  Future<void> _saveStartCounts() async {
    final prefs = await SharedPreferences.getInstance();
    for (var entry in testStartCounts.entries) {
      await prefs.setInt(entry.key, entry.value);
    }
  }

  void _incrementTestStartCount(String courseTitle) {
    setState(() {
      testStartCounts[courseTitle] = (testStartCounts[courseTitle] ?? 0) + 1;
    });
    _saveStartCounts();
  }

  // void _decrementTestStartCount(String courseTitle) {
  //   setState(() {
  //     if (testStartCounts.containsKey(courseTitle)) {
  //       testStartCounts[courseTitle] = (testStartCounts[courseTitle] ?? 0) - 1;
  //       if (testStartCounts[courseTitle]! < 0) {
  //         testStartCounts[courseTitle] = 0;
  //       }
  //     }
  //   });
  //   _saveStartCounts();
  // }

  void _showBottomSheet(
    BuildContext context,
    String courseTitle,
    String courseDescription,
    int score,
    int readingTestScore,
    int listingTestScore,
    String timeTaken,
  ) {
    LinearGradient? gradient = score >= 40
        ? const LinearGradient(
            colors: [
              Color.fromRGBO(238, 240, 255, 1),
              Color.fromRGBO(145, 209, 236, 1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : null;

    Color? backgroundColor = score < 40 ? Colors.white : null;

    Widget additionalContent = score >= 40
        ? _bottomSheetType1(
            context,
            score,
            listingTestScore,
            readingTestScore,
            timeTaken,
          )
        : _bottomSheetType2(
            context,
            courseTitle,
            courseDescription,
          );

    showCommonBottomSheet(
      context: context,
      content: BottomSheetContent(
        courseTitle: courseTitle,
        score: score,
        additionalContent: additionalContent,
      ),
      actions: [],
      gradient: gradient,
      color: backgroundColor,
      height: MediaQuery.of(context).size.height * 0.45,
    );
  }

  void _navigateToRetakeTest(String title, String description) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RetakeTestPage(
          title: title,
          description: description,
        ),
      ),
    );
  }

  String _getButtonLabel(String title) {
    return testStartCounts[title] != null && testStartCounts[title]! > 0
        ? 'Retake Test'
        : 'Start';
  }

  void _handleRetakeTestClick(String title, String description) {
    _incrementTestStartCount(title);
    _navigateToRetakeTest(title, description);
  }

  Widget _bottomSheetType2(
      BuildContext context, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildButton("Solve video", Colors.lightBlue, () {}),
          const SizedBox(height: 16),
          _buildButton("Solve video", Colors.lightBlue, () {}),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Retake test"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomSheetType1(BuildContext context, int score,
      int listingTestScore, int readingTestScore, String timeTaken) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$score',
              style: const TextStyle(
                fontSize: 50,
                color: AppColor.navyBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "/40",
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
        const Text(
          "Final score",
          style: TextStyle(color: AppColor.navyBlue),
        ),
        const Gap(10),
        Row(
          children: [
            _buildScoreContainer('$listingTestScore of 20', "Reading Test"),
            const SizedBox(width: 4),
            _buildScoreContainer('$readingTestScore of 20', "Listening Test"),
            const SizedBox(width: 4),
            _buildScoreContainer(timeTaken, "Time taken"),
          ],
        ),
        const SizedBox(height: 10),
        const Text("2 Retakes taken"),
        const Text("3h 21m spent in total"),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 49,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text("Close"),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: AppColor.navyBlue),
        ),
      ),
    );
  }

  Widget _buildScoreContainer(String score, String label) {
    return Expanded(
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
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
                  fontSize: 16,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('UBT Mock Test', style: TextStyle(fontSize: 24)),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                  color: AppColor.navyBlue,
                ),
                onPressed:
                    null, // You don't need `onPressed` in `IconButton` if wrapped in `InkWell`.
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  const SizedBox(
                    height: 210,
                    width: double.infinity,
                  ),
                  Container(
                    width: double.infinity,
                    height: 190,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromRGBO(238, 240, 255, 1),
                          Color.fromRGBO(145, 209, 236, 1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "10 out of 100 sets completed",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "You’re among the top 10% of the students in this session.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColor.grey600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Image.asset(
                    'assets/exploding-ribbon-and-confetti-9UErHOE0bL.png',
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        iconColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        log('Button on Stack pressed');
                      },
                      child: const Text('Batch 1'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    final title = course['title'] ?? 'No Title';
                    final description =
                        course['description'] ?? 'No Description';
                    final score = course['score'] ?? 0;
                    final readingTestScore = course['readingTestScore'] ?? 0;
                    final listingTestScore = course['listingTestScore'] ?? 0;
                    final timeTaken = course['timeTaken'] ?? 'Unknown';

                    final Color containerColor = score >= 40
                        ? const Color.fromRGBO(136, 208, 236, 0.2)
                        : Colors.white;

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        _showBottomSheet(
                          context,
                          title,
                          description,
                          score,
                          listingTestScore,
                          readingTestScore,
                          timeTaken,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: containerColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: CourseRow(
                          title: title,
                          description: description,
                          readingTestScore: readingTestScore,
                          listingTestScore: listingTestScore,
                          timeTaken: timeTaken,
                          score: score,
                          onDetailsClick: () {
                            _showBottomSheet(
                              context,
                              title,
                              description,
                              score,
                              listingTestScore,
                              readingTestScore,
                              timeTaken,
                            );
                          },
                          onRetakeTestClick: () {
                            _handleRetakeTestClick(title, description);
                          },
                          buttonLabel: _getButtonLabel(title),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 70,
          color: Colors.white,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              // Button press logic here
            },
            child: const Text('Continue to Set 11'),
          ),
        ),
      ),
    );
  }
}
