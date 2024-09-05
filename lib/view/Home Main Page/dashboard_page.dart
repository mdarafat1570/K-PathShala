import 'package:kpathshala/api/api_container.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/view/common_widget/common_card_book_slider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kpathshala/app_theme/app_color.dart';
// import 'package:kpathshala/view/login/registration_and_login_page.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

//For navigate to Youtube Chanel
Future<void> _launchYouTubeChannel() async {
  //Convert the URL string to a Uri object
  final Uri url =
      Uri.parse('https://www.youtube.com/channel/UCKeeBsW1hGy0NBCqKgd5oBw');
  print('Trying to launch URL: $url');
  if (await canLaunchUrl(url)) {
    print('Launching URL...');
    await launchUrl(url);
  } else {
    print('Failed to launch URL');
    throw 'Could not launch $url';
  }
}

class _DashboardPageState extends State<DashboardPage> {
  String _apikey = "AIzaSyClsZlG68dO9BB9mF5XzxrdXvFcxehh9RA";
  String count = "0";
  String vidCount = "0";
  int _currentTimer = 1;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _checkCount() async {
    var url = Uri.parse(
      AuthorizationEndpoints.getYouTubeStats(
          'UCKeeBsW1hGy0NBCqKgd5oBw', _apikey),
    );

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var subscriberCount = data['items'][0]['statistics']['subscriberCount'];
      var videoCount = data['items'][0]['statistics']['videoCount'];
      setState(() {
        count = subscriberCount;
        vidCount = videoCount;
      });
    } else {
      print("Failed to fetch subscriber count: ${response.statusCode}");
    }
  }

  void _startCountdown() {
    const interval = Duration(seconds: 1);

    Timer.periodic(interval, (Timer t) {
      setState(() {
        if (_currentTimer > 0) {
          _currentTimer -= 1;
        } else {
          _currentTimer = 1;
          _checkCount();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          children: [
                            BookDeshbordbuildCard(),
                            BookDeshbordbuildCard(),
                            BookDeshbordbuildCard(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: 3,
                        effect: const WormEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          activeDotColor: Colors.blue,
                          dotColor: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GridView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 2.5,
                ),
                children: [
                  InkWell(
                    onTap: () {},
                    child: _buildGridItem(
                      icon: Icons.library_books,
                      title: "Classes",
                      subtitle: "200+ videos",
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: _buildGridItem(
                      icon: Icons.assessment,
                      title: "Skill test",
                      subtitle: "Test your skills",
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: _buildGridItem(
                      icon: Icons.book,
                      title: "Syllabus",
                      subtitle: "UBT exam syllabus",
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: _buildGridItem(
                      icon: Icons.library_books,
                      title: "Books",
                      subtitle: "Order or read",
                    ),
                  ),
                ],
              ),
              const Gap(10),
              _buildMockTestProgress(),
              SizedBox(height: 10),
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6F61),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 2,
                      child: ClipRRect(
                        child: Image.asset(
                          'assets/profile.png',
                          width: 180,
                          height: 180,
                          // fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Subscribers and Videos Info
                    Positioned(
                      right: 14,
                      top: 30,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                customGap(height: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.wifi_tethering,
                                            color: Colors.white, size: 14),
                                        customText('$count', TextType.normal,
                                            color: AppColor.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ],
                                    ),
                                    customGap(height: 5),
                                    customText('Subscribers', TextType.normal,
                                        color: AppColor.skyBlue, fontSize: 12),
                                  ],
                                ),
                                customGap(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customText('$vidCount', TextType.normal,
                                        color: AppColor.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                    customGap(height: 5),
                                    Row(
                                      children: [
                                        customText(
                                            'Free videos', TextType.normal,
                                            color: AppColor.skyBlue,
                                            fontSize: 12),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 16,
                      right: 16,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _launchYouTubeChannel,
                        icon: Icon(Icons.play_circle_fill, color: Colors.white),
                        label: customText(
                            'Free Korean lessons on YouTube', TextType.normal,
                            color: AppColor.white, fontSize: 16),
                      ),
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

Widget _buildGridItem(
    {required IconData icon, required String title, required String subtitle}) {
  return Container(
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
      children: [
        Icon(icon, color: AppColor.accentColor),
        const Gap(12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText(title, TextType.title, fontSize: 16),
            Expanded(
              child: customText(subtitle, TextType.normal,
                  fontSize: 10, color: AppColor.black),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildMockTestProgress() {
  return Container(
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
      children: [
        CircularProgressIndicator(
          value: 0.1,
          backgroundColor: Colors.grey[200],
          color: AppColor.accentColor,
        ),
        const Gap(12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText("UBT Mock Test", TextType.title, fontSize: 16),
            customText("10 out of 100 sets completed", TextType.normal,
                fontSize: 14),
          ],
        ),
        const Spacer(),
        const Icon(Icons.arrow_forward_ios, size: 16, color: AppColor.active),
      ],
    ),
  );
}
