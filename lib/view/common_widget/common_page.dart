import 'package:kpathshala/app_base/common_imports.dart';

class ButtonVariations extends StatefulWidget {
  const ButtonVariations({super.key});

  @override
  ButtonVariationsState createState() => ButtonVariationsState();
}

class ButtonVariationsState extends State<ButtonVariations> {
  final TextEditingController myController = TextEditingController();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              commonCustomButton(
                width: 300,
                backgroundColor: Colors.white,
                height: 50,
                borderRadius: 25,
                isThreeD: true,
                shadowColor: Colors.black,
                isPressed: true,
                animate: true,
                margin: const EdgeInsets.all(10),
                onPressed: () {},
                iconWidget: const Icon(
                  Icons.abc,
                  size: 30,
                ),
                reversePosition: true,
                child: const Text("Continue Arafat"),
              ),
              commonCustomButton(
                width: 300,
                backgroundColor: AppColor.navyBlue,
                height: 50,
                borderRadius: 25,
                margin: const EdgeInsets.all(10),
                onPressed: () {},
                iconWidget: const Icon(
                  Icons.abc,
                  size: 30,
                  color: Colors.white,
                ),
                reversePosition: true,
                child: const Text("Continue Arafat"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  controller: myController,
                  label: "Mobile Number",
                  // hintText: "Enter your mobile number",
                  errorMessage: errorMessage,
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        errorMessage = "Mobile number is required";
                      } else {
                        errorMessage = null;
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
