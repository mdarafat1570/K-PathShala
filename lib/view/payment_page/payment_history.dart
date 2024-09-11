import 'package:flutter/material.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/model/payment_history_item_list.dart';
import 'package:kpathshala/view/Payment%20Page/payment_row.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({super.key});

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  @override
  Widget build(BuildContext context) {
    final paymentData = paymentlist();

    return GradientBackground(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Payment History"),
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: paymentData.length,
            itemBuilder: (context, index) {
              final payment = paymentData[index];
              final title = payment['title'] ?? 'No Title';
              final amount = payment['amount'] ?? 'No Amount';
              final date = payment['date'] ?? 'Unknown Date';
              final imageUrl = payment['imageUrl'] ?? 'https://via.placeholder.com/150';

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
                    imageUrl: imageUrl,  // Pass the image URL to the PaymentRow
                    onTap: () {},
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

