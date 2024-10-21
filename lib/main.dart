import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kpathshala/NetworkManager.dart';
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
import 'package:logger/logger.dart';

class Preferences {
  static const String oneSignalUserId = 'oneSignalUserId';
}

final Logger logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for authentication
  logger.i("Initializing Firebase...");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  logger.i("Firebase initialized.");

  Get.put(ConectivityController());

  // Initialize OneSignal
  logger.i("Setting OneSignal log level...");
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  logger.i("Initializing OneSignal...");
  OneSignal.initialize("e701d691-d45f-4a70-b430-f9e7037085af");
  logger.i("OneSignal initialized.");

  // Request permission for notifications
  logger.i("Requesting notification permissions...");
  OneSignal.Notifications.requestPermission(true);
  logger.i("Notification permissions requested.");

  // Fetch OneSignal ID and store it in SharedPreferences
  String? oneSignalId;
  try {
    logger.i("Fetching OneSignal ID...");
    oneSignalId = await OneSignal.User.getOnesignalId();
    logger.i("OneSignal ID fetched: $oneSignalId");

    if (oneSignalId != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(Preferences.oneSignalUserId, oneSignalId);
      logger.i("OneSignal ID stored in SharedPreferences.");
    } else {
      logger.w("OneSignal ID is null.");
    }
  } catch (e) {
    logger.e("Error fetching OneSignal ID: $e");
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
        

      },
      home: const SplashScreen(),
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
    );
  }
}
