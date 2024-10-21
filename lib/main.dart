import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kpathshala/network_manager.dart';
import 'package:kpathshala/app_theme/theme_data.dart';
import 'package:kpathshala/model/dashboard_page_model/dashboard_page_model.dart';
import 'package:kpathshala/view/courses_page/courses.dart';
import 'package:kpathshala/view/exam_main_page/exam_purchase_page.dart';
import 'package:kpathshala/view/exam_main_page/ubt_mock_test_page.dart';
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

  // Initialize Firebase for authentication
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
  OneSignal.Notifications.requestPermission(true);
  developer.log("Notification permissions requested.", name: 'INFO');

  // Fetch OneSignal ID and store it in SharedPreferences
  String? oneSignalId;
  try {
    developer.log("Fetching OneSignal ID...", name: 'INFO');
    oneSignalId = await OneSignal.User.getOnesignalId();
    developer.log("OneSignal ID fetched: $oneSignalId", name: 'INFO');

    if (oneSignalId != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(Preferences.oneSignalUserId, oneSignalId);
      developer.log("OneSignal ID stored in SharedPreferences.", name: 'INFO');
    } else {
      developer.log("OneSignal ID is null.", name: 'WARNING');
    }
  } catch (e) {
    developer.log("Error fetching OneSignal ID: $e", name: 'ERROR');
  }

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    DashboardPageModel? dashboardPageModel;
    String? screen;
    OneSignal.Notifications.addClickListener((event) {
      final data = event.notification.additionalData;
      screen = data?['screen'];
      if (screen != null) {
        navigatorKey.currentState?.pushNamed(screen!);
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
        // '/indivisualExamPage': (context) => UBTMockTestPage(
        //     packageId: dashboardPageModel!.exam!.packageId ?? -1),
      },
      home: const SplashScreen(),
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
    );
  }
}
