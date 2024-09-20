import 'dart:developer';

import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/model/question_model/question_set_model.dart';
import 'package:kpathshala/repository/question/question_set_repo.dart';
import 'package:kpathshala/view/common_widget/common_app_bar.dart';
import 'package:kpathshala/view/exam_main_page/bottom_sheets/main_bottom_sheet.dart';
import 'package:kpathshala/view/exam_main_page/quiz_attempt_page.dart';
import 'package:kpathshala/view/exam_main_page/ubt_exam_row.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kpathshala/model/item_list.dart';

class ExamPage extends StatefulWidget {
  final int packageId;
  const ExamPage({super.key,required this.packageId});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  final List<Map<String, dynamic>> courses = courseList();
  List<QuestionSets> questionSet = [];
  QuestionSetResults? questionSetResults;
  bool dataFound = false;
  Map<String, int> testStartCounts = {};

  @override
  void initState() {
    super.initState();
    _loadStartCounts();
    fetchData();
  }

  void fetchData() async {
    try {
      // Create an instance of QuestionSetRepository
      QuestionSetRepository repository = QuestionSetRepository();

      // Access fetchQuestionSets as an instance method
      QuestionSetData qstn = await repository.fetchQuestionSets(packageId: widget.packageId);

      setState(() {
        questionSet = qstn.questionSets ?? [];
        // questionSetResults = qstn.results;
        dataFound = true;
      });
    } catch (e) {
      log(e.toString()); // Handle the exception
    }
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
  )
  {
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
      BuildContext context, String title, String description)
  {
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
      int listingTestScore, int readingTestScore, String timeTaken)
  {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          // crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$score',
              style: const TextStyle(
                fontSize: 48,
                color: AppColor.navyBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Column(
              children: [
                Gap(20),
                Text(
                  "/40",
                  style: TextStyle(fontSize: 10),
                ),
              ],
            )
          ],
        ),
        const Text(
          "Final score",
          style: TextStyle(color: AppColor.navyBlue, fontSize: 12),
        ),
        const Gap(10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(1),
          child: Row(
            children: [
              // First card: only left border radius
              Expanded(
                child: _buildScoreContainer('$listingTestScore of 20', "Reading Test",
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    )),
              ),
              const SizedBox(width: 1),

              // Middle card: no border radius
              Expanded(
                child: _buildScoreContainer('$readingTestScore of 20', "Listening Test",
                    borderRadius: BorderRadius.zero),
              ),
              const SizedBox(width: 1),

              // Last card: only right border radius
              Expanded(
                child: _buildScoreContainer(timeTaken, "Time taken",
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    )),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        customText("2 Retakes taken", TextType.normal, color: AppColor.navyBlue, fontSize: 10),
        customText("3h 21m spent in total", TextType.normal, color: AppColor.navyBlue, fontSize: 10),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {},
            child: const Text("Close", style: TextStyle(fontSize: 12),),
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

  Widget _buildScoreContainer(String score, String label, {required BorderRadius borderRadius}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
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
                fontSize: 14,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        appBar: const CommonAppBar(
          title: "UBT Mock Test",
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
                  ),
                  Image.asset(
                    'assets/exploding-ribbon-and-confetti-9UErHOE0bL.png',
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                   Container(
                     padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    height: 190,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${questionSetResults?.completedQuestionSet ?? 0} out of ${questionSetResults?.totalQuestionSet ?? 0} sets completed",
                          textAlign: TextAlign.center,
                          style:const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "You’re among the top ${questionSetResults?.rankPercentage ?? 0}% of the students in this session.",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColor.grey600, fontSize: 12),
                        ),
                        const Gap(30)
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.brightCoral,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        log('Button on Stack pressed');
                      },
                      child: const Text('Batch 1', style: TextStyle(fontSize: 12),),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child:
                !dataFound ? const CircularProgressIndicator() :
                ListView.builder(
                  itemCount: questionSet.length,
                  // itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final question = questionSet[index];
                    final title = question.title ?? 'No Title';

                    // final question = courses[index];
                    // final title = question['title'] ?? 'No Title';
                    final description = question.subtitle ?? '';
                    final score = question.score ?? 0;
                    final readingTestScore =  0;
                    final listingTestScore =  0;
                    final timeTaken =   'Unknown';

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
          height: 65,
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
            child: const Text('Continue to Set 11', style: TextStyle(fontSize: 12),),
          ),
        ),
      ),
    );
  }
}
