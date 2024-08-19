import 'package:flutter/material.dart';
import 'package:kpathshala/app_theme/theme_data.dart';
import 'package:kpathshala/view/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: customTheme(),
      home: const SplashScreen(),
    );
  }
}
