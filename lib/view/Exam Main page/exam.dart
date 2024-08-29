import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/view/Exam%20Main%20page/bottom_sheet.dart';

class Exam extends StatefulWidget {
  const Exam({super.key});

  @override
  State<Exam> createState() => _ExamState();
}

class _ExamState extends State<Exam> {
  void _showModelBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            padding: const EdgeInsets.all(16.0), child: BottomSheetPage());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GradientBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16), // Add padding to prevent overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(20),
              customText("Mock tests and exams", TextType.paragraphTitle),
              Gap(30),
              Container(
                width:
                    screenWidth > 360 ? 360 : screenWidth, // Responsive width
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        customText(
                            "UBT Mock Test", TextType.paragraphTitlenormal),
                        Gap(10),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColor.lightred,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.recordVinyl,
                                color: Colors.red,
                                size: 12,
                              ),
                              Gap(3),
                              Text(
                                'Running',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Gap(16),
                    RichText(
                      text: TextSpan(
                        text: 'For only ৳999.00 ',
                        style: TextStyle(
                          color: AppColor.black,
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' ৳1,500.00',
                            style: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.grey,
                              decorationThickness: 2.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(8),
                    customText(
                      "Crack UBT with ease with our mock tests and study guide.",
                      TextType.normal,
                    ),
                    Gap(16),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "• 100 Question sets\n• 2,000 Listening questions\n• 2,000 Reading questions\n• Set based question solve video\n• UBT Standard exam UI\n• Access for 5 months\n• Unlimited revisions\n• Performance analysis",
                        style: TextStyle(fontSize: 12, height: 1.7),
                      ),
                    ),
                    Gap(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 45, vertical: 6),
                            backgroundColor: Color.fromRGBO(26, 35, 126, 0.15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text('Preview'),
                        ),
                        Gap(8),
                        ElevatedButton(
                          onPressed: _showModelBottomSheet,
                          child: Text(
                            'Buy now',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 45, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
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
    );
  }
}
