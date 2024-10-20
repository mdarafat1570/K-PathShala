import 'dart:async';

import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/model/package_model/package_model.dart';
import 'package:kpathshala/repository/package_service_repository.dart';
import 'package:kpathshala/view/common_widget/format_date_with_ordinal.dart';
import 'package:kpathshala/view/exam_main_page/bottom_sheets/bottom_panel_page_course_purchase.dart';
import 'package:kpathshala/view/exam_main_page/ubt_mock_test_page.dart';
import 'package:shimmer/shimmer.dart';

class ExamPurchasePage extends StatefulWidget {
  const ExamPurchasePage({super.key});

  @override
  State<ExamPurchasePage> createState() => _ExamPurchasePageState();
}

class _ExamPurchasePageState extends State<ExamPurchasePage> {
  final PackageRepository _packageRepository = PackageRepository();
  Future<List<PackageList>>? _packagesFuture;
  bool isConnectedToInternet = false;

  StreamSubscription? _internetConnectionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _fetchPackages();
  }

  void _fetchPackages() {
    _packagesFuture = _packageRepository
        .fetchPackages(context)
        .then((packageModel) => packageModel.data ?? []);
  }

  @override
  void dispose() {
    super.dispose();
    _internetConnectionStreamSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final heightPercentage = 350 / screenHeight;

    return Scaffold(
      body: GradientBackground(
        child: FutureBuilder<List<PackageList>>(
          future: _packagesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return buildShimmerLoadingEffectExam();
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
                        return package.isUserAccess == true
                            ? Container(
                                width: screenWidth > 360 ? 360 : screenWidth,
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColor.examCardGradientStart,
                                        AppColor.examCardGradientEnd
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    border:
                                        Border.all(color: AppColor.skyBlue)),
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
                                      ],
                                    ),
                                    const Gap(5),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColor.brightCoral
                                            .withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        "Expiring in ${package.expiryIn} days",
                                        style: const TextStyle(
                                            color: AppColor.brightCoral,
                                            fontSize: 10),
                                      ),
                                    ),
                                    const Gap(5),
                                    Text(
                                      "${package.completedQuestionSet} out of ${package.totalQuestionSet} sets completed",
                                      style: const TextStyle(
                                          color: AppColor.naturalGrey,
                                          fontSize: 10),
                                    ),
                                    const Gap(8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.8,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UBTMockTestPage(
                                                          package: package,
                                                          packageId: package.id,
                                                          appBarTitle: package.title ?? "UBT Mock Test",
                                                        )),
                                              ).then((_) {
                                                _packagesFuture = null;
                                                _fetchPackages();
                                                setState(() {});
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                            ),
                                            child:
                                                const Text('Continue to Exam'),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            : Container(
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
                                        // const Gap(10),
                                        // Container(
                                        //   padding: const EdgeInsets.symmetric(
                                        //       horizontal: 12, vertical: 4),
                                        //   decoration: BoxDecoration(
                                        //     color: package.status == true
                                        //         ? AppColor.lightRed
                                        //         : Colors.grey,
                                        //     borderRadius: BorderRadius.circular(12),
                                        //   ),
                                        //   child: Row(
                                        //     children: [
                                        //       Lottie.asset(
                                        //         'assets/Animation_live.json',
                                        //         width: 25,
                                        //         height: 25,
                                        //       ),
                                        //       const Gap(3),
                                        //       Text(
                                        //         package.status == true
                                        //             ? 'Running'
                                        //             : 'Inactive',
                                        //         style: const TextStyle(
                                        //             color: Colors.red, fontSize: 12),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    const Gap(16),
                                    Row(
                                      children: [
                                        customText("For only", TextType.normal,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                        const Gap(5),
                                        customText("৳${package.price}",
                                            TextType.normal,
                                            fontSize: 12,
                                            color: AppColor.black,
                                            fontWeight: FontWeight.bold),
                                        const Gap(8),
                                        RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                                color: AppColor.black,
                                                fontWeight: FontWeight.bold),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    "৳${package.withDiscountPrice}",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough,
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
                                        package.subtitle ?? "", TextType.normal,
                                        fontSize: 10),
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
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.35,
                                          child: OutlinedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UBTMockTestPage(
                                                          package: package,
                                                          isInPreviewMode: true,
                                                          packageId: package.id,
                                                          appBarTitle: package.title ?? "UBT Mock Test",
                                                        )),
                                              ).then((_) {
                                                _packagesFuture = null;
                                                _fetchPackages();
                                                setState(() {});
                                              });
                                            },
                                            style: OutlinedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6),
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      26, 35, 126, 0.15),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                            ),
                                            child: const Text('Preview'),
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.35,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              DateTime futureDate =
                                                  DateTime.now().add(
                                                      const Duration(days: 5));
                                              final validityDate =
                                                  formatDateWithOrdinal(
                                                      futureDate);
                                              // final packagePrice = package
                                              //     .price; // Get price from the API
                                              showCommonBottomSheet(
                                                context: context,
                                                height: screenHeight *
                                                    heightPercentage,
                                                content: BottomSheetPage(
                                                  context: context,
                                                  packageId: package.id!,
                                                  packageName:
                                                      package.title ?? '',
                                                  price:10,
                                                      // packagePrice!.toDouble(),
                                                  validityDate:
                                                      validityDate.toString(),
                                                  refreshPage: () {
                                                    _packagesFuture = null;
                                                    _fetchPackages();
                                                    setState(() {});
                                                  },
                                                ),
                                                actions: [],
                                                color: Colors.white,
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
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

  Widget buildShimmerLoadingEffectExam() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          _buildShimmerContainer(
            height: 20,
            width: 60,
          ),
          const SizedBox(
            height: 20,
          ),
          _buildShimmerContainer(height: 140, width: 150),
          _buildShimmerContainer(height: 140, width: 150),
          _buildShimmerContainer(height: 340, width: 150),
        ],
      ),
    );
  }

  Widget _buildShimmerContainer({
    required double height,
    double? width,
  }) {
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
