import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/view/common_widget/common_app_bar.dart';
import 'package:kpathshala/view/common_widget/custom_background.dart';
import 'package:kpathshala/view/common_widget/custom_text.dart.dart';
import 'package:lottie/lottie.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: const CommonAppBar(
        title: "Notifications",
      ),
      body: GradientBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/notification_icon_empty.json',
              height: 400,
              width: 400,
              repeat: true,
              animate: true,
            ),
            customText("There are no notifications for now", TextType.normal),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openNotificationSettings,
              child: const Text('Open Notification Settings'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openNotificationSettings() async {
    const AndroidIntent intent = AndroidIntent(
      action: 'android.settings.APP_NOTIFICATION_SETTINGS',
      arguments: <String, dynamic>{
        'android.provider.extra.APP_PACKAGE': 'com.designdebugger.kpathshala',
      },
    );
    await intent.launch();
  }
}
