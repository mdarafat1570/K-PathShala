import 'package:flutter/material.dart';

import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/view/common_widget/common_button_add.dart';
import 'package:kpathshala/view/common_widget/custom_background.dart';
import 'package:kpathshala/view/common_widget/custom_text.dart.dart';
import 'package:kpathshala/view/login/registration_And_Login_page.dart';

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
            backgroundColor: AppColor.navyBlue,
            height: 50,
            borderRadius: 25,
            margin: const EdgeInsets.all(10),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RegistrationPage(
                          title: 'App',
                        )),
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
