import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/model/log_in_credentials.dart';
import 'package:kpathshala/repository/authentication_repository.dart';
import 'package:kpathshala/view/login_signup_page/registration_and_login_page.dart';
import 'package:kpathshala/view/navigation_bar_page/navigation_bar.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    checkCredentials();
  }

  void checkCredentials () async {
    bool signedIn = false;

    final LogInCredentials? credentials = await _authService.getLogInCredentials();
    if (credentials?.token != null && credentials?.token != ""){
      signedIn = true;
    }
    Timer(
      const Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => signedIn ? const Navigation() :
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
