import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kpathshala/app_theme/theme_data.dart';
import 'package:kpathshala/view/splash_screen.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'K-PathShala',
      theme: customTheme(),
      home: const SplashScreen(),
    );
  }
}
