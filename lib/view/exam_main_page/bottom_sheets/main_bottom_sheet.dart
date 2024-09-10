import 'package:flutter/material.dart';

class BottomSheetContent extends StatelessWidget {
  final String courseTitle;
  final int score;
  final Widget additionalContent; // New parameter for additional content

  const BottomSheetContent({
    Key? key,
    required this.courseTitle,
    required this.score,
    required this.additionalContent, // Initialize new parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60, // Adjust the width as needed
            height: 4, // Adjust the height (thickness) as needed
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 217, 217, 217), // Divider color
              borderRadius: BorderRadius.circular(8), // Circular edges
            ),
          ),
          additionalContent, // Display additional content based on score
        ],
      ),
    );
  }
}
