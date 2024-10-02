import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kpathshala/NetworkManager.dart';
import 'package:kpathshala/app_theme/theme_data.dart';
import 'package:kpathshala/view/splash_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'firebase_options.dart'; // Firebase options file
import 'package:firebase_core/firebase_core.dart'; // Firebase package
import 'package:device_preview/device_preview.dart';
// OneSignal package

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for authentication
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize("<e701d691-d45f-4a70-b430-f9e7037085af>");

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.Notifications.requestPermission(true);

  Get.put(ConectivityController());
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const MyApp(),
    ),
  );
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
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
    );
  }
}
