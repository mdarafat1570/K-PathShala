
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/model/PackageModel/package_model.dart';
import 'package:kpathshala/repository/package_service_repository.dart';
import 'package:kpathshala/view/courses_page/course_shimmer.dart';
import 'package:kpathshala/view/exam_main_page/bottom_panel_page_course_purchase.dart';
import 'package:lottie/lottie.dart';


class CoursePurchasePage extends StatefulWidget {
  const CoursePurchasePage({super.key});

  @override
  State<CoursePurchasePage> createState() => _CoursePurchasePageState();
}

class _CoursePurchasePageState extends State<CoursePurchasePage> {
  final PackageRepository _packageRepository = PackageRepository();
  Future<List<PackageModelList>>? _packagesFuture;
  // bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPackages();
  }

  void _fetchPackages() {
    _packagesFuture = _packageRepository
        .fetchPackages()
        .then((packageModel) => packageModel.data ?? []);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final heightPercentage = 490 / screenHeight;

    return Scaffold(
      body: GradientBackground(
        child: FutureBuilder<List<PackageModelList>>(
          future: _packagesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CourseShimmer());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final packages = snapshot.data!;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    customText("Mock tests and exams", TextType.paragraphTitle),
                    const Gap(20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: packages.length,
                      itemBuilder: (context, index) {
                        final package = packages[index];
                        return Container(
                          width: screenWidth > 360 ? 360 : screenWidth,
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: customText(
                                        package.title ?? "Course Title",
                                        TextType.title,
                                        fontSize: 14),
                                  ),
                                  const Gap(10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: package.status == true
                                          ? AppColor.lightred
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Lottie.asset(
                                          'assets/Animation_live.json',
                                          width: 25,
                                          height: 25,
                                        ),
                                        const Gap(3),
                                        Text(
                                          package.status == true
                                              ? 'Running'
                                              : 'Inactive',
                                          style: const TextStyle(
                                              color: Colors.red, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(16),
                              Row(
                                children: [
                                  customText("For only", TextType.normal,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                  const Gap(5),
                                  customText(
                                      "৳${package.price}", TextType.normal, fontSize: 12,
                                      color: AppColor.black,
                                      fontWeight: FontWeight.bold),
                                  const Gap(8),
                                  RichText(
                                    text: const TextSpan(
                                      style: TextStyle(
                                          color: AppColor.black,
                                          fontWeight: FontWeight.bold),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: ' ৳1,500.00',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            decorationThickness: 2.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(8),
                              customText(
                                package.subtitle ??
                                    "Crack UBT with ease with our mock tests and study guide.",
                                TextType.normal,
                                fontSize: 10
                              ),
                              const Gap(16),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  package.features != null
                                      ? package.features!
                                          .map((feature) => "• $feature")
                                          .join("\n")
                                      : "No features available",
                                  style: const TextStyle(
                                    fontSize: 10,
                                    height: 1.7,
                                  ),
                                ),
                              ),
                              const Gap(16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.sizeOf(context).width * 0.35,
                                    child: OutlinedButton(
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                        backgroundColor: const Color.fromRGBO(
                                            26, 35, 126, 0.15),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                      child: const Text('Preview'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.sizeOf(context).width * 0.35,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showCommonBottomSheet(
                                          context: context,
                                          height: screenHeight * heightPercentage,
                                          content:
                                              BottomSheetPage(context: context),
                                          actions: [],
                                          color: Colors.white,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                      child: const Text('Buy now'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('No packages available.'));
            }
          },
        ),
      ),
    );
  }
}
