import 'package:flutter/material.dart';
import 'dart:async'; // For Timer
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/view/common_widget/custom_background.dart';
import 'package:kpathshala/view/common_widget/custom_text.dart.dart';
import 'package:pinput/pinput.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

final String _number = "01819256672";

class _OtpPageState extends State<OtpPage> {
  bool _isResendButtonDisabled = false; // Track resend button state
  String _resendButtonText = 'Resend'; // Button text
  Timer? _timer;
  int _remainingSeconds = 0; // Remaining seconds for countdown

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 67, right: 50),
              child: Align(
                alignment: Alignment.topCenter,
                child: customText("Verify phone number", TextType.title,
                    fontSize: 27),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, right: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText("To confirm your account, enter the 6-digit",
                      TextType.normal,
                      fontSize: 14),
                  customText("code we sent to $_number", TextType.normal,
                      fontSize: 14),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Pinput(
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
                      ),
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                height: 54,
                width: 350,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => OtpPage()));
                  },
                  child: Text('Continue'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                height: 54,
                width: 350,
                child: ElevatedButton(
                  onPressed: _isResendButtonDisabled
                      ? null
                      : () {
                          _startResendCountdown();
                          // Handle resend logic here
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isResendButtonDisabled
                        ? Colors.grey
                        : AppColor.navyblue,
                  ),
                  child: Text(_resendButtonText),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
