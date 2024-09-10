import 'package:flutter_svg/svg.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/view/Notifications/notifications_page.dart';
import 'package:kpathshala/view/Courses%20page/Courses.dart';
import 'package:kpathshala/view/Home%20Main%20Page/dashboard_page.dart';
import 'package:kpathshala/view/Profile%20page/profile_screen_main.dart';
import 'package:kpathshala/view/exam_main_page/course_purchase_page.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int countIndex = 0;
  List<Widget> widgetList = [
    const DashboardPage(),
    const Courses(),
    const CoursePurchasePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(12),
            child: GestureDetector(
              onTap: () {
                slideNavigationPush(ProfileScreenInMainPage(), context);
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/Profile.jpg'),
              ),
            ),
          ),
          title: const Center(child: Text('')),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                'assets/ic_Result_icon.svg',
                width: 23.0,
                height: 23.0,
              ),
            ),
            InkWell(
              onTap: () {
                slideNavigationPush(const NotificationsPage(), context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  'assets/ic_notifications.svg',
                  width: 34.0,
                  height: 34.0,
                ),
              ),
            ),
            const Gap(7)
          ],
        ),
        body: Center(
          child: widgetList[countIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColor.lightGray,
          elevation: 0,
          onTap: (index) {
            setState(() {
              countIndex = index;
            });
          },
          currentIndex: countIndex,
          selectedItemColor: AppColor.navyBlue,
          unselectedItemColor: Colors.black,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(color: Colors.black),
          unselectedLabelStyle: const TextStyle(color: Colors.black),
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/Home_black.svg', // Ensure this path points to your SVG file
                width: 18.0, // Adjust size as needed
                height: 18.0,
              ),
              activeIcon: SvgPicture.asset(
                'assets/ic_home.svg', // Path to the active state SVG file
                width: 24.0,
                height: 24.0,
              ),
              label: "Home",
              tooltip: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/Icon.svg',
                width: 18.0,
                height: 18.0,
              ),
              activeIcon: SvgPicture.asset(
                'assets/Icon_courses_black.svg',
                width: 22.0,
                height: 22.0,
              ),
              label: "Course",
              tooltip: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/ic_exam1.svg',
                width: 18.0,
                height: 18.0,
              ),
              activeIcon: SvgPicture.asset(
                'assets/test.svg',
                width: 22.0,
                height: 22.0,
              ),
              label: "Exam",
              tooltip: '',
            ),
          ],
        ),
      ),
    );
  }
}
