
import 'dart:developer';

import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/model/log_in_credentials.dart';
import 'package:kpathshala/repository/authentication_repository.dart';
import 'package:kpathshala/view/common_widget/common_loading_indicator.dart';
import 'package:kpathshala/view/login_signup_age/registration_and_login_page.dart';
import 'package:kpathshala/view/payment_page/payment_history.dart';
import 'package:kpathshala/view/profile_page/profile_edit.dart';


class ProfileScreenInMainPage extends StatefulWidget {
  const ProfileScreenInMainPage({super.key});

  @override
  ProfileScreenInMainPageState createState() =>
      ProfileScreenInMainPageState();
}

class ProfileScreenInMainPageState extends State<ProfileScreenInMainPage> {
  LogInCredentials? credentials;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    readCredentials();
  }

  Future<void> readCredentials() async {
    credentials = await _authService.getLogInCredentials();

    if (credentials == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No credentials found")),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> imageProvider;

    if (credentials?.imagesAddress != null && credentials?.imagesAddress != "") {
      imageProvider = NetworkImage(credentials!.imagesAddress ?? '');
    }else {
      imageProvider = const AssetImage('assets/new_App_icon.png');
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(color: AppColor.navyBlue),
        ),
        backgroundColor: AppColor.gradientStart,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 50, backgroundImage: imageProvider),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        credentials?.name ?? 'User',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColor.navyBlue),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        credentials?.mobile ?? '+880 1867-712017',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Profile()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.blue,
                        ),
                        child: const Text('Edit Profile'),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                // height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        customText("__", TextType.subtitle,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColor.navyBlue),
                        customText('Courses taken', TextType.normal),
                      ],
                    ),
                    const Gap(10),
                    Column(
                      children: [
                        customText("2", TextType.subtitle,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColor.navyBlue),
                        const Text('Exams taken'),
                      ],
                    ),
                    const Gap(10),
                    Column(
                      children: [
                        customText("32 days", TextType.subtitle,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColor.navyBlue),
                        const Text('Member since'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.notifications,
                        color: AppColor.navyBlue,
                      ),
                      title: customText('Notifications', TextType.normal,
                          color: AppColor.navyBlue,
                          fontWeight: FontWeight.bold),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.history,
                        color: AppColor.navyBlue,
                      ),
                      title: customText('Purchase History', TextType.normal,
                          color: AppColor.navyBlue,
                          fontWeight: FontWeight.bold),
                      onTap: () {
                        slideNavigationPush(const PaymentHistory(), context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.link,
                        color: AppColor.navyBlue,
                      ),
                      title: customText('Connect Social Login', TextType.normal,
                          color: AppColor.navyBlue,
                          fontWeight: FontWeight.bold),
                      onTap: (){},
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: AppColor.navyBlue,
                      ),
                      title: customText('Log Out', TextType.normal,
                          color: AppColor.navyBlue,
                          fontWeight: FontWeight.bold),
                      onTap: () {
                        log("SignOut button pressed");
                        userSignOut();
                      },
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

  void userSignOut() async {
    log("calling");
    showLoadingIndicator(context: context, showLoader: true);
    try {
      final response = await _authService.logout(context);
      if (mounted) {
        showLoadingIndicator(context: context, showLoader: false);
        if (response['error'] == null || !response['error']) {
          slideNavigationPushAndRemoveUntil(const RegistrationPage(title: "Registration Page"), context);
        } else {
          log("Log In failed");
          throw Exception("${response["message"]}");
        }
      }
    } catch (e) {
      if (mounted) {
        showLoadingIndicator(context: context, showLoader: false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred: $e")),
        );
      }
    }
  }
}
