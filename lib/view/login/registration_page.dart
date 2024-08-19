import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart'; // Import the package
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/view/common_widget/common_button_add.dart';
import 'package:kpathshala/view/common_widget/custom_background.dart';
import 'package:kpathshala/view/common_widget/custom_text.dart.dart';
import 'package:kpathshala/view/login/OTP_page.dart';

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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      customText(
                        "Login or Sign Up",
                        TextType.title,
                        color: AppColor.navyblue,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: IntlPhoneField(
                    controller: myController,
                    style: TextStyle(
                      color: AppColor
                          .navyblue, // Set the text color for the number
                    ),
                    decoration: InputDecoration(
                      labelText: "Mobile Number",

                      errorText: errorMessage,
                      fillColor:
                          Colors.white, // Background color of the input field
                      filled: true,
                      // Enables the fillColor
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
                    initialCountryCode:
                        'BD', // Sets Bangladesh as the default country
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
                ),
                // commonCustomButton(
                //   width: 300,
                //   backgroundColor: AppColor.deepPurple,
                //   height: 50,
                //   borderRadius: 25,
                //   margin: const EdgeInsets.all(10),
                //   onPressed: () {
                //     print("Button pressed");
                //   },
                //   iconWidget: const Icon(
                //     Icons.arrow_forward,
                //     size: 25,
                //     color: Colors.white,
                //   ),
                //   reversePosition: true,
                //   child: customText(
                //     "Continue",
                //     TextType.normal,
                //     color: AppColor.white,
                //     fontSize: 16,
                //   ),
                // ),
                SizedBox(
                  height: 54,
                  width: 320,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => OtpPage()));
                    },
                    child: Text('Continue'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      children: [
                        customText(
                          "By continuing you agree with",
                          TextType.normal,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 14,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            customText(
                              "K Pathshala’s all",
                              TextType.normal,
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: 14,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            customText(
                              "terms and conditions.",
                              TextType.normal,
                              color: AppColor.deepPurple,
                              fontSize: 14,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 250,
                        ),
                        Row(
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
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: InkWell(
                                onTap: () {},
                                child: Ink(
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image(
                                            image: AssetImage(
                                                'assets/googleicon.png')),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text("Continue with Google"),
                                      ],
                                    ),
                                  ),
                                  height: 54,
                                  width: 320,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {},
                              child: Ink(
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(image: AssetImage('assets/fb.png')),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("Continue with Facebook"),
                                    ],
                                  ),
                                ),
                                height: 54,
                                width: 320,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
