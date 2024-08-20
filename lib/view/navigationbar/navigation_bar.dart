import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/view/Profile_edit/profile_setting.dart';
import 'package:kpathshala/view/common_widget/Common_slideNavigation_Push.dart';
import 'package:kpathshala/view/common_widget/custom_background.dart';
import 'package:kpathshala/view/dashboard/Courses.dart';
import 'package:kpathshala/view/dashboard/dashboard_page.dart';
import 'package:kpathshala/view/dashboard/exam.dart';
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
    HomePage(
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
              icon: const Icon(
                Icons.graphic_eq_sharp,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications,
                color: Colors.black,
              ),
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
          selectedItemColor: AppColor.navyblue,
          unselectedItemColor: Colors.black,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(color: Colors.black),
          unselectedLabelStyle: const TextStyle(color: Colors.black),
          items: const [
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.home, color: Colors.grey, size: 18),
              activeIcon: FaIcon(FontAwesomeIcons.home,
                  color: AppColor.navyblue, size: 18),
              label: "Home",
              tooltip: '',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.book, color: Colors.grey, size: 18),
              activeIcon: FaIcon(FontAwesomeIcons.book,
                  color: AppColor.navyblue, size: 18),
              label: 'Course',
              tooltip: '',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.objectGroup,
                  color: Colors.grey, size: 18),
              activeIcon: FaIcon(FontAwesomeIcons.objectGroup,
                  color: AppColor.navyblue, size: 18),
              label: 'Exam',
              tooltip: '',
            ),
          ],
        ),
      ),
    );
  }
}
