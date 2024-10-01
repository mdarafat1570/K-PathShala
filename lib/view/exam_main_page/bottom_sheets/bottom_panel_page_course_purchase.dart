import 'package:flutter_svg/svg.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/view/exam_main_page/widgets/payment_example.dart';

class BottomSheetPage extends StatefulWidget {
  final BuildContext context;
  final int packageId;
  final String packageName;
  final double price;
  final String validityDate;
  final VoidCallback refreshPage;

  const BottomSheetPage({
    super.key,
    required this.packageId,
    required this.packageName,
    required this.context,
    required this.price,
    required this.validityDate,
    required this.refreshPage,
  });

  @override
  State<BottomSheetPage> createState() => _BottomSheetPageState();
}

class _BottomSheetPageState extends State<BottomSheetPage> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Container(
          width: screenWidth * 0.2,
          height: 3, // Adjust the height (thickness) as needed
          decoration: BoxDecoration(
            color: AppColor.notBillable,
            borderRadius: BorderRadius.circular(8), // Circular edges
          ),
        ),
        Gap(screenHeight * 0.03),
        customText("Confirm purchase", TextType.paragraphTitle,
            color: AppColor.naturalGrey, fontSize: 24),
        Gap(screenHeight * 0.03),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            border: Border.all(width: 0.2, color: Colors.black),
            color: const Color.fromRGBO(245, 245, 245, 1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText("Payment of ৳${widget.price.toStringAsFixed(2)}",
                    TextType.subtitle,
                    fontSize: 14,
                    color: AppColor.navyBlue,
                    fontWeight: FontWeight.bold),
                const Gap(5),
                RichText(
                  text: TextSpan(
                    text: "You’ll have access to ${widget.packageName} ",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    children: [
                      TextSpan(
                        text: widget.validityDate,
                        style: const TextStyle(
                          color: AppColor.navyBlue,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const Gap(30),
        commonCustomButton(
          width: double.infinity,
          backgroundColor: AppColor.navyBlue,
          height: 55,
          borderRadius: 30,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyForm(
                        packageId: widget.packageId.toString(),
                        total: widget.price.toString(),
                      )),
            ).then((_) {
              widget.refreshPage();
              Navigator.pop(context);
            });
            // showPaymentDialog();
          },
          reversePosition: false,
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/BKashwine.svg',
                width: 40,
                height: 40,
              ),
              const Gap(10),
              const Text(
                "Pay With Bkash",
                style: TextStyle(color: AppColor.white, fontSize: 20),
              ),
            ],
          ),
        ),
        // const SSLCommerzPage(),
        Gap(screenHeight * 0.03),
        SizedBox(
          width: double.infinity,
          child: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              text:
                  "By proceeding you’re agreeing with K-Pathshala’s purchasing ",
              style: TextStyle(
                color: AppColor.grey500,
                fontSize: 10,
              ),
              children: [
                TextSpan(
                  text: "and refund policy.",
                  style: TextStyle(
                    color: AppColor.grey500,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Gap(15),
        // Image.asset('assets/pixelcut-export.png', fit: BoxFit.cover),
      ],
    );
  }

  Future<void> showPaymentDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('This is a typical dialog.'),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
