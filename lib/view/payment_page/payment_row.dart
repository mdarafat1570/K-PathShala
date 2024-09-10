import 'package:flutter/material.dart';
import 'package:kpathshala/app_base/common_imports.dart';

class PaymentRow extends StatelessWidget {
  final String title;
  final String amount;
  final String date;
  final VoidCallback onTap;

  const PaymentRow({
    required this.title,
    required this.amount,
    required this.date,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: MediaQuery.of(context).size.width *
              0.05, // Responsive horizontal padding
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align items to the start
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/Profile.jpg'),
              radius: 24, // Use a consistent radius
            ),
            const SizedBox(width: 8), // Add space between avatar and text
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align text to start
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: FittedBox(
                          child: customText(title, TextType.paragraphTitle,
                              fontSize: 14),
                        ),
                      ),
                      const Gap(12),
                      Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.2,
                            maxHeight: MediaQuery.of(context).size.height *
                                0.030 // Responsive maximum width
                            ),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              12), // Slightly smaller border radius
                          color: AppColor.navyBlue,
                        ),
                        child: Center(
                          child: FittedBox(
                            child: Text(
                              "Successful",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.width *
                                    0.05, // Responsive font size
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2), // Add space between title and amount
                  FittedBox(
                    child: customText(
                      amount,
                      TextType.paragraphTitlenormal,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 2), // Add space between amount and date
                  FittedBox(
                    child: customText(date, TextType.normal, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
