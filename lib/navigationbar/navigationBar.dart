import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:kpathshala/dashbord/courses_page.dart';
import 'package:kpathshala/dashbord/exam_page.dart';
import 'package:kpathshala/dashbord/home_Page.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int countindex = 0;
  List<Widget> widgetList = [
    MyHomePage(
      title: 'app',
    ),
    Courses(),
    Exam(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        selectedItemColor: AppColor.deepPurple,
        unselectedItemColor: Colors.black,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(color: Colors.black),
        unselectedLabelStyle: const TextStyle(color: Colors.black),
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.home, color: Colors.grey, size: 18),
            activeIcon: FaIcon(FontAwesomeIcons.home,
                color: AppColor.deepPurple, size: 18),
            label: "Home",
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.book, color: Colors.grey, size: 18),
            activeIcon: FaIcon(FontAwesomeIcons.book,
                color: AppColor.deepPurple, size: 18),
            label: 'Course',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.objectGroup,
                color: Colors.grey, size: 18),
            activeIcon: FaIcon(FontAwesomeIcons.objectGroup,
                color: AppColor.deepPurple, size: 18),
            label: 'Exam',
            tooltip: '',
          ),
        ],
      ),
    );
  }
}
