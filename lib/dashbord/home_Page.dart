import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl_phone_field/intl_phone_field.dart'; // Import the package
import 'package:kpathshala/Page/Gradientbackground.dart';
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/widget/common_widget/common_button_add.dart';
import 'package:kpathshala/widget/common_widget/custom_text.dart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController myController = TextEditingController();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    decoration: InputDecoration(
                      labelText: "Mobile Number",
                      hintText: "Mobile",
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
                ),
                commonCustomButton(
                  width: 300,
                  backgroundColor: AppColor.navyblue,
                  height: 50,
                  borderRadius: 25,
                  margin: const EdgeInsets.all(10),
                  onPressed: () {
                    print("Button pressed");
                  },
                  iconWidget: const Icon(
                    Icons.arrow_forward,
                    size: 25,
                    color: Colors.white,
                  ),
                  reversePosition: true,
                  child: customText(
                    "Continue",
                    TextType.normal,
                    color: AppColor.white,
                    fontSize: 16,
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
                              color: AppColor.navyblue,
                              fontSize: 14,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 130),
                // Divider with "or"
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child:
                          Text('or', style: TextStyle(color: Colors.black54)),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 30),

                commonCustomButton(
                  width: 300,
                  backgroundColor: Colors.white,
                  height: 50,
                  borderRadius: 25,
                  isThreeD: true,
                  isPressed: true,
                  animate: true,
                  margin: const EdgeInsets.all(10),
                  onPressed: () {},
                  iconWidget: Image.asset('assets/google_logo.png', height: 45),
                  reversePosition: true,
                  child: customText(
                    "Continue with Google",
                    TextType.subtitle,
                    color: AppColor.notBillable,
                    fontSize: 18,
                  ),
                ),
                commonCustomButton(
                  width: 300,
                  backgroundColor: Colors.white,
                  height: 50,
                  borderRadius: 25,
                  isThreeD: true,
                  isPressed: true,
                  animate: true,
                  margin: const EdgeInsets.all(10),
                  onPressed: () {},
                  iconWidget:
                      Image.asset('assets/facebook_logo.png', height: 24),
                  reversePosition: true,
                  child: customText(
                    "Continue with Facebook",
                    TextType.subtitle,
                    color: AppColor.notBillable,
                    fontSize: 18,
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
