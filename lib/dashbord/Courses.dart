import 'package:flutter/material.dart';
import 'package:kpathshala/Page/Gradientbackground.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          GradientBackground(child: Center(child: Text("Under Construction"))),
    );
  }
}
