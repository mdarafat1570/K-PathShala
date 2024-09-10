import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kpathshala/app_theme/app_color.dart';

import 'login_signup_age/registration_and_login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) =>
              const RegistrationPage(title: "Registration Page"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.deepPurple,
      body: Center(
          child: Container(
        height: 160,
        width: 160,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/new_App_icon.png'),
                fit: BoxFit.cover)),
      )),
    );
  }
}
