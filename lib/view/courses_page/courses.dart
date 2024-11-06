import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/common_error_all_layout/under_maintenance.dart';
import 'package:kpathshala/main.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  @override
  void initState() {
    super.initState();
    _logScreenView();
  }

  void _logScreenView() {
    MyApp.analytics.logEvent(name: 'screen_view', parameters: {
      'screen_name': 'Courses Page',
    });
  }

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
                    MaterialPageRoute(
                        builder: (context) => const UnderMaintenance()),
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
            ],
          ),
        ),
      ),
    );
  }
}
