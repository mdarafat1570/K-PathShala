import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/view/common_widget/common_app_bar.dart';

class SocialLoginPage extends StatefulWidget {
  const SocialLoginPage({super.key});

  @override
  State<SocialLoginPage> createState() => _SocialLoginPageState();
}

class _SocialLoginPageState extends State<SocialLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        title: 'Social Login Page',
        backgroundColor: AppColor.gradientStart,
        titleColor: AppColor.navyBlue,
        titleFontSize: 20,
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                const Gap(200),
                commonCustomButton(
                    width: double.infinity,
                    backgroundColor: Colors.white,
                    height: 50,
                    borderRadius: 30,
                    onPressed: () {},
                    iconWidget: Image.asset('assets/google_logo.png'),
                    reversePosition: false,
                    child: const Text(
                      "Continue with Google",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    )),
                const Gap(10),
                commonCustomButton(
                    width: double.infinity,
                    backgroundColor: Colors.white,
                    height: 50,
                    borderRadius: 30,
                    onPressed: () {},
                    iconWidget: Image.asset(
                      'assets/facebook_logo.png',
                      width: 20,
                    ),
                    reversePosition: false,
                    child: const Text(
                      "Continue with Facebook",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
