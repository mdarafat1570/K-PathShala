import 'package:flutter/material.dart';
import 'package:kpathshala/view/common_widget/custom_background.dart';

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
          child: Center(
              child: Text("Stay tuned premium courses are coming soon"))),
    );
  }
}
