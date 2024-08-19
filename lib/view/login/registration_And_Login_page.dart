import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart'; // Import the package
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/view/common_widget/Common_slideNavigation_Push.dart';
import 'package:kpathshala/view/common_widget/common_button_add.dart';
import 'package:kpathshala/view/common_widget/custom_background.dart';
import 'package:kpathshala/view/common_widget/custom_text.dart.dart';
import 'package:kpathshala/view/login/verify_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key, required this.title});

  final String title;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController myController = TextEditingController();
  String? errorMessage;

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
                      customText(
                        "Login or Sign Up",
                        TextType.title,
                        color: AppColor.navyblue,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  IntlPhoneField(
                    controller: myController,
                    style: const TextStyle(
                      color: AppColor.navyblue,
                    ),
                    decoration: InputDecoration(
                      labelText: "",
                      errorText: errorMessage,
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color:
                              errorMessage == null ? Colors.grey : Colors.red,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color:
                              errorMessage == null ? Colors.blue : Colors.red,
                          width: 2.0,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                    ),
                    initialCountryCode: 'BD',
                    onChanged: (phone) {
                      setState(() {
                        if (phone.number.isEmpty) {
                          errorMessage = "Mobile number is required";
                        } else {
                          errorMessage = null;
                        }
                      });
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 55,
                    width: 320,
                    child: ElevatedButton(
                      onPressed: () {
                        slideNavigationPush(OtpPage(), context);
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
                    height: 30,
                  ),
                  Center(
                    child: Column(
                      children: [
                        customText(
                          "By continuing you agree with",
                          TextType.normal,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 13,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            customText(
                              "K Pathshala’s all",
                              TextType.normal,
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: 13,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              child: customText(
                                "terms and conditions.",
                                TextType.normal,
                                color: AppColor.navyblue,
                                fontSize: 13,
                              ),
                              onTap: () {},
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 150,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                                child: Divider(
                              color: AppColor.draft,
                              thickness: 0.8,
                              indent: 60,
                              endIndent: 5,
                            )),
                            Text('or'),
                            Flexible(
                                child: Divider(
                              color: AppColor.draft,
                              thickness: 0.8,
                              indent: 5,
                              endIndent: 60,
                            )),
                          ],
                        ),
                        SizedBox(height: 15),
                        Column(
                          children: [
                            commonCustomButton(
                              width: double.infinity,
                              height: 50,
                              borderRadius: 25,
                              backgroundColor: Colors.white,
                              margin: EdgeInsets.all(8),
                              onPressed: () {},
                              iconWidget: Image.asset('assets/google_logo.png',
                                  height: 35),
                              reversePosition: false,
                              child: const Text(
                                'Continue with Google',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              isThreeD: false,
                              shadowColor: Colors.transparent,
                            ),
                            SizedBox(height: 5),
                            commonCustomButton(
                              width: double.infinity,
                              height: 50,
                              borderRadius: 25,
                              backgroundColor: Colors.white,
                              margin: EdgeInsets.all(8),
                              onPressed: () {},
                              iconWidget: Image.asset(
                                  'assets/facebook_logo.png',
                                  height: 20),
                              reversePosition: false,
                              child: const Text(
                                'Continue with Facebook',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              isThreeD: false,
                              shadowColor: Colors.transparent,
                            ),
                          ],
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
}
