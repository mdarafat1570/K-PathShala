import 'package:kpathshala/app_base/common_imports.dart';

class SocialLogin extends StatefulWidget {
  const SocialLogin({super.key});

  @override
  State<SocialLogin> createState() => _SocialLoginState();
}

class _SocialLoginState extends State<SocialLogin> {
  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Connect Social Login"),
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Gap(100),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: customText(
                    "Connect your account with any social media from bellow for easier login.",
                    TextType.normal),
              ),
              const Gap(20),
              commonCustomButton(
                  width: double.infinity,
                  backgroundColor: Colors.white,
                  height: 55,
                  borderRadius: 30,
                  onPressed: () {},
                  iconWidget: Image.asset('assets/google_logo.png'),
                  reversePosition: false,
                  child: const Text(
                    "Continue with Google",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  )),
              const Gap(10),
              Visibility(
                visible: false,
                child: commonCustomButton(
                    width: double.infinity,
                    backgroundColor: Colors.white,
                    height: 55,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
