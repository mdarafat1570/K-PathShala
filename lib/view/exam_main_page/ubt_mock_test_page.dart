import 'dart:developer';

import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/model/package_model/package_model.dart';
import 'package:kpathshala/model/question_model/question_set_model.dart';
import 'package:kpathshala/repository/question/question_set_repo.dart';
import 'package:kpathshala/view/common_widget/common_app_bar.dart';
import 'package:kpathshala/view/common_widget/format_date_with_ordinal.dart';
import 'package:kpathshala/view/exam_main_page/bottom_sheets/bottom_panel_page_course_purchase.dart';
import 'package:kpathshala/view/exam_main_page/bottom_sheets/main_bottom_sheet.dart';
import 'package:kpathshala/view/exam_main_page/quiz_attempt_page/quiz_attempt_page.dart';
import 'package:kpathshala/view/exam_main_page/widgets/test_sets_page_shimmer.dart';
import 'package:kpathshala/view/exam_main_page/widgets/ubt_exam_row.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kpathshala/model/item_list.dart';

class UBTMockTestPage extends StatefulWidget {
  final int packageId;
  final PackageList? package;
  bool? isInPreviewMode;

  UBTMockTestPage(
      {super.key, this.package, this.isInPreviewMode = false, required this.packageId});

  @override
  State<UBTMockTestPage> createState() => _UBTMockTestPageState();
}

class _UBTMockTestPageState extends State<UBTMockTestPage> {
  final List<Map<String, dynamic>> courses = courseList();
  List<QuestionSets> questionSet = [];
  QuestionSetResults? questionSetResults;
  bool dataFound = false;
  Map<String, int> testStartCounts = {};
  int lastCompletedSetIndex = 0;

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
      QuestionSetData question = await repository.fetchQuestionSets(
          packageId: widget.packageId, context: context);

      setState(() {
        questionSet = question.questionSets ?? [];
        questionSetResults = question.results ??
            QuestionSetResults(
              batch: -1,
              completedQuestionSet: 0,
              rankPercentage: 0,
              totalQuestionSet: 0,
            );

        // Find the index of the last completed question set based on its 'status'
        lastCompletedSetIndex = questionSet.lastIndexWhere(
              (qs) => qs.status == 'completed' || qs.status == 'flawless',
        );

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

  // Future<void> _saveStartCounts() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   for (var entry in testStartCounts.entries) {
  //     await prefs.setInt(entry.key, entry.value);
  //   }
  // }

  // void _incrementTestStartCount(String courseTitle) {
  //   setState(() {
  //     testStartCounts[courseTitle] = (testStartCounts[courseTitle] ?? 0) + 1;
  //   });
  //   _saveStartCounts();
  // }

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

  void _showBottomSheet(BuildContext context,
      String courseTitle,
      String courseDescription,
      int score,
      int readingTestScore,
      int listingTestScore,
      String timeTaken,
      int bottomSheetType,
      int questionId,
      String status,) {
    LinearGradient? gradient = bottomSheetType == 1
        ? const LinearGradient(
      colors: [
        Color.fromRGBO(238, 240, 255, 1),
        Color.fromRGBO(145, 209, 236, 1),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    )
        : null;

    Color? backgroundColor = bottomSheetType == 1 ? null : Colors.white;

    Widget additionalContent = bottomSheetType == 1
        ? _bottomSheetType1(
      context,
      score,
      listingTestScore,
      readingTestScore,
      timeTaken,
    )
        : _bottomSheetType2(
        context, courseTitle, courseDescription, questionId, status);

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
      height: MediaQuery
          .of(context)
          .size
          .height * 0.45,
    );
  }

  void _navigateToRetakeTest(String title, String description,
      int questionSetId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RetakeTestPage(
              questionSetId: questionSetId,
              title: title,
              description: description,
            ),
      ),
    ).then((_) {
      dataFound = false;
      setState(() {});
      fetchData();
    });
  }

  // String _getButtonLabel(String title) {
  //   return testStartCounts[title] != null && testStartCounts[title]! > 0
  //       ? 'Retake Test'
  //       : 'Start';
  // }

  // void _handleRetakeTestClick(String title, String description) {
  //   _incrementTestStartCount(title);
  //
  // }

  Widget _bottomSheetType2(BuildContext context, String title,
      String description, int questionId, String status) {
    final String buttonLabel = (status == 'flawless' || status == 'completed')
        ? 'Retake Test'
        : 'Start';
    return Container(
      padding: const EdgeInsets.all(8.0),
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
          const SizedBox(height: 12),
          _buildButton("Solve video", AppColor.skyBlue.withOpacity(0.3), () {}),
          const SizedBox(height: 12),
          _buildButton("Review performance", AppColor.skyBlue.withOpacity(0.3),
                  () {
                _showBottomSheet(
                    context,
                    title,
                    description,
                    40,
                    20,
                    20,
                    "10 min",
                    1,
                    1,
                    status);
              }),
          const SizedBox(height: 12),
          if (buttonLabel.isNotEmpty)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  _navigateToRetakeTest(title, description, questionId);
                },
                child: Text(buttonLabel),
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
                child: _buildScoreContainer(
                    '$listingTestScore of 20', "Reading Test",
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    )),
              ),
              const SizedBox(width: 1),

              // Middle card: no border radius
              Expanded(
                child: _buildScoreContainer(
                    '$readingTestScore of 20', "Listening Test",
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
        customText("2 Retakes taken", TextType.normal,
            color: AppColor.navyBlue, fontSize: 10),
        customText("3h 21m spent in total", TextType.normal,
            color: AppColor.navyBlue, fontSize: 10),
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
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Close",
              style: TextStyle(fontSize: 12),
            ),
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
                side: const BorderSide(width: 1, color: AppColor.navyBlue)),
            elevation: 0),
        child: Text(
          text,
          style: const TextStyle(color: AppColor.navyBlue),
        ),
      ),
    );
  }

  Widget _buildScoreContainer(String score, String label,
      {required BorderRadius borderRadius}) {
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
        body: !dataFound
            ? TestSetsPageShimmer()
            : Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  const SizedBox(
                    height: 180,
                    width: double.infinity,
                  ),
                  Container(
                    width: double.infinity,
                    height: 170,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border:
                      Border.all(color: AppColor.examCardGradientEnd),
                      gradient: const LinearGradient(
                        colors: [
                          AppColor.examCardGradientStart,
                          AppColor.examCardGradientEnd,
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
                    height: 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${questionSetResults?.completedQuestionSet ??
                              0} out of ${questionSetResults
                              ?.totalQuestionSet ?? 0} sets completed",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Text(
                        //   "You’re among the top ${questionSetResults?.rankPercentage ?? 0}% of the students in this session.",
                        //   textAlign: TextAlign.center,
                        //   style: const TextStyle(
                        //       color: AppColor.grey600, fontSize: 12),
                        // ),
                        // const Gap(30)
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColor.brightCoral,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Batch ${questionSetResults?.batch ?? 0}',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: questionSet.length,
                itemBuilder: (context, index) {
                  final question = questionSet[index];
                  final status = question.status.toString();
                  final title = question.title ?? 'No Title';
                  final description = question.subtitle ?? '';
                  final score =
                  (status == 'flawless' || status == 'completed')
                      ? question.score
                      : null;
                  const readingTestScore = 0;
                  const listingTestScore = 0;
                  const timeTaken = 'Unknown';

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      (widget.isInPreviewMode! && index > 2) ? null :
                      _showBottomSheet(
                          context,
                          title,
                          description,
                          score ?? 0,
                          listingTestScore,
                          readingTestScore,
                          timeTaken,
                          2,
                          question.id,
                          status);
                    },
                    child: CourseRow(
                      title: title,
                      description: description,
                      readingTestScore: readingTestScore,
                      listingTestScore: listingTestScore,
                      timeTaken: timeTaken,
                      score: score,
                      status: status,
                      isInPreviewMode: (widget.isInPreviewMode! && index > 2),
                      onDetailsClick: () {
                        (widget.isInPreviewMode! && index > 2)
                            ? null
                            : _showBottomSheet(
                            context,
                            title,
                            description,
                            score ?? 0,
                            listingTestScore,
                            readingTestScore,
                            timeTaken,
                            2,
                            question.id,
                            status);
                      },
                      onRetakeTestClick: () {
                        (widget.isInPreviewMode! && index > 2)
                            ? null
                            : _navigateToRetakeTest(
                            title, description, question.id);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: questionSet.isEmpty ? null : widget
            .isInPreviewMode! ? BottomAppBar(
          height: 130,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    child: Icon(Icons.lock_rounded, color: AppColor.navyBlue,size: 14,),
                  ),
                  Gap(5),
                  Expanded(child: Text('You’re currently previewing this exam. Buy this package to access all the exams.', style: TextStyle(fontSize: 10, color: AppColor.navyBlue),)),
                ],
              ),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    showCommonBottomSheet(
                      context: context,
                      height: MediaQuery.sizeOf(context).height * 0.5,
                      content: BottomSheetPage(
                        context: context,
                        packageId: widget.packageId,
                        packageName:
                        widget.package?.title ?? '',
                        price:
                        widget.package?.price!.toDouble(),
                        validityDate: formatDateWithOrdinal(
                            DateTime.now().add(const Duration(days: 5))),
                        refreshPage: () {
                          widget.isInPreviewMode = false;
                          dataFound = false;
                          questionSet.clear();
                          questionSetResults = null;
                          setState(() {});
                          fetchData();
                        },
                      ),
                      actions: [],
                      color: Colors.white,
                    );
                  },
                  child: const Text(
                    'Buy Now',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ) : BottomAppBar(
          height: 65,
          color: Colors.white,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RetakeTestPage(
                        questionSetId: questionSet[lastCompletedSetIndex + 1]
                            .id,
                        title: "",
                        description: "",
                      ),
                ),
              );
            },
            child: Text(
              'Continue to ${questionSet[lastCompletedSetIndex + 1].title ??
                  ''}',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
