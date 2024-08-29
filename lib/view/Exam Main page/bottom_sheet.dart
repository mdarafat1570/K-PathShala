import 'package:kpathshala/app_base/common_imports.dart';

class BottomSheetPage extends StatefulWidget {
  const BottomSheetPage({super.key});

  @override
  State<BottomSheetPage> createState() => _BottomSheetPageState();
}

class _BottomSheetPageState extends State<BottomSheetPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: Divider(
            color: Color.fromARGB(255, 217, 217, 217),
            thickness: 4,
            indent: 150,
            endIndent: 150,
          ),
        ),
        Gap(30),
        customText("Confirm purchase", TextType.paragraphTitle),
        Gap(30),
        Container(
          width: 370,
          height: 92,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Color.fromRGBO(241, 239, 239, 1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Payment of ৳999.00",
                  style: TextStyle(
                    color: AppColor.navyBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(5),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: RichText(
                    text: TextSpan(
                      text: "You’ll have access to UBT Mock Test till ",
                      style: TextStyle(
                        color: Colors.grey, // Color for the first part
                        fontSize: 15,
                      ),
                      children: [
                        TextSpan(
                          text: "12th January 2025",
                          style: TextStyle(
                            color: AppColor
                                .navyBlue, // Different color for the date
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Gap(30),
        commonCustomButton(
          width: 370,
          backgroundColor: AppColor.navyBlue,
          height: 60,
          borderRadius: 30,
          onPressed: () {},
          reversePosition: false,
          child: Text(
            "Proceed to payment",
            style: TextStyle(color: AppColor.white, fontSize: 20),
          ),
        ),
        Gap(30),
        SizedBox(
          width: 400,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text:
                  "By proceeding you’re agreeing with K-Pathshala’s purchasing ",
              style: TextStyle(
                color: AppColor.black, // Main color for the text
                fontSize: 14,
              ),
              children: [
                TextSpan(
                  text: "and refund policy.",
                  style: TextStyle(
                    color: AppColor
                        .black, // Keep the same color or change as needed
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
