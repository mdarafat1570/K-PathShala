import 'package:kpathshala/app_base/common_imports.dart';

import 'package:kpathshala/view/login/registration_And_Login_page.dart'; // Ensure this import is correct

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColor.gradientStart,
                      AppColor.gradient,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      "Ace the 2024 UBT Exam with K-Pathshala’s 100-Set Mock Test",
                      TextType.paragraphTitle,
                      color: AppColor.navyBlue,
                    ),
                    const Gap(5),
                    Row(
                      children: [
                        customText(
                          'For only ৳999.00',
                          TextType.normal,
                          color: AppColor.cancelled,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        customText(
                          '৳1,500',
                          TextType.normal,
                          color: AppColor.brightCoral,
                        ),
                      ],
                    ),
                    const Gap(25),
                    commonCustomButton(
                      width: 150,
                      backgroundColor: AppColor.brightCoral,
                      height: 50,
                      borderRadius: 12,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegistrationPage(
                              title: 'App',
                            ),
                          ),
                        );
                      },
                      reversePosition: true,
                      child: customText(
                        "View details",
                        TextType.normal,
                        color: AppColor.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GridView(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
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
              const Gap(10),
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: const Color(
                          0xFFFF6F61), // Background color similar to the image
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  Image.asset(
                    'assets/profile.png',
                    // width: 220,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                  // Subscribers and Videos Info
                  Positioned(
                    right: 14,
                    top: 80,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Gap(10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.wifi_tethering,
                                          color: Colors.white, size: 14),
                                      customText('27,600', TextType.normal,
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
                                  customText('411', TextType.normal,
                                      color: AppColor.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                  const Gap(5),
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
                          const Gap(5),
                        ],
                      ),
                    ),
                  ),
                  // Free Lessons Button
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
                      onPressed: () {},
                      icon: const Icon(Icons.play_circle_fill, color: Colors.white),
                      label: customText(
                          'Free Korean lessons on YouTube', TextType.normal,
                          color: AppColor.white, fontSize: 16),
                    ),
                  ),
                ],
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
          color: AppColor.skyBlue.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 5,
        ),
      ],
    ),
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Image.asset(typeOutlined),
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
