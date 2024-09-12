import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:kpathshala/app_base/common_imports.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:kpathshala/base/get_device_id.dart';
import 'package:kpathshala/model/log_in_credentials.dart';
import 'package:kpathshala/model/registration_api_response_model.dart';
import 'package:kpathshala/repository/authentication_repository.dart';
import 'package:kpathshala/repository/sign_in_methods.dart';
import 'package:kpathshala/view/login_signup_age/otp_verify_page.dart';
import 'package:kpathshala/view/navigation_bar_page/navigation_bar.dart';
import 'package:kpathshala/view/profile_page/profile_edit.dart';
import 'package:kpathshala/view/common_widget/common_loading_indicator.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key, required this.title});

  final String title;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController mobileNumberController = TextEditingController();
  String? errorMessage;
  final AuthService _authService = AuthService();

  InputDecoration _inputDecoration() {
    return InputDecoration(
      labelText: "",
      errorText: errorMessage,
      fillColor: Colors.white,
      filled: true,
      border: _borderStyle(),
      focusedBorder: _borderStyle(color: AppColor.navyBlue),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
    );
  }

  OutlineInputBorder _borderStyle({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: color ?? (errorMessage == null ? Colors.grey : Colors.red),
        width: 0.2,
      ),
    );
  }

  Widget _customButton(String text, Future<UserCredential> Function() onPressed,
      String assetPath,
      {double iconHeight = 35}) {
    return commonCustomButton(
      width: double.infinity,
      height: 55,
      borderRadius: 30,
      backgroundColor: Colors.white,
      margin: const EdgeInsets.all(8),
      onPressed: () async {
        showLoadingIndicator(context: context, showLoader: true);
        try {
          UserCredential userCredential = await onPressed();

          if (mounted) {
            _registerUser(userCredential);
          }
        } catch (e) {
          if (mounted) {
            showLoadingIndicator(context: context, showLoader: false);
          }
          log('Error during sign-in with gmail or facebook: $e');
        }
      },
      iconWidget: Image.asset(assetPath, height: iconHeight),
      reversePosition: false,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
      isThreeD: false,
      shadowColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.accentColor,
      body: GradientBackground(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      customText("Login or Sign Up", TextType.title,
                          color: AppColor.navyBlue),
                    ],
                  ),
                  const SizedBox(height: 30),
                  IntlPhoneField(
                    controller: mobileNumberController,
                    style: const TextStyle(color: AppColor.navyBlue),
                    decoration: _inputDecoration(),
                    initialCountryCode: 'BD', // For Bangladesh
                    onChanged: (phone) {
                      setState(() {
                        errorMessage = phone.number.isEmpty
                            ? "Mobile number is required"
                            : null;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 55,
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () {
                        if (mobileNumberController.text.isNotEmpty) {
                          String rawNumber = mobileNumberController.text;

                          if (rawNumber.length == 10) {
                            rawNumber = '0$rawNumber';
                          }

                          sendOtp(mobileNumber: rawNumber);
                        } else {
                          setState(() {
                            errorMessage = "Mobile number is required";
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.navyBlue,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customText('Continue', TextType.subtitle,
                              color: AppColor.white),
                          const SizedBox(width: 10),
                          const Icon(Icons.arrow_forward,
                              color: AppColor.white),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Column(
                      children: [
                        customText(
                            "By continuing you agree with", TextType.normal,
                            color: Colors.black, fontSize: 13),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            customText("K Pathshala’s all", TextType.normal,
                                color: Colors.black, fontSize: 13),
                            const SizedBox(width: 5),
                            InkWell(
                              child: customText(
                                  "terms and conditions.", TextType.normal,
                                  color: AppColor.navyBlue, fontSize: 13),
                              onTap: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 150),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                                child: Divider(
                                    color: AppColor.draft,
                                    thickness: 0.8,
                                    indent: 60,
                                    endIndent: 5)),
                            Text('or'),
                            Flexible(
                                child: Divider(
                                    color: AppColor.draft,
                                    thickness: 0.8,
                                    indent: 5,
                                    endIndent: 60)),
                          ],
                        ),
                        const Gap(15),
                        _customButton(
                            'Continue with Google',
                            SignInMethods.signInWithGoogle,
                            'assets/google_logo.png'),
                        const Gap(5),
                        _customButton(
                            'Continue with Facebook',
                            SignInMethods.signInWithFacebook,
                            'assets/facebook_logo.png',
                            iconHeight: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void sendOtp({required String mobileNumber}) async {
    showLoadingIndicator(context: context, showLoader: true);
    if (mobileNumber.isEmpty) {
      showLoadingIndicator(context: context, showLoader: false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your mobile number.")),
      );
      return;
    }

    final response = await _authService.sendOtp(mobileNumber);
    log(jsonEncode(response));
    if (response['error'] == null || !response['error']) {
      if (mounted) {
        showLoadingIndicator(context: context, showLoader: false);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("OTP sent to $mobileNumber.")),
        // );
        slideNavigationPush(
            OtpPage(
              mobileNumber: mobileNumber,
            ),
            context);
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

  void _registerUser(UserCredential userCredential) async {
    String name = userCredential.user?.displayName ?? "";
    String email = userCredential.user?.email ?? "";
    String image = userCredential.user?.photoURL ?? "";
    String deviceId = await getDeviceId() ?? "";

    log("User Data $name, $email, $deviceId");

    final response = await _authService.registerUser(
        name: name, email: email, mobile: "", image: image, deviceId: deviceId);
    log(jsonEncode(response));

    if ((response['error'] == null || !response['error']) && mounted) {
      final apiResponse = RegistrationApiResponse.fromJson(response);
      showLoadingIndicator(context: context, showLoader: false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration successful.")),
      );
      // Store token in shared preferences
      final token = apiResponse.data?.token;
      final name = apiResponse.data?.user?.name;
      final email = apiResponse.data?.user?.email;
      final mobile = apiResponse.data?.user?.mobile;
      final imageUrl = apiResponse.data?.user?.image;
      await _authService.saveLogInCredentials(LogInCredentials(
        email: email,
        name: name,
        imagesAddress: imageUrl,
        mobile: mobile,
        token: token,
      ));
      if (mounted){
        if (apiResponse.data?.mobileVerified == false) {
          slideNavigationPushAndRemoveUntil(
              Profile(deviceId: deviceId, isFromGmailOrFacebookLogin: true),
              context);
        } else {
          slideNavigationPushAndRemoveUntil(const Navigation(), context);
        }
      }
    } else {
      if (mounted) {
        showLoadingIndicator(context: context, showLoader: false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Registration failed: ${response['message']}")),
        );
      }
    }
  }
}
