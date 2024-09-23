import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For orientation control
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/view/common_widget/custom_background.dart';

import '../exam_main_page/quiz_attempt_page.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Upcoming"),
              ElevatedButton(
                onPressed: () {
                  // Set orientation to landscape when button is clicked
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeRight,
                    DeviceOrientation.landscapeLeft,
                  ]);

                  // Use Navigator.push to navigate to RetakeTestPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RetakeTestPage(
                        title: '',
                        description: '',
                      ),
                    ),
                  );
                },
                child: const Text('Trying'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Reset orientation back to portrait when exiting this page
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
