import 'package:flutter/material.dart';
import 'package:kpathshala/Page/Gradientbackground.dart';

class Exam extends StatefulWidget {
  const Exam({super.key});

  @override
  State<Exam> createState() => _ExamState();
}

class _ExamState extends State<Exam> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          GradientBackground(child: Center(child: Text("under construction"))),
    );
  }
}
