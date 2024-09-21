import 'dart:developer';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:kpathshala/api/api_container.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/model/dashboard_page_model/dashboard_page_model.dart';
import 'package:kpathshala/repository/dashboard_repository/dashboard_page_repository.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kpathshala/view/exam_main_page/ubt_exam_page.dart';
import 'package:kpathshala/view/home_main_page/dashboard_image_carousel.dart';
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
  log('Trying to launch URL: $url');
  if (await canLaunchUrl(url)) {
    log('Launching URL...');
    await launchUrl(url);
  } else {
    log('Failed to launch URL');
    throw 'Could not launch $url';
  }
}

class _DashboardPageState extends State<DashboardPage> {
  String apikey = "AIzaSyClsZlG68dO9BB9mF5XzxrdXvFcxehh9RA";
  String count = "0";
  String vidCount = "0";
  int _currentTimer = 1;
  bool dataFound = false;

  DashboardPageModel? dashboardPageModel;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    fetchData();
  }

  void fetchData() async {
    try {
      // Create an instance of QuestionSetRepository
      DashboardRepository repository = DashboardRepository();

      // Access fetchQuestionSets as an instance method
      DashboardPageModel? dashModel = await repository.fetchDashboardData();

      setState(() {
        dashboardPageModel = dashModel;
        log(jsonEncode(dashModel));
        dataFound = true;
      });
    } catch (e) {
      log(e.toString()); // Handle the exception
    }
  }

  void _checkCount() async {
    var url = Uri.parse(
      AuthorizationEndpoints.getYouTubeStats(
          'UCKeeBsW1hGy0NBCqKgd5oBw', apikey),
    );

    var response = await http.get(url);

    if (response.statusCode == 200 && mounted) {
      var data = json.decode(response.body);
      var subscriberCount = data['items'][0]['statistics']['subscriberCount'];
      var videoCount = data['items'][0]['statistics']['videoCount'];
      setState(() {
        count = subscriberCount;
        vidCount = videoCount;
      });
    } else {
      log("Failed to fetch subscriber count: ${response.statusCode}");
    }
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Exit App"),
            content: const Text("Are you sure you want to exit the app?"),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), // Stay in app
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // Exit app
                child: const Text("Yes"),
              ),
            ],
          ),
        ) ??
        false; // Return false if the dialog is dismissed without a response
  }

  void _startCountdown() {
    const interval = Duration(seconds: 1);

    if (mounted) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: dataFound == false
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (dashboardPageModel?.banners != null &&
                        dashboardPageModel!.banners!.isNotEmpty)
                      BannerCarousel(banners: dashboardPageModel!.banners!),
                    const SizedBox(height: 20),
                    GridView(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 2.5,
                      ),
                      children: [
                        if (dashboardPageModel?.videoClasses != null)
                          InkWell(
                            onTap: () {},
                            child: _buildGridItem(
                              icon: Icons.library_books,
                              title: "Classes",
                              subtitle:
                                  "${dashboardPageModel?.videoClasses ?? 0} videos",
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
                        // if (dashboardPageModel?.syllabus != null) // Example of another null check
                        InkWell(
                          onTap: () {},
                          child: _buildGridItem(
                            icon: Icons.book,
                            title: "Syllabus",
                            subtitle: "UBT exam syllabus",
                          ),
                        ),
                        // if (dashboardPageModel?.books != null) // Another example
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
                    if (dashboardPageModel?.exam != null)
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExamPage(
                                    packageId:
                                        dashboardPageModel!.exam!.packageId ??
                                            -1,
                                  ),
                                ),
                              );
                            },
                            child: _buildMockTestProgress(),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    buildYoutubeChannelStatisticsStack(),
                  ],
                ),
              ),
            ),
    );
  }

  Stack buildYoutubeChannelStatisticsStack() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        const SizedBox(height: 220),
        Container(
          height: 180,
          decoration: BoxDecoration(
            color: const Color(0xFFFF6F61),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          child: ClipRRect(
            child: Image.asset(
              'assets/profile.png',
              width: 220,
              height: 220,
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Subscribers and Videos Info
        Positioned(
          right: 14,
          top: 60,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.wifi_tethering,
                            color: Colors.white, size: 14),
                        customText(count, TextType.normal,
                            color: AppColor.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ],
                    ),
                    customText(
                      'Subscribers',
                      TextType.normal,
                      color: AppColor.skyBlue,
                      fontSize: 12,
                    ),
                  ],
                ),
                const Gap(8),
                Column(
                  children: [
                    customText(vidCount, TextType.normal,
                        color: AppColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                    const SizedBox(width: 10),
                    customText('Free videos', TextType.normal,
                        color: AppColor.skyBlue, fontSize: 12),
                  ],
                ),
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
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: _launchYouTubeChannel,
            icon: const Icon(Icons.play_circle_fill, color: Colors.white),
            label: customText('Free Korean lessons on YouTube', TextType.normal,
                color: AppColor.white, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildMockTestProgress() {
    double totalQuestionSet =
        (dashboardPageModel?.exam?.totalQuestionSet ?? 0).toDouble();
    double completedQuestionSet =
        (dashboardPageModel?.exam?.completedQuestionSet ?? 0).toDouble();

    // Avoid division by zero by checking if totalQuestionSet is greater than zero
    double ratio =
        (totalQuestionSet > 0) ? (completedQuestionSet / totalQuestionSet) : 0;

    // Check if there's a valid exam name to display
    String examName = dashboardPageModel?.exam?.examName ?? "";
    if (examName.isEmpty) {
      return const SizedBox.shrink(); // Return an empty widget if no exam name
    }

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            value: ratio,
            backgroundColor: Colors.grey[200],
            color: AppColor.navyBlue,
            strokeWidth: 4, // Adjust stroke width for better visual
          ),
          const SizedBox(width: 12), // Use SizedBox for consistent spacing
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  examName,
                  TextType.title,
                  fontSize: 14,
                  color: AppColor.neutralGrey,
                ),
                FittedBox(
                  child: customText(
                    (totalQuestionSet > 0)
                        ? "${completedQuestionSet.toInt()} out of ${totalQuestionSet.toInt()} sets completed"
                        : "No sets available",
                    TextType.normal,
                    fontSize: 10,
                    color: AppColor.navyBlue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.arrow_forward_ios,
              size: 16, color: AppColor.navyBlue),
        ],
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
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon(icon, color: AppColor.navyBlue),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: SvgPicture.asset(
            'assets/Icon.svg',
            width: 20.0,
            height: 20.0,
          ),
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                  child: FittedBox(
                      child: customText(title, TextType.title, fontSize: 14))),
              Flexible(
                child: FittedBox(
                  child: customText(subtitle, TextType.normal,
                      fontSize: 10, color: AppColor.black),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
