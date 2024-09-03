import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'dart:async';
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/base/get_device_Id.dart';
import 'package:kpathshala/repository/Otp_send_repository.dart';
import 'package:kpathshala/view/Profile%20page/profile_edit.dart';
import 'package:kpathshala/view/common_widget/Common_slideNavigation_Push.dart';
import 'package:kpathshala/view/common_widget/custom_background.dart';
import 'package:kpathshala/view/common_widget/custom_text.dart.dart';
import 'package:pinput/pinput.dart';

class OtpPage extends StatefulWidget {
  final String mobileNumber;
  const OtpPage({super.key, required this.mobileNumber});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  bool _isResendButtonDisabled = false;
  String _resendButtonText = 'Resend';
  Timer? _timer;
  int _remainingSeconds = 0;
  final AuthService _authService = AuthService();
  TextEditingController pinController = TextEditingController();

  void _startResendCountdown() {
    // Start the countdown
    setState(() {
      _isResendButtonDisabled = true;
      _remainingSeconds = 60;
      _updateResendButtonText();
    });

    _timer = Timer.periodic(const Duration(minutes: 5), (timer) {
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
    pinController.dispose;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 80),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText("Verify phone number", TextType.title, fontSize: 27),
                const Gap(20),
                customText("To confirm your account, enter the 6-digit",
                    TextType.normal,
                    fontSize: 14),
                customText("code we sent to ${widget.mobileNumber}", TextType.normal,
                    fontSize: 14),
                const Gap(20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     Pinput(
                       controller: pinController,
                      length: 6,
                      showCursor: true,
                      defaultPinTheme: PinTheme(
                        width: 54,
                        height: 58,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color.fromRGBO(253, 242, 250, 1),
                            width: 1.0,
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.skyBlue.withOpacity(0.6),
                              offset: const Offset(0, 4),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(20),
                    SizedBox(
                      height: 55,
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: _verifyOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.navyBlue,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            customText('Confirm', TextType.subtitle,
                                color: AppColor.white),
                            const Gap(10),
                            const Icon(
                              Icons.arrow_forward,
                              color: AppColor.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(10),
                    SizedBox(
                      height: 55,
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: _isResendButtonDisabled
                            ? null
                            : () {
                                _startResendCountdown();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isResendButtonDisabled
                              ? Colors.grey
                              : AppColor.navyBlue,
                        ),
                        child: customText(_resendButtonText, TextType.subtitle,
                            color: AppColor.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showApiCallingInProgress() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void _verifyOtp() async {
    String mobile = widget.mobileNumber;

    String deviceId = await getDeviceId() ?? "";
    int otp = int.tryParse(pinController.text.trim()) ?? 0;
    log(mobile);
    log(pinController.text);
    log(deviceId);

    final response =
    await _authService.verifyOtp(mobile, otp, deviceId);

    log(jsonEncode(response));

    if (response['error'] == null || !response['error']) {
      showApiCallingInProgress();
      if(mounted){
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP verified successfully.")),
        );
        slideNavigationPush(Profile(mobileNumber: mobile,), context);
      }
    } else {
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to verify OTP: ${response['message']}")),
        );
      }
    }
  }
}
