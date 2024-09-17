import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kpathshala/app_base/common_imports.dart';

class QuizHomePage extends StatefulWidget {
  const QuizHomePage({super.key});

  @override
  _QuizHomePageState createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  FlutterTts flutterTts = FlutterTts();
  final TextEditingController questionController = TextEditingController();
  String enteredQuestion = "";
  String answer = "";

  // Function to convert the entered question to speech
  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  // Function to handle Yes/No answer
  void _handleAnswer(String userAnswer) {
    setState(() {
      answer = userAnswer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: const Text('Quiz App with TTS'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input field for the question
            TextField(
              controller: questionController,
              decoration: const InputDecoration(
                labelText: 'Enter your question',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Button to submit the question and convert to voice
            ElevatedButton(
              onPressed: () {
                setState(() {
                  enteredQuestion = questionController.text;
                });
                _speak(enteredQuestion);
              },
              child: const Text("Play Question"),
            ),
            const SizedBox(height: 20),
            // Yes/No buttons for the answer
            const Text("Is the statement True or False?"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _handleAnswer("Yes"),
                  child: const Text("Yes"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _handleAnswer("No"),
                  child: const Text("No"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Display the selected answer
            if (answer.isNotEmpty)
              Text(
                "You selected: $answer",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
