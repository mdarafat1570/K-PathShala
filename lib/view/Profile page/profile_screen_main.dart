import 'package:flutter/material.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/view/Profile%20page/profile_edit.dart';
import 'package:kpathshala/view/common_widget/custom_text.dart.dart';

class ProfileScreenInMainPage extends StatefulWidget {
  @override
  _ProfileScreenInMainPageState createState() =>
      _ProfileScreenInMainPageState();
}

class _ProfileScreenInMainPageState extends State<ProfileScreenInMainPage> {
  @override
  Widget build(BuildContext context) {
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
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://example.com/your-profile-image-url.jpg',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Shihab Shaharia',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColor.navyBlue),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        '+880 1867-712017',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Profile()),
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
                height: 80,
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
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.link,
                        color: AppColor.navyBlue,
                      ),
                      title: customText('Connect Social Login', TextType.normal,
                          color: AppColor.navyBlue,
                          fontWeight: FontWeight.bold),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: AppColor.navyBlue,
                      ),
                      title: customText('Log Out', TextType.normal,
                          color: AppColor.navyBlue,
                          fontWeight: FontWeight.bold),
                      onTap: () {},
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
}
