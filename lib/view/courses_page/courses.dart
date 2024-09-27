import 'package:flutter/services.dart';
import 'package:kpathshala/app_base/common_imports.dart';


class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: GradientBackground(
        child: Padding(
          padding:const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/new_App_icon.png', height: 150,),
              const Text("Stay tuned premium\ncourses are coming soon",textAlign: TextAlign.center, style: TextStyle(color: AppColor.navyBlue, fontSize: 20,),),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Reset orientation back to portrait when exiting this page
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
