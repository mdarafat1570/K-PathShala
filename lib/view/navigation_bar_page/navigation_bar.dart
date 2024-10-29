import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/common_error_all_layout/connection_lost.dart';
import 'package:kpathshala/model/log_in_credentials.dart';
import 'package:kpathshala/repository/authentication_repository.dart';
import 'package:kpathshala/view/courses_page/courses.dart';
import 'package:kpathshala/view/exam_main_page/exam_purchase_page.dart';
import 'package:kpathshala/view/home_main_page/dashboard_page.dart';
import 'package:kpathshala/view/notifications/notifications_page.dart';
import 'package:kpathshala/view/profile_page/profile_screen_main.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> with WidgetsBindingObserver {
  int countIndex = 0;
  bool isDialogVisible = false;
  bool isConnectedToInternet = false;
  List<Widget> widgetList = [
    const DashboardPage(),
    const Courses(),
    const ExamPurchasePage(),
  ];
  StreamSubscription? _internetConnectionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _internetConnectionStreamSubscription =
        InternetConnection().onStatusChange.listen((event) {
      log("$event");
      switch (event) {
        case InternetStatus.connected:
          setState(() {
            isConnectedToInternet = true;
          });
          if (Navigator.canPop(context)) {
            Navigator.pop(
                context); // Close ConnectionLost page when internet is back
          }
          break;
        case InternetStatus.disconnected:
          setState(() {
            isConnectedToInternet = false;
            slideNavigationPush(const ConnectionLost(), context);
          });
          break;
        default:
          setState(() {
            isConnectedToInternet = false;
          });
          break;
      }
    });
    readCredentials();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _internetConnectionStreamSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<bool> showExitConfirmation(BuildContext context) async {
    if (!isDialogVisible) {
      isDialogVisible = true;
      bool shouldExit = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirmation"),
                content: const Text(
                    "Do you want to leave this page or close the app?"),
                actions: [
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  TextButton(
                    child: const Text("Yes"),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            },
          ) ??
          false;
      isDialogVisible = false;
      return shouldExit;
    } else {
      return false;
    }
  }

  LogInCredentials? credentials;

  final AuthService _authService = AuthService();

  Future<void> readCredentials() async {
    credentials = await _authService.getLogInCredentials();

    if (credentials == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No credentials found")),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> imageProvider;
    if (credentials?.imagesAddress != null &&
        credentials?.imagesAddress != "") {
      imageProvider = NetworkImage(credentials!.imagesAddress ?? '');
    } else {
      imageProvider = const AssetImage('assets/new_App_icon.png');
    }
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        if (countIndex > 0) {
          setState(() {
            countIndex = 0;
          });
        } else {
          bool shouldExit = await showExitConfirmation(context);
          if (shouldExit) {
            SystemNavigator.pop();
          }
        }
      },
      child: GradientBackground(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.gradientStart,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: GestureDetector(
              onTap: () {
                slideNavigationPush(const ProfileScreenInMainPage(), context);
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: imageProvider,
                    radius: 18, 
                  ),
                  const Gap(5),
                  Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, 
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      if (credentials?.name != null &&
                          credentials!.name!.isNotEmpty)
                        Text(
                          credentials?.name ?? 'User',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColor.navyBlue,
                          ),
                        ),
                      if (credentials?.mobile != null &&
                          credentials!.mobile!.isNotEmpty)
                        Text(
                          credentials?.mobile ?? '+88018xxxxxxxx',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          actions: [
  Material(
    color: Colors.transparent, // Transparent background for ripple effect
    shape: const CircleBorder(), // Circular boundary for ripple
    child: InkWell(
      borderRadius: BorderRadius.circular(50), // Ensure circular splash
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
  ),
  const Gap(20),
]

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
                  'assets/Home_black.svg',
                  width: 18.0,
                  height: 18.0,
                ),
                activeIcon: SvgPicture.asset(
                  'assets/ic_home.svg',
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
      ),
    );
  }
}
