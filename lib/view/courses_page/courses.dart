import 'package:flutter/services.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/common_error_all_layout/connection_lost.dart';
import 'package:kpathshala/common_error_all_layout/page_not_found.dart';
import 'package:kpathshala/common_error_all_layout/under_maintenance.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  @override
  Widget build(BuildContext context) {
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
                  "Stay tuned premium\ncourses are coming soon (UNTHORIG)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.navyBlue,
                    fontSize: 12,
                  ),
                ),
              ),
              Gap(30),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ConnectionLost()),
                  );
                },
                child: const Text(
                  "Stay tuned premium\ncourses are coming soon (INTERNET)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.navyBlue,
                    fontSize: 12,
                  ),
                ),
              ),
              Gap(30),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PageNotFound()),
                  );
                },
                child: const Text(
                  "Stay tuned premium\ncourses are coming soon (Page Not)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.navyBlue,
                    fontSize: 12,
                  ),
                ),
              ),
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
