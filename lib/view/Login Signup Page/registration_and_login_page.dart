import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import'package:kpathshala/app_base/common_imports.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:kpathshala/sign_in_methods/sign_in_methods.dart';
import 'package:kpathshala/view/Login%20Signup%20Page/otp_verify_page.dart';
import 'package:kpathshala/view/Profile%20page/profile_edit.dart';




class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key, required this.title});

  final String title;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController myController = TextEditingController();
  String? errorMessage;

  InputDecoration _inputDecoration() {
    return InputDecoration(
      labelText: "",
      errorText: errorMessage,
      fillColor: Colors.white,
      filled: true,
      border: _borderStyle(),
      focusedBorder: _borderStyle(color: Colors.blue),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
    );
  }

  OutlineInputBorder _borderStyle({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: color ?? (errorMessage == null ? Colors.grey : Colors.red),
        width: 2.0,
      ),
    );
  }

  Widget _customButton(String text, Future<UserCredential> Function() onPressed, String assetPath, {double iconHeight = 35}) {
    return commonCustomButton(
      width: double.infinity,
      height: 50,
      borderRadius: 25,
      backgroundColor: Colors.white,
      margin: const EdgeInsets.all(8),
      onPressed: () async {
        // Show progress indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(child: CircularProgressIndicator());
          },
        );

        try {
          UserCredential userCredential = await onPressed();
          Navigator.of(context).pop(); // Hide progress indicator

          // Pass userCredential to the Profile screen
          slideNavigationPush(Profile(userCredential: userCredential), context);
        } catch (e) {
          Navigator.of(context).pop(); // Hide progress indicator on error
          log('Error during sign-in: $e');
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
                      customText("Login or Sign Up", TextType.title, color: AppColor.navyBlue),
                    ],
                  ),
                  const SizedBox(height: 30),
                  IntlPhoneField(
                    controller: myController,
                    style: const TextStyle(color: AppColor.navyBlue),
                    decoration: _inputDecoration(),
                    initialCountryCode: 'BD',
                    onChanged: (phone) {
                      setState(() {
                        errorMessage = phone.number.isEmpty ? "Mobile number is required" : null;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 55,
                    width: 320,
                    child: ElevatedButton(
                      onPressed: () => slideNavigationPush(const OtpPage(), context),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColor.navyBlue),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customText('Continue', TextType.subtitle, color: AppColor.white),
                          const SizedBox(width: 10),
                          const Icon(Icons.arrow_forward, color: AppColor.white),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Column(
                      children: [
                        customText("By continuing you agree with", TextType.normal, color: Colors.black, fontSize: 13),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            customText("K Pathshala’s all", TextType.normal, color: Colors.black, fontSize: 13),
                            const SizedBox(width: 5),
                            InkWell(
                              child: customText("terms and conditions.", TextType.normal, color: AppColor.navyBlue, fontSize: 13),
                              onTap: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 150),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(child: Divider(color: AppColor.draft, thickness: 0.8, indent: 60, endIndent: 5)),
                            Text('or'),
                            Flexible(child: Divider(color: AppColor.draft, thickness: 0.8, indent: 5, endIndent: 60)),
                          ],
                        ),
                        const Gap(15),
                        _customButton('Continue with Google', SignInMethods.signInWithGoogle, 'assets/google_logo.png'),
                        const Gap(5),
                        _customButton('Continue with Facebook', SignInMethods.signInWithFacebook, 'assets/facebook_logo.png', iconHeight: 20),
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
}
