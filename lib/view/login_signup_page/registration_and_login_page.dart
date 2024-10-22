import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:kpathshala/app_base/common_imports.dart';

// import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:kpathshala/base/get_device_id.dart';
import 'package:kpathshala/model/log_in_credentials.dart';
import 'package:kpathshala/model/registration_api_response_model.dart';
import 'package:kpathshala/repository/authentication_repository.dart';
import 'package:kpathshala/repository/sign_in_methods.dart';
import 'package:kpathshala/view/login_signup_page/otp_verify_page.dart';
import 'package:kpathshala/view/navigation_bar_page/navigation_bar.dart';
import 'package:kpathshala/view/profile_page/profile_edit.dart';
import 'package:kpathshala/view/common_widget/common_loading_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

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

     Future<void> launchTermsUrl() async {
    final url = Uri.parse("https://kpathshala.com/terms-and-conditions.html");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
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
                  CustomTextField(
                    controller: mobileNumberController,
                    fontSize: 18,
                    maxLength: 11,
                    keyboardType: TextInputType.number,
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset("assets/bangladesh.png", height: 18),
                        const Text(
                          " +88 ",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    errorMessage: errorMessage,
                    onChanged: (_) {
                      if (mobileNumberController.text.isNotEmpty) {
                        errorMessage = null;
                        setState(() {});
                      } else if (mobileNumberController.text.isEmpty) {
                        setState(() {
                          errorMessage = "Please provide a valid phone number";
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 55,
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () {
                        String rawNumber = mobileNumberController.text;
                        if (rawNumber.isNotEmpty && rawNumber.length == 11) {
                          sendOtp(mobileNumber: rawNumber);
                        } else if (rawNumber.length < 11) {
                          setState(() {
                            errorMessage =
                                "Please provide a valid phone number";
                          });
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
                              onTap: launchTermsUrl,
                              child: customText(
                                  "terms and conditions.", TextType.normal,
                                  color: AppColor.navyBlue, fontSize: 13),
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
                        const Gap(100),
                        _customButton(
                            'Continue with Google',
                            SignInMethods.signInWithGoogle,
                            'assets/google_logo.png'),
                        const Gap(5),
                        Visibility(
                          visible: false,
                          child: _customButton(
                              'Continue with Facebook',
                              SignInMethods.signInWithFacebook,
                              'assets/facebook_logo.png',
                              iconHeight: 20),
                        ),
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

    final response = await _authService.sendOtp(mobileNumber,context: context);
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
    // Extract user data
    final user = userCredential.user;
    final name = user?.displayName ?? "";
    final email = user?.email ?? "";
    final image = user?.photoURL ?? "";
    final deviceId = await getDeviceId() ?? "";

    log("User Data $name, $email, $deviceId");

    try {
      // Register user
      final response = await _authService.registerUser(
        name: name,
        email: email,
        mobile: "",
        image: image,
        deviceId: deviceId,
      );

      log(jsonEncode(response));

      // Check for error in response
      final isSuccess = response['error'] == null || !response['error'];
      if (isSuccess && mounted) {
        final apiResponse = RegistrationApiResponse.fromJson(response);
        final data = apiResponse.data;

        // Store token and user credentials
        final token = data?.token;
        await _authService.saveToken(token.toString());

        final user = data?.user;
        await _authService.saveLogInCredentials(LogInCredentials(
          email: user?.email,
          name: user?.name,
          imagesAddress: user?.image,
          mobile: user?.mobile,
          token: token,
        ));

        if (mounted) {
          showLoadingIndicator(context: context, showLoader: false);

          // Navigate based on mobile verification status
          if (data?.mobileVerified == false) {
            slideNavigationPushAndRemoveUntil(
              Profile(
                deviceId: deviceId,
                isFromGmailOrFacebookLogin: true,
                isMobileVerified: false,
              ),
              context,
            );
          } else {
            slideNavigationPushAndRemoveUntil(const Navigation(), context);
          }

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration successful.")),
          );
        }
      } else {
        _handleRegistrationError(response['message']);
      }
    } catch (e) {
      _handleRegistrationError(e.toString());
    }
  }

  void _handleRegistrationError(String message) async {
    await SignInMethods.logout();
    if (mounted) {
      showLoadingIndicator(context: context, showLoader: false);
      log(message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
}
