import 'dart:async';
import 'dart:developer';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/model/log_in_credentials.dart';
import 'package:kpathshala/model/profile_model/profile_get_data_model.dart';
import 'package:kpathshala/repository/authentication_repository.dart';
import 'package:kpathshala/repository/payment/profile_get_data_repository.dart';

import 'package:kpathshala/view/common_widget/common_loading_indicator.dart';
import 'package:kpathshala/view/login_signup_page/registration_and_login_page.dart';
import 'package:kpathshala/view/notifications/notifications_page.dart';
import 'package:kpathshala/view/payment_page/payment_history.dart';
import 'package:kpathshala/view/profile_page/connect_social_page.dart';
import 'package:kpathshala/view/profile_page/profile_edit.dart';

import '../common_widget/common_app_bar.dart';

class ProfileScreenInMainPage extends StatefulWidget {
  const ProfileScreenInMainPage({super.key});

  @override
  ProfileScreenInMainPageState createState() => ProfileScreenInMainPageState();
}

class ProfileScreenInMainPageState extends State<ProfileScreenInMainPage> {
  LogInCredentials? credentials;
  ProfileGetDataModel? profileData;
  bool isLoadingProfile = true;
  final AuthService _authService = AuthService();
  final ProfileRepository _profileRepository = ProfileRepository();
  bool isConnectedToInternet = false;
  StreamSubscription? _internetConnectionStreamSubscription;

  @override
  void initState() {
    super.initState();
    readCredentials();
    fetchProfileData();
  }

  Future<void> readCredentials() async {
    credentials = await _authService.getLogInCredentials();

    if (credentials == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No credentials found")),
      );
    }
    setState(() {});
  }

  Future<void> fetchProfileData() async {
    try {
      setState(() {
        isLoadingProfile = true;
      });

      ProfileGetDataModel? data =
          await _profileRepository.fetchProfile(context);

      if (data != null) {
        setState(() {
          profileData = data;
          isLoadingProfile = false;
        });
      } else {
        setState(() {
          isLoadingProfile = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to fetch profile data")),
          );
        }
      }
    } catch (e) {
      // Handle exceptions
      setState(() {
        isLoadingProfile = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred: $e")),
        );
      }
    }
  }

  @override
  void dispose() {
    _internetConnectionStreamSubscription?.cancel();
    super.dispose();
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

    return Scaffold(
      appBar: const CommonAppBar(
        title: 'My Profile',
        backgroundColor: AppColor.gradientStart,
        titleColor: AppColor.navyBlue,
        titleFontSize: 20,
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 40, backgroundImage: imageProvider),
                  const Gap(16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (credentials?.name != null &&
                          credentials!.name!.isNotEmpty)
                        Text(
                          credentials?.name ?? 'User',
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColor.navyBlue),
                        ),
                      if (credentials?.mobile != null &&
                          credentials!.mobile!.isNotEmpty)
                        const Gap(3),
                      if (credentials?.mobile != null &&
                          credentials!.mobile!.isNotEmpty)
                        Text(
                          credentials?.mobile ?? '+88018xxxxxxxx',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      // const Gap(3),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Profile(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.blue,
                          minimumSize:
                              const Size(80, 28), // Standard button size
                          padding: const EdgeInsets.all(10),
                        ),
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 13, // Adjusted for standard button size
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Profile Data Section
              Container(
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
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FittedBox(
                      child: Column(
                        children: [
                          customText(
                            profileData?.courseTaken?.toString() ?? "__",
                            TextType.subtitle,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColor.navyBlue,
                          ),
                          customText(
                              'Courses taken', fontSize: 10, TextType.normal),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 1,
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    FittedBox(
                      child: Column(
                        children: [
                          customText(
                            profileData?.examTaken?.toString() ?? "__",
                            TextType.subtitle,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColor.navyBlue,
                          ),
                          customText(
                              'Exams taken', fontSize: 10, TextType.normal),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 1,
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    FittedBox(
                      child: Column(
                        children: [
                          customText(
                            profileData?.memberSince == 0
                                ? "Today"
                                : "${profileData?.memberSince?.toString() ?? "__"} days",
                            TextType.subtitle,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColor.navyBlue,
                          ),
                          customText(
                              'Member since', fontSize: 10, TextType.normal),
                        ],
                      ),
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
                      onTap: () {
                        slideNavigationPush(const NotificationsPage(), context);
                      },
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
                      onTap: () {
                        // slideNavigationPush(const SocialLoginPage(), context);
                      },
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
          slideNavigationPushAndRemoveUntil(
              const RegistrationPage(title: "Registration Page"), context);
        } else {
          log("Log In failed");
          throw Exception("${response["message"]}");
        }
      }
    } catch (e) {
      if (mounted) {
        showLoadingIndicator(context: context, showLoader: false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred during sign out: $e")),
        );
      }
    }
  }
}
