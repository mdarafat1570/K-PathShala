import 'package:flutter/services.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/common_error_all_layout/connection_lost.dart';
import 'package:kpathshala/common_error_all_layout/page_not_found.dart';
import 'package:kpathshala/common_error_all_layout/under_maintenance.dart';
import 'package:kpathshala/view/login_signup_page/device_id_bottom_sheet.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final heightPercentage = 315 / screenHeight;
    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/new_App_icon.png',
                height: 150,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UnderMaintenance()),
                  );
                },
                child: const Text(
                  "Stay tuned premium\ncourses are coming soon.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.navyBlue,
                    fontSize: 12,
                  ),
                ),
              ),
              // Visibility(
              //   visible: false,
              //   child: ElevatedButton(
              //       onPressed: () {
              //         showCommonBottomSheet(
              //           context: context,
              //           content: const DeviceIdBottomSheet(),
              //           actions: [],
              //           color: Colors.white,
              //           height: screenHeight * heightPercentage,
              //         );
              //       },
              //       child: const Text("Bottom Sheet")),
              // )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
