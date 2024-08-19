import 'package:flutter/material.dart';

ThemeData customTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A237E)),
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
    ),
    fontFamily: 'Sora',
    useMaterial3: true,
  );
}
