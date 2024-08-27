import 'package:flutter/material.dart';
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/view/Notifications/notifications_page.dart';
import 'package:kpathshala/view/Profile_edit/profile_setting.dart';
import 'package:kpathshala/view/common_widget/Common_slideNavigation_Push.dart';
import 'package:kpathshala/view/common_widget/custom_background.dart';
import 'package:kpathshala/view/dashboard/Courses.dart';
import 'package:kpathshala/view/dashboard/dashboard_page.dart';
import 'package:kpathshala/view/dashboard/home_Page.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int countindex = 0;
  List<Widget> widgetList = [
    DashboardPage(),
    Courses(),
    const HomePage(
      title: "",
    ),
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
                slideNavigationPush(Profile(), context);
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/Profile.jpg'),
              ),
            ),
          ),
          title: const Center(child: Text('')),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Image(image: AssetImage('assets/Score.png')),
            ),
            IconButton(
              onPressed: () {
                slideNavigationPush(NotificationsPage(), context);
              },
              icon: const Image(image: AssetImage('assets/bell.png')),
            ),
          ],
        ),
        body: Center(
          child: widgetList[countindex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColor.lightGray,
          elevation: 0,
          onTap: (index) {
            setState(() {
              countindex = index;
            });
          },
          currentIndex: countindex,
          selectedItemColor: AppColor.navyBlue,
          unselectedItemColor: Colors.black,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(color: Colors.black),
          unselectedLabelStyle: const TextStyle(color: Colors.black),
          items: const [
            BottomNavigationBarItem(
              icon: Image(image: AssetImage('assets/icon.png')),
              activeIcon: Image(image: AssetImage('assets/Home_Icon_Fill.png')),
              label: "Home",
              tooltip: '',
            ),
            BottomNavigationBarItem(
              icon: Image(image: AssetImage('assets/Type=Outlined.png')),
              activeIcon: Image(image: AssetImage('assets/Type=Filled.png')),
              label: 'Course',
              tooltip: '',
            ),
            BottomNavigationBarItem(
              icon: Image(image: AssetImage('assets/exam_fill.png')),
              activeIcon: Image(image: AssetImage('assets/Exam.png')),
              label: 'Exam',
              tooltip: '',
            ),
          ],
        ),
      ),
    );
  }
}
