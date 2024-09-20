import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kpathshala/view/common_widget/custom_background.dart';
import 'package:kpathshala/view/common_widget/custom_textfield_2.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GradientBackground(
          child: Padding(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text( "Upcoming"),
          ]
        ),
        // child: Column(
        //   children: [
        //     const Center(child: Text("Playground")),
        //     const  Gap(20),
        //     const CustomTextField2(
        //       label: "Full Name",
        //       errorMessage: "This Is A Error Message",
        //     ),
        //     const Gap(5),
        //     const CustomTextField2(
        //       label: "Mobile Number",
        //       keyboardType: TextInputType.number,
        //       prefix: Text("+88"),
        //       isEnabled: false,
        //     ),
        //     const Gap(5),
        //     CustomTextField2(
        //       label: "Mobile Number",
        //       keyboardType: TextInputType.number,
        //       prefix: const Text("+88"),
        //       controller: TextEditingController(text: "01772362414"),
        //       maxLength: 11,
        //     ),
        //     const Gap(5),
        //     const CustomTextField2(
        //       label: "Email",
        //       keyboardType: TextInputType.emailAddress,
        //     ),
        //     const Gap(5),
        //   ],
        // ),
      )),
    );
  }
}
