import 'dart:developer';
import 'dart:ui';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kpathshala/api/api_container.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/model/dashboard_page_model/dashboard_page_model.dart';
import 'package:kpathshala/repository/dashboard_repository/dashboard_page_repository.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kpathshala/view/exam_main_page/ubt_mock_test_page.dart';
import 'package:kpathshala/view/home_main_page/dashboard_image_carousel.dart';
import 'package:kpathshala/view/home_main_page/shimmer_effect_dashboard.dart';
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
  bool isConnectedToInternet = false;
  Timer? _timer;

  DashboardPageModel? dashboardPageModel;

  StreamSubscription? _internetConnectionStreamSubscription;

  @override
  void initState() {
    super.initState();
    // _internetConnectionStreamSubscription =
    //     InternetConnection().onStatusChange.listen((event) {
    //   print(event);
    //   switch (event) {
    //     case InternetStatus.connected:
    //       setState(() {
    //         isConnectedToInternet = true;
    //       });
    //       break;
    //     case InternetStatus.disconnected:
    //       setState(() {
    //         isConnectedToInternet = false;
    //         slideNavigationPush(ConnectionLost(), context);
    //       });
    //       break;
    //     default:
    //       setState(() {
    //         isConnectedToInternet = false;
    //       });
    //       break;
    //   }
    // });
    _startCountdown();
    fetchData();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _internetConnectionStreamSubscription?.cancel();
      _timer!.cancel();
    }
    _internetConnectionStreamSubscription?.cancel();
    super.dispose();
  }

  void fetchData() async {
    try {
      DashboardRepository repository = DashboardRepository();

      DashboardPageModel? dashModel =
          await repository.fetchDashboardData(context);

      setState(() {
        dashboardPageModel = dashModel;
        dataFound = true;
      });
    } catch (e) {
      log(e.toString());
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

  void _startCountdown() {
    const interval = Duration(seconds: 1);

    if (mounted) {
      _timer = Timer.periodic(interval, (Timer t) {
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
  //
  // void _showDisconnectionDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('No Internet Connection'),
  //         content:
  //             const Text('You are currently not connected to the internet.'),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('OK'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: dataFound == false
          ? const DashboardPageShimmerEffect()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // if (dashboardPageModel?.banners != null &&
                    //     dashboardPageModel!.banners!.isNotEmpty)
                    BannerCarousel(banners: dashboardPageModel?.banners ?? []),
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
                                  builder: (context) => UBTMockTestPage(
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
          right: 14,
          bottom: 0,
          child: Image.asset(
            'assets/image 1.png',
            width: 180,
            height: 180,
            fit: BoxFit.fitHeight,
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/DashboardImageOfYoutube.png',
              height: 250,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        Positioned(
          right: 14,
          top: 80,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 10, sigmaY: 10), // Apply blur to the container
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color:
                      Colors.grey.withOpacity(0.3), // Semi-transparent overlay
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: _launchYouTubeChannel,
                  borderRadius: BorderRadius.circular(
                      8), // For ripple effect to match button shape
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Gap(12),
                      const Icon(FontAwesomeIcons.youtube, color: Colors.white),
                      const Gap(8),
                      customText(
                        'Free Korean lessons on YouTube',
                        TextType.normal,
                        color: Colors.white, // Adjust color for visibility
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
