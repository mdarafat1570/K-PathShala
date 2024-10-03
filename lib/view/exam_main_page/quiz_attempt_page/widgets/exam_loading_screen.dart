import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

Widget loadingScreen(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;

  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset("assets/exam_loading_2.json", height: 150),
        const Gap(5),
        const Text(
          "Hang tight! We’re getting your exam ready for you.",
          style: TextStyle(fontSize: 16),
        ),
        const Gap(10),
        SizedBox(
          width: screenWidth * 0.5,
          child: const LinearProgressIndicator(),
        ),
        const Gap(20),
      ],
    ),
  );
}
