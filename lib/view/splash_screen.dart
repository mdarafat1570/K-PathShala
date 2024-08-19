import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/view/navigationbar/navigation_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Navigation())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.deepPurple,
      body: Center(
          child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/Group.png'), fit: BoxFit.cover)),
      )),
    );
  }
}
