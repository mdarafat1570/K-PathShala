import 'dart:developer';

import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/model/package_model/package_model.dart';
import 'package:kpathshala/model/question_model/question_set_model.dart';
import 'package:kpathshala/repository/question/question_set_repo.dart';
import 'package:kpathshala/view/common_widget/common_app_bar.dart';
import 'package:kpathshala/view/common_widget/format_date_with_ordinal.dart';
import 'package:kpathshala/view/exam_main_page/bottom_sheets/bottom_panel_page_course_purchase.dart';
import 'package:kpathshala/view/note_video_page/note_main_page.dart';
import 'package:kpathshala/view/exam_main_page/quiz_attempt_page/quiz_attempt_page.dart';
import 'package:kpathshala/view/exam_main_page/widgets/test_sets_page_shimmer.dart';
import 'package:kpathshala/view/exam_main_page/widgets/ubt_exam_row.dart';
import 'package:kpathshala/model/item_list.dart';

import 'review_page.dart';

//ignore: must_be_immutable
class UBTMockTestPage extends StatefulWidget {
  final int packageId;
  final String appBarTitle;
  final PackageList? package;
  bool? isInPreviewMode;

  UBTMockTestPage(
      {super.key,
      this.package,
      this.isInPreviewMode = false,
      required this.packageId,
        required this.appBarTitle,
      });

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

        if (lastCompletedSetIndex < questionSet.length - 1) {
          log("Increasing index");
          lastCompletedSetIndex++;
        }

        dataFound = true;
      });
    } catch (e) {
      log(e.toString()); // Handle the exception
    }
  }

  void _showBottomSheet(
      {required BuildContext context,
      required String courseTitle,
      required String courseDescription,
      required int score,
      required int questionId,
      required String status}) {
    Widget additionalContent = _bottomSheetType2(
        context, courseTitle, courseDescription, questionId, status);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 217, 217, 217),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                additionalContent,
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToRetakeTest(
      String title, String description, int questionSetId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RetakeTestPage(
          questionSetId: questionSetId,
          title: title,
          description: description,
        ),
      ),
    ).then((_) {
      questionSet.clear();
      dataFound = false;
      setState(() {});
      fetchData();
    });
  }

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
          _buildButton("Solve video", AppColor.skyBlue.withOpacity(0.3), () {
            slideNavigationPush(NoteMainPage(questionId, title), context);
          }),
          if (status == 'flawless' || status == 'completed')
            const SizedBox(height: 12),
          if (status == 'flawless' || status == 'completed')
            _buildButton(
                "Review performance", AppColor.skyBlue.withOpacity(0.3), () {
              slideNavigationPush(
                  ReviewPage(appBarTitle: title, questionSetId: questionId),
                  context);
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

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        appBar: CommonAppBar(
          title: widget.appBarTitle,
        ),
        body: !dataFound
            ? buildShimmerLoadingEffect()
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
                                "${questionSetResults?.completedQuestionSet ?? 0} out of ${questionSetResults?.totalQuestionSet ?? 0} sets completed",
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

                        void rowDetailsClick () {
                          (widget.isInPreviewMode! && index > 2)
                              ? null
                              : _showBottomSheet(
                              context: context,
                              courseTitle: title,
                              courseDescription: description,
                              score: score ?? 0,
                              questionId: question.id,
                              status: status);
                        }

                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: rowDetailsClick,
                          child: CourseRow(
                            title: title,
                            description: description,
                            readingTestScore: readingTestScore,
                            listingTestScore: listingTestScore,
                            timeTaken: timeTaken,
                            score: score,
                            status: status,
                            isInPreviewMode:
                                (widget.isInPreviewMode! && index > 2),
                            onDetailsClick: rowDetailsClick,
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
        bottomNavigationBar: questionSet.isEmpty
            ? null
            : widget.isInPreviewMode!
                ? BottomAppBar(
                    height: 130,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Row(
                          children: [
                            CircleAvatar(
                              child: Icon(
                                Icons.lock_rounded,
                                color: AppColor.navyBlue,
                                size: 14,
                              ),
                            ),
                            Gap(5),
                            Expanded(
                                child: Text(
                              'You’re currently previewing this exam. Buy this package to access all the exams.',
                              style: TextStyle(
                                  fontSize: 10, color: AppColor.navyBlue),
                            )),
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
                                height: MediaQuery.sizeOf(context).height * 0.55,
                                content: BottomSheetPage(
                                  context: context,
                                  packageId: widget.packageId,
                                  packageName: widget.package?.title ?? '',
                                  price: widget.package?.price!.toDouble(),
                                  validityDate: formatDateWithOrdinal(
                                      DateTime.now()
                                          .add(const Duration(days: 5))),
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
                  )
                : BottomAppBar(
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
                            builder: (context) => RetakeTestPage(
                              questionSetId:
                                  questionSet[lastCompletedSetIndex].id,
                              title: "",
                              description: "",
                            ),
                          ),
                        ).then((_) {
                          questionSet.clear();
                          dataFound = false;
                          setState(() {});
                          fetchData();
                        });
                      },
                      child: Text(
                        'Continue to ${questionSet[lastCompletedSetIndex].title ?? ''}',
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
