import 'package:flutter/material.dart';
import 'package:kpathshala/Page/Gradientbackground.dart';
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/views/log_in_Page/log_in_page.dart';
import 'package:kpathshala/widget/common_widget/common_button_add.dart';
import 'package:kpathshala/widget/common_widget/custom_text.dart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController myController = TextEditingController();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: commonCustomButton(
            width: 300,
            backgroundColor: AppColor.navyblue,
            height: 50,
            borderRadius: 25,
            margin: const EdgeInsets.all(10),
            onPressed: () {
              // Navigate to LoginPageAndSignUp
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPageAndSignUp()),
              );
            },
            iconWidget: const Icon(
              Icons.arrow_forward,
              size: 25,
              color: Colors.white,
            ),
            reversePosition: true,
            child: customText(
              "Continue",
              TextType.normal,
              color: AppColor.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
