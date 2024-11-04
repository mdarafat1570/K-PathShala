import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kpathshala/network_manager.dart';
import 'package:kpathshala/app_theme/theme_data.dart';
import 'package:kpathshala/view/courses_page/courses.dart';
import 'package:kpathshala/view/exam_main_page/exam_purchase_page.dart';
import 'package:kpathshala/view/payment_page/payment_history.dart';
import 'package:kpathshala/view/profile_page/profile_screen_main.dart';
import 'package:kpathshala/view/splash_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_preview/device_preview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

class Preferences {
  static const String oneSignalUserId = 'oneSignalUserId';
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  // Initialize Firebase
  developer.log("Initializing Firebase...", name: 'INFO');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  developer.log("Firebase initialized.", name: 'INFO');

  Get.put(ConnectivityController());

  // Initialize OneSignal
  developer.log("Setting OneSignal log level...", name: 'INFO');
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  developer.log("Initializing OneSignal...", name: 'INFO');
  OneSignal.initialize("e701d691-d45f-4a70-b430-f9e7037085af");
  developer.log("OneSignal initialized.", name: 'INFO');

  // Request permission for notifications
  developer.log("Requesting notification permissions...", name: 'INFO');
  await OneSignal.Notifications.requestPermission(true);
  developer.log("Notification permissions requested.", name: 'INFO');

  // Fetch OneSignal ID with retry logic
  await _fetchAndStoreOneSignalId(prefs);

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const MyApp(),
    ),
  );
}

// Helper function to fetch and store OneSignal player ID with retry
Future<void> _fetchAndStoreOneSignalId(SharedPreferences prefs) async {
  String? oneSignalId;
  const maxRetries = 3; // Max number of retries
  int attempt = 0;

  while (oneSignalId == null && attempt < maxRetries) {
    try {
      developer.log("Fetching OneSignal ID... Attempt ${attempt + 1}",
          name: 'INFO');
      oneSignalId = await OneSignal.User.getOnesignalId();

      if (oneSignalId != null) {
        await prefs.setString(Preferences.oneSignalUserId, oneSignalId);
        developer.log("OneSignal ID stored in SharedPreferences: $oneSignalId",
            name: 'INFO');
      } else {
        developer.log("OneSignal ID is null, retrying...", name: 'WARNING');
      }
    } catch (e) {
      developer.log("Error fetching OneSignal ID: $e", name: 'ERROR');
    }

    attempt++;
    if (oneSignalId == null)
      await Future.delayed(const Duration(seconds: 2)); // Delay between retries
  }

  if (oneSignalId == null) {
    developer.log("Failed to fetch OneSignal ID after $maxRetries attempts.",
        name: 'ERROR');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // Add OneSignal notification click listener
    OneSignal.Notifications.addClickListener((event) {
      final url = event.notification.launchUrl;
      if (url != null) {
        _handleDeepLink(url);
      }
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'K-PathShala',
      theme: customTheme(),
      initialRoute: '/',
      routes: {
        '/courses': (context) => const Courses(),
        '/ExamPurchasePage': (context) => const ExamPurchasePage(),
        '/ProfileScreenInMainPage': (context) =>
            const ProfileScreenInMainPage(),
        '/PaymentHistory': (context) => const PaymentHistory(),
      },
      home: const SplashScreen(),
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
    );
  }

  // Method to handle deep link URLs and navigate to the specified screen
  static void _handleDeepLink(String url) {
    Uri uri = Uri.parse(url);

    // Map each deep link path to a specific route
    if (uri.path == '/courses') {
      navigatorKey.currentState?.pushNamed('/courses');
    } else if (uri.path == '/ExamPurchasePage') {
      navigatorKey.currentState?.pushNamed('/ExamPurchasePage');
    } else if (uri.path == '/ProfileScreenInMainPage') {
      navigatorKey.currentState?.pushNamed('/ProfileScreenInMainPage');
    } else if (uri.path == '/PaymentHistory') {
      navigatorKey.currentState?.pushNamed('/PaymentHistory');
    }
  }
}
