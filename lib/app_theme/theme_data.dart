import 'package:flutter/material.dart';

ThemeData customTheme() {
  return ThemeData(
    useMaterial3: true,

    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A237E)),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Color(0xFF1A237E),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    // ElevatedButton theme customization
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1A237E), // Button background color
        foregroundColor: Colors.white, // Text color
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(36),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    // TextButton theme customization
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF1A237E), // Text color
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    // OutlinedButton theme customization
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF1A237E), // Text color
        side: const BorderSide(color: Color(0xFF1A237E)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    // Text theme customization
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
      titleMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
      titleSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black87),
      bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black87),
    ),

    // Input decoration theme customization
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF1A237E)),
      ),
      labelStyle: TextStyle(color: Color(0xFF1A237E)),
    ),

    // Icon theme customization
    iconTheme: const IconThemeData(
      color: Color(0xFF1A237E),
      size: 24,
    ),

    // FloatingActionButton theme customization
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF1A237E),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),

    // Scaffold background color
    scaffoldBackgroundColor: Colors.transparent,

    // Card theme customization
    cardTheme: CardTheme(
      color: Colors.white,
      shadowColor: Colors.grey.shade300,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    bottomAppBarTheme: const BottomAppBarTheme(
      color: Color(0xFF1A237E),
      elevation: 4,
      shape: CircularNotchedRectangle(),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1A237E),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
    ),

    tabBarTheme: const TabBarTheme(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white54,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: Colors.white, width: 2),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey.shade200,
      disabledColor: Colors.grey.shade400,
      selectedColor: const Color(0xFF1A237E),
      secondarySelectedColor: const Color(0xFF1A237E).withOpacity(0.8),
      padding: const EdgeInsets.all(8),
      labelStyle: const TextStyle(color: Colors.black),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(const Color(0xFF1A237E)),
      trackColor: WidgetStateProperty.all(const Color(0xFF9FA8DA)),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(const Color(0xFF1A237E)),
      checkColor: WidgetStateProperty.all(Colors.white),
    ),

    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(const Color(0xFF1A237E)),
    ),

    dialogTheme: DialogTheme(
      backgroundColor: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A237E),
      ),
      contentTextStyle: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
    ),

    popupMenuTheme: PopupMenuThemeData(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(color: Color(0xFF1A237E)),
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF1A237E),
      contentTextStyle: const TextStyle(color: Colors.white),
      actionTextColor: Colors.white70,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      behavior: SnackBarBehavior.floating,
    ),


    // Font family
    fontFamily: 'Sora',
  );
}
