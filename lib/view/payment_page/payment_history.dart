import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg package
import 'package:kpathshala/view/payment_page/payment_row.dart';
import 'package:shimmer/shimmer.dart';
import '../../app_theme/app_color.dart';
import '../../model/payment_model/payment_history_model.dart';
import '../../repository/payment/payment_history_repository.dart';
import '../common_widget/common_app_bar.dart';
import '../common_widget/custom_background.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({super.key});

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  late Future<PaymentHistoryModel> _paymentHistoryFuture;

  @override
  void initState() {
    super.initState();
    _paymentHistoryFuture =
        PaymentHistoryRepository().fetchPaymentHistory(context);
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        appBar: const CommonAppBar(
          title: 'Payment History',
          backgroundColor: AppColor.gradientStart,
          titleColor: AppColor.navyBlue,
          titleFontSize: 20,
        ),
        body: FutureBuilder<PaymentHistoryModel>(
          future: _paymentHistoryFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return isResultBuildShimmerLoadingEffect();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData ||
                snapshot.data!.data == null ||
                snapshot.data!.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/MobilePayment_Empty.svg', // Adjust the path as needed
                      width: 200, // Adjust size as needed
                      height: 200,
                    ),
                    const SizedBox(height: 20), // Space between image and text
                    const Text(
                      "No Payment History",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              );
            }

            final paymentHistory = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: paymentHistory.data!.length,
                itemBuilder: (context, index) {
                  final reversedPaymentList =
                      paymentHistory.data!.reversed.toList();
                  final payment = reversedPaymentList[index];
                  final title = payment.packageName ?? 'No Package Name';
                  final amount =
                      payment.paymentAmount?.toStringAsFixed(2) ?? 'No Amount';
                  final date = payment.paymentDate ?? 'Unknown Date';
                  const imageUrl =
                      'https://freelogopng.com/images/all_img/1656235223bkash-logo.png';

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: PaymentRow(
                        title: title,
                        amount: amount,
                        date: date,
                        imageUrl: imageUrl,
                        onTap: () {},
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget isResultBuildShimmerLoadingEffect() {
    return Expanded(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 10,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ),
              elevation: 2, // Adds a slight shadow for the card
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 5.0), // Adds spacing between items
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 40.0,
                          backgroundColor: Colors.black12,
                        ),
                        Column(
                          children: [
                            Container(
                              height: 12,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
