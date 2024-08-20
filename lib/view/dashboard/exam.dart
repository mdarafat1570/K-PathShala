import 'package:flutter/material.dart';
import 'package:kpathshala/view/common_widget/custom_background.dart';

class Exam extends StatefulWidget {
  const Exam({super.key});

  @override
  State<Exam> createState() => _ExamState();
}

class _ExamState extends State<Exam> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
          child: Center(
              child: Text("Stay tuned premium courses are coming soon"))),
    );
  }
}
