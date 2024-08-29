import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/view/Login%20Signup%20Page/OtpPage.dart';
import 'package:kpathshala/view/Login%20Signup%20Page/otp_verify_page.dart';
import 'package:kpathshala/view/common_widget/custom_text.dart.dart';

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
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColor.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/Notifications_Empty.svg',
              height: 300,
              width: 300,
            ),
            customText("There are no notifications for now", TextType.subtitle),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openNotificationSettings,
              child: const Text('Open Notification Settings'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OtpPageV1()),
                );
              },
              child: const Text('Open OTP Page'),
            ),
          ],
        ),
      ),
      // Snackbar
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final snackBar = SnackBar(
            content: const Text('This is a Snake notification!'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {},
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _openNotificationSettings() async {
    const AndroidIntent intent = AndroidIntent(
      action: 'android.settings.APP_NOTIFICATION_SETTINGS',
      arguments: <String, dynamic>{
        'android.provider.extra.APP_PACKAGE': 'com.inferloom.kpathshala',
      },
    );
    await intent.launch();
  }
}
