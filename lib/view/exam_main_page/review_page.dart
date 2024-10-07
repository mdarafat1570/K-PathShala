import 'dart:developer';

import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/model/question_model/result_model.dart';
import 'package:kpathshala/repository/question/answer_review_repository.dart';

import '../common_widget/common_app_bar.dart';

class ReviewPage extends StatefulWidget {
  final String appBarTitle;
  final int questionSetId;
  const ReviewPage({super.key, required this.appBarTitle, required this.questionSetId});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final List<Question> questions = [
    Question(
      title: 'What is Flutter?',
      description: 'A framework for building mobile applications.',
      answers: [
        'A library',
        'A framework',
        'A programming language',
        'A game engine',
      ],
    ),
    Question(
      title: 'What programming language does Flutter use?',
      description: 'Flutter primarily uses Dart.',
      answers: ['Java', 'C++', 'Dart', 'JavaScript'],
    ),
    Question(
      title: 'Which company developed Flutter?',
      description: 'Flutter was developed by Google.',
      answers: ['Facebook', 'Google', 'Microsoft', 'Apple'],
    ),
    Question(
      title: 'What is the purpose of the Flutter widget tree?',
      description: 'It represents the hierarchical structure of UI components.',
      answers: [
        'To manage application routing',
        'To store data',
        'To structure the user interface',
        'To handle HTTP requests',
      ],
    ),
    Question(
      title: 'Which Flutter widget is used for infinite scrolling?',
      description: 'The ListView widget supports infinite scrolling.',
      answers: ['GridView', 'ListView', 'Column', 'Row'],
    ),
    Question(
      title: 'How can you create a custom widget in Flutter?',
      description: 'By extending the StatelessWidget or StatefulWidget class.',
      answers: [
        'By using the setState method',
        'By extending the WidgetBuilder class',
        'By extending StatelessWidget or StatefulWidget',
        'By implementing a build function',
      ],
    ),
    Question(
      title: 'Which widget helps to render flexible layouts in Flutter?',
      description: 'The Flexible widget allows responsive layouts.',
      answers: ['Container', 'Row', 'Column', 'Flexible'],
    ),
  ];
  bool dataFound = false;
  ResultData? result;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      // Create an instance of QuestionSetRepository
      AnswerReviewRepository repository = AnswerReviewRepository();

      // Access fetchQuestionSets as an instance method
      ResultData? resultData = await repository.fetchResults(
          questionSetId: widget.questionSetId, context: context);

      setState(() {
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
      appBar: CommonAppBar(title: widget.appBarTitle),
      body: SafeArea(
        child: !dataFound ? const Center(child: CircularProgressIndicator(),) : ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border:Border.all(color: AppColor.skyBlue, width: 1),
                borderRadius: BorderRadius.circular(16.0),
                gradient: const LinearGradient(
                  colors: [
                    Color.fromRGBO(238, 240, 255, 1),
                    Color.fromRGBO(145, 209, 236, 1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              ),
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
                              "${result?.gotReadingScore ?? 0} of ${result?.maxReadingScore ?? 0}", "Reading Test",
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              )),
                        ),
                        const SizedBox(width: 1),

                        // Middle card: no border radius
                        Expanded(
                          child: _buildScoreContainer(
                              "${result?.gotListeningScore ?? 0} of ${result?.maxListeningScore ?? 0}", "Listening Test",
                              borderRadius: BorderRadius.zero),
                        ),
                        const SizedBox(width: 1),
                        // Last card: only right border radius
                        Expanded(
                          child: _buildScoreContainer("${result?.takenTime ?? 0} min", "Time taken",
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  customText("${result?.totalRetake ?? 0} Retakes taken", TextType.normal,
                      color: AppColor.navyBlue, fontSize: 10),
                  customText("${result?.totalSpendTime ?? 0} spent in total", TextType.normal,
                      color: AppColor.navyBlue, fontSize: 10),
                  const Gap(10),
                ],
              ),
            ),
            Stack(
              children: [
                Opacity(
                  opacity: 0.1,
                  child: Center(
                    child: Image.asset(
                      'assets/new_App_icon.png',
                      height: MediaQuery.sizeOf(context).width * 0.7,
                    ),
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final question = questions[index];
                    return Container(
                      // Add a Container to allow background color and padding
                      color: Colors.transparent,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(question.description),
                          const SizedBox(height: 16),
                          // Displaying answers with numbers
                          for (var i = 0; i < question.answers.length; i++)
                            GestureDetector(
                              // Use GestureDetector for tap handling
                              onTap: () {
                                // Handle answer selection
                                print(
                                    'Selected answer: ${i + 1}. ${question.answers[i]}');
                              },
                              child: Container(
                                padding: const EdgeInsets.all(
                                    12.0), // Padding for the container
                                margin: const EdgeInsets.symmetric(
                                    vertical: 4.0), // Margin for spacing
                                decoration: BoxDecoration(
                                  color: AppColor.white.withOpacity(
                                      0.5), // Background color for the button
                                  borderRadius:
                                      BorderRadius.circular(8.0), // Rounded corners
                                ),
                                child: Row(
                                  children: [
                                    // Container for the answer number
                                    Container(
                                      width:
                                          30, // Set a fixed width for the number container
                                      height:
                                          30, // Set a fixed height for the number container
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black), // Black border
                                        borderRadius: BorderRadius.circular(
                                            15), // Rounded corners for the border
                                        color: Colors
                                            .transparent, // Transparent background
                                      ),
                                      alignment:
                                          Alignment.center, // Center the text
                                      child: Text(
                                        '${i + 1}', // Answer number
                                        style: const TextStyle(
                                          color: Colors.black, // Text color
                                          fontWeight: FontWeight.bold, // Bold text
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                        width: 8), // Space between number and text
                                    Expanded(
                                      child: Text(
                                        question.answers[i], // Answer text
                                        style: const TextStyle(
                                          color: AppColor.black, // Text color
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
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
}


class Question {
  final String title;
  final String description;
  final List<String> answers;

  Question({
    required this.title,
    required this.description,
    required this.answers,
  });
}
