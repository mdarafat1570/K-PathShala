import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'dart:async';
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/authentication/base_repository.dart';
import 'package:kpathshala/base/get_device_id.dart';
import 'package:kpathshala/main.dart';
import 'package:kpathshala/model/log_in_credentials.dart';
import 'package:kpathshala/model/otp_response_model.dart';
import 'package:kpathshala/repository/authentication_repository.dart';
import 'package:kpathshala/repository/verify_otp_repository.dart';
import 'package:kpathshala/view/login_signup_page/device_id_bottom_sheet.dart';
import 'package:kpathshala/view/navigation_bar_page/navigation_bar.dart';
import 'package:kpathshala/view/profile_page/profile_edit.dart';
import 'package:kpathshala/view/common_widget/common_slide_navigation_push.dart';
import 'package:kpathshala/view/common_widget/common_loading_indicator.dart';
import 'package:kpathshala/view/common_widget/custom_background.dart';
import 'package:kpathshala/view/common_widget/custom_text.dart.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpPage extends StatefulWidget {
  final String mobileNumber;
  final String? email;

  const OtpPage({super.key, required this.mobileNumber, this.email});

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
  AuthenticationService authenticationService = AuthenticationService();

  @override
  void initState() {
    super.initState();
    _startResendCountdown();
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
                customText(
                    "To confirm your account, enter the 6-digit code we sent to ${widget.mobileNumber}",
                    TextType.normal,
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
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
                                sendOtp(
                                    mobileNumber: widget.mobileNumber,
                                    context: context);
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

  void _startResendCountdown() {

    setState(() {
      _isResendButtonDisabled = true;
      _remainingSeconds = 60;
      _updateResendButtonText();
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
          _updateResendButtonText();
        });
      } else {

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
  Future<String?> getOneSignalPlayerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(Preferences.oneSignalUserId);
  }

void _verifyOtp() async {
  try {
    // Show loading indicator
    showLoadingIndicator(context: context, showLoader: true);

    // Prepare data for OTP verification
    String mobile = widget.mobileNumber;
    String deviceId = await getDeviceId() ?? "";
    int otp = int.tryParse(pinController.text.trim()) ?? 0;
    String oneSignalPlayerId = await getOneSignalPlayerId() ?? "";

    log("Mobile: $mobile");
    log("OTP: ${pinController.text}");
    log("Device ID: $deviceId");
    log("OneSignal Player ID: $oneSignalPlayerId");

    // Call the API to verify OTP
    final response = await authenticationService.verifyOtp(
      mobile,
      otp,
      deviceId,
      oneSignalPlayerId: oneSignalPlayerId,
      context: context,
    );

    // Handle successful response
    final apiResponse = OTPApiResponse.fromJson(response);
    log("API Response: ${jsonEncode(response)}");

    if (mounted) {
      showLoadingIndicator(context: context, showLoader: false);

      if (apiResponse.successResponse != null) {
        final token = apiResponse.successResponse!.data.token;
        final name = apiResponse.successResponse!.data.user.name;
        final email = apiResponse.successResponse!.data.user.email;
        final mobile = apiResponse.successResponse!.data.user.mobile;
        final imageUrl = apiResponse.successResponse!.data.user.image;

        // Save login credentials
        await _authService.saveLogInCredentials(LogInCredentials(
          email: email,
          name: name,
          imagesAddress: imageUrl,
          mobile: mobile,
          token: token,
        ));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP verified successfully.")),
        );

        // Navigate based on profile requirement
        if (apiResponse.successResponse?.data.isProfileRequired == true) {
          slideNavigationPushAndRemoveUntil(Profile(deviceId: deviceId), context);
        } else {
          slideNavigationPushAndRemoveUntil(const Navigation(), context);
        }
      }
    }
  } catch (e) {
    log("Error verifying OTP: $e");
    String errorMessage = e.toString().replaceFirst("Exception: ", "");
    if (e is Exception && e.toString().contains('Login device limitation is over')) {
      showLoadingIndicator(context: context, showLoader: false);
      _showDeviceIdBottomSheet(context);
    } else if (mounted) {
      showLoadingIndicator(context: context, showLoader: false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }
}


// Function to show DeviceIdButtonSheet
void _showDeviceIdBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return const DeviceIdBottomSheet();
    },
  ).then((_){
    BaseRepository().userSignOut(context);
  });
}


  void sendOtp(
      {required String mobileNumber, required BuildContext context}) async {
    showLoadingIndicator(context: context, showLoader: true);

    if (mobileNumber.isEmpty) {
      showLoadingIndicator(context: context, showLoader: false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your mobile number.")),
      );
      return;
    }

    final response = await _authService.sendOtp(mobileNumber, context: context);
    log(jsonEncode(response));

    if (response['error'] == null || !response['error']) {
      if (mounted) {
        showLoadingIndicator(context: context, showLoader: false);
        _startResendCountdown();
      }
    } else {
      if (mounted) {
        showLoadingIndicator(context: context, showLoader: false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to send OTP: ${response['message']}")),
        );
      }
    }
  }
}
