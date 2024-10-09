import 'dart:developer';

import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/model/question_model/reading_question_page_model.dart';
import 'package:kpathshala/model/question_model/result_model.dart';
import 'package:kpathshala/repository/question/answer_review_repository.dart';
import 'package:kpathshala/repository/question/reading_questions_repository.dart';
import 'package:kpathshala/view/exam_main_page/quiz_attempt_page/quiz_attempt_page_imports.dart';

import '../common_widget/common_app_bar.dart';

class ReviewPage extends StatefulWidget {
  final String appBarTitle;
  final int questionSetId;

  const ReviewPage(
      {super.key, required this.appBarTitle, required this.questionSetId});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  bool dataFound = false;
  ResultData? result;

  List<ReadingQuestions> readingQuestions = [];
  List<ListeningQuestions> listeningQuestions = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      AnswerReviewRepository repository = AnswerReviewRepository();
      QuestionsRepository questionRepository = QuestionsRepository();

      ResultData? resultData = await repository.fetchResults(
          questionSetId: widget.questionSetId, context: context);
      QuestionsModel? questionsModel = await questionRepository
          .fetchReadingQuestions(widget.questionSetId, context);

      setState(() {
        readingQuestions = questionsModel?.data?.readingQuestions ?? [];
        listeningQuestions = questionsModel?.data?.listeningQuestions ?? [];
        result = resultData;
        dataFound = true;
      });
      log("----------");
    } catch (e) {
      log(e.toString()); // Handle the exception
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CommonAppBar(title: "Review ${widget.appBarTitle}"),
      body: SafeArea(
        child: !dataFound
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  buildScoreContainer(),
                  Stack(
                    children: [
                      buildIconWaterMark(context),
                      buildReadingQuestionListView(),
                      buildListeningQuestionListView(),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildReadingQuestionListView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/book-open.png", height: 16),
            Text(
              "읽기 (${readingQuestions.length} Questions)",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: readingQuestions.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                // buildQuestionSection(
                //   context: context,
                //   title: readingQuestions[index].title ?? '',
                //   subTitle: readingQuestions[index].subtitle ?? '',
                //   imageCaption: readingQuestions[index].imageCaption ?? '',
                //   question: readingQuestions[index].question ?? '',
                //   imageUrl: readingQuestions[index].imageUrl ?? '',
                //   voiceScript: '',
                //   listeningQuestionType: '',
                //   dialogue: [],
                //   questionId: readingQuestions[index].id ?? -1,
                //   showZoomedImage: showZoomedImage,
                //   cachedImages: {},
                //   speak: v,
                // ),
                Text("Answer"),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget buildListeningQuestionListView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/headphones.png", height: 16),
            Text(
              "듣기 (${listeningQuestions.length} Questions)",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: listeningQuestions.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Text("Question"),
                Text("Answer"),
              ],
            );
          },
        ),
      ],
    );
  }

  Opacity buildIconWaterMark(BuildContext context) {
    return Opacity(
      opacity: 0.1,
      child: Center(
        child: Image.asset(
          'assets/new_App_icon.png',
          height: MediaQuery.sizeOf(context).width * 0.7,
        ),
      ),
    );
  }

  Container buildScoreContainer() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border.all(color: AppColor.skyBlue, width: 1),
          borderRadius: BorderRadius.circular(16.0),
          gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(238, 240, 255, 1),
              Color.fromRGBO(145, 209, 236, 1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            // crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${result?.totalGotScore ?? 0}",
                style: const TextStyle(
                  fontSize: 48,
                  color: AppColor.navyBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                children: [
                  const Gap(20),
                  Text(
                    "/${result?.maximumScore ?? 0}",
                    style: const TextStyle(fontSize: 10),
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
                      "${result?.gotReadingScore ?? 0} of ${result?.maxReadingScore ?? 0}",
                      "Reading Test",
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      )),
                ),
                const SizedBox(width: 1),

                // Middle card: no border radius
                Expanded(
                  child: _buildScoreContainer(
                      "${result?.gotListeningScore ?? 0} of ${result?.maxListeningScore ?? 0}",
                      "Listening Test",
                      borderRadius: BorderRadius.zero),
                ),
                const SizedBox(width: 1),
                // Last card: only right border radius
                Expanded(
                  child: _buildScoreContainer(
                      "${result?.takenTime ?? 0} min", "Time taken",
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      )),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          customText(
              "${result?.totalRetake ?? 0} Retakes taken", TextType.normal,
              color: AppColor.navyBlue, fontSize: 10),
          customText(
              "${result?.totalSpendTime ?? 0} spent in total", TextType.normal,
              color: AppColor.navyBlue, fontSize: 10),
          const Gap(10),
        ],
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
}
