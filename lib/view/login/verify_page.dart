import 'package:flutter/material.dart';
import 'dart:async'; // For Timer
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/view/Profile_edit/profile_setting.dart';
import 'package:kpathshala/view/common_widget/Common_slideNavigation_Push.dart';
import 'package:kpathshala/view/common_widget/custom_background.dart';
import 'package:kpathshala/view/common_widget/custom_text.dart.dart';
import 'package:kpathshala/view/dashboard/home_Page.dart';
import 'package:pinput/pinput.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

final String _number = "01819*********";

class _OtpPageState extends State<OtpPage> {
  bool _isResendButtonDisabled = false;
  String _resendButtonText = 'Resend';
  Timer? _timer;
  int _remainingSeconds = 0;

  void _startResendCountdown() {
    // Start the countdown
    setState(() {
      _isResendButtonDisabled = true;
      _remainingSeconds = 60;
      _updateResendButtonText();
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
          _updateResendButtonText();
        });
      } else {
        // Countdown finished
        timer.cancel();
        setState(() {
          _isResendButtonDisabled = false;
          _resendButtonText = 'Resend';
        });
      }
    });
  }

  void _updateResendButtonText() {
    setState(() {
      _resendButtonText = 'Resend In $_remainingSeconds s';
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText("Verify phone number", TextType.title, fontSize: 27),
              const SizedBox(
                height: 30,
              ),
              customText(
                  "To confirm your account, enter the 6-digit", TextType.normal,
                  fontSize: 14),
              customText("code we sent to $_number", TextType.normal,
                  fontSize: 14),
              const SizedBox(
                height: 20,
              ),
              const Pinput(
                length: 6,
                showCursor: true,
                defaultPinTheme: PinTheme(
                  width: 53,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                          color: AppColor.skyBlue,
                          width: 4.0,
                          style: BorderStyle.solid),
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              SizedBox(
                height: 55,
                width: 320,
                child: ElevatedButton(
                  onPressed: () {
                    slideNavigationPush(Profile(), context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.navyblue,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customText('Continue', TextType.subtitle,
                          color: AppColor.white),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.arrow_forward,
                        color: AppColor.white,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 55,
                width: 320,
                child: ElevatedButton(
                  onPressed: _isResendButtonDisabled
                      ? null
                      : () {
                          _startResendCountdown();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isResendButtonDisabled
                        ? Colors.grey
                        : AppColor.navyblue,
                  ),
                  child: customText(_resendButtonText, TextType.subtitle,
                      color: AppColor.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
