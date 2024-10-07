import 'package:flutter/material.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/view/common_widget/common_app_bar.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  // Sample data for the questions
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
    // Add more questions as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CommonAppBar(title: "Set 1"),
      body: Stack(
        children: [
          // Watermark Image
          Center(
            child: Opacity(
              opacity: 0.1, // Adjust opacity for watermark effect
              child: Center(
                child: Image.asset(
                  'assets/new_App_icon.png', // Your watermark image path
                ),
              ),
            ),
          ),
          // ListView with questions
          ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];
              return Card(
                color: Colors.transparent, // Set card color to transparent
                elevation: 0, // Remove shadow for a flat look
                margin: const EdgeInsets.all(8.0),
                child: Container(
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
                ),
              );
            },
          ),
        ],
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
