import 'dart:developer';

import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kpathshala/main.dart';
import 'package:kpathshala/repository/payment/payment_repository.dart';
import 'package:kpathshala/view/exam_main_page/quiz_attempt_page/quiz_attempt_page_imports.dart';

class SSLCommerzPage extends StatefulWidget {
  final int packageId;
  final double price;
  final VoidCallback refreshPage;
  const SSLCommerzPage(
      {super.key,
      required this.packageId,
      required this.price,
      required this.refreshPage});

  @override
  SSLCommerzPageState createState() => SSLCommerzPageState();
}

class SSLCommerzPageState extends State<SSLCommerzPage> {
  LogInCredentials? credentials;
  final AuthService _authService = AuthService();

  String transactionID = 'KP+${DateTime.now().second}';

  dynamic formData = {};

  @override
  void initState() {
    super.initState();
    readCredentials();
    formData['store_id'] = "kpathshala0live";
    formData['store_password'] = "670CFD3A7D0E727025";
    formData['amount'] = widget.price;
    formData['multicard'] = '';
  }

  void _logScreenView() {
    MyApp.analytics.logEvent(name: 'Payment sandbox', parameters: {
      'screen_name': 'Payment sandbox',
    });
  }

  Future<void> readCredentials() async {
    credentials = await _authService.getLogInCredentials();

    if (credentials == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No credentials found")),
      );
    }
    transactionID = generateCode(credentials);
    log("---------------$transactionID--------------");
    setState(() {});
  }

  String generateCode(LogInCredentials? credentials) {
    final now = DateTime.now();
    String formattedDate =
        '${now.day.toString().padLeft(2, '0')}${now.month.toString().padLeft(2, '0')}${now.year.toString().substring(now.year.toString().length - 2)}'
        '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';

    return 'KP${(credentials?.name ?? '').substring(0, 2).toUpperCase()}${(credentials?.mobile ?? '').substring((credentials?.mobile?.length ?? 4) - 4)}$formattedDate';
  }

  @override
  Widget build(BuildContext context) {
    return commonCustomButton(
      width: double.infinity,
      backgroundColor: AppColor.navyBlue,
      height: 55,
      borderRadius: 30,
      onPressed: () {
        sslCommerzGeneralCall();
        // sslCommerzCustomizedCall();
      },
      reversePosition: false,
      child: const Text(
        "Proceed to payment",
        style: TextStyle(color: AppColor.white, fontSize: 20),
      ),
    );
  }

  Future<void> sslCommerzGeneralCall() async {
    Sslcommerz sslcommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        //Use the ipn if you have valid one, or it will fail the transaction.
        ipn_url: "k-pathshala",
        multi_card_name: formData['multicard'],
        currency: SSLCurrencyType.BDT,
        product_category: "Course",
        sdkType: SSLCSdkType.LIVE,
        store_id: formData['store_id'],
        store_passwd: formData['store_password'],
        total_amount: formData['amount'],
        tran_id: transactionID,
      ),
    );
    SSLCTransactionInfoModel result = await sslcommerz.payNow();
    log(jsonEncode(result));
    paymentStatusCheck(result);
  }

  void paymentStatusCheck(SSLCTransactionInfoModel result) async {
    try {
      log("Transaction status: ${result.status ?? ""}");

      if (result.status!.toLowerCase() == "failed") {
        Fluttertoast.showToast(
          msg: "Transaction failed. Please try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else if (result.status!.toLowerCase() == "closed") {
        Fluttertoast.showToast(
          msg: "Transaction canceled.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        try {
          // Show loading indicator
          showLoadingIndicator(context: context, showLoader: true);
          // Parse input data
          final int packageId = widget.packageId;
          final String payReferenceNumber = transactionID;
          final double totalAmount = formData['amount'];
          final double grossTotal = formData['amount'];
          const String paymentMethod = "SSL Commerz";

          // Make payment request
          final response = await PaymentRepository().paymentPost(
            packageId: packageId,
            payReferenceNumber: payReferenceNumber,
            totalAmount: totalAmount,
            grossTotal: grossTotal,
            paymentMethod: paymentMethod,
          );

          log(jsonEncode(response));

          if ((response['error'] == null || !response['error']) && mounted) {
            showLoadingIndicator(context: context, showLoader: false);

            Fluttertoast.showToast(
              msg:
                  "Transaction ${result.status}. Amount: ${result.amount ?? 0} BDT",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            widget.refreshPage();

            log("Payment successful.");
          } else {
            if (mounted) {
              showLoadingIndicator(context: context, showLoader: false);
              log("Payment failed: {response['message']}");
            }
          }
        } catch (e) {
          if (mounted) {
            showLoadingIndicator(context: context, showLoader: false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("An error occurred: $e")),
            );
            log("An error occurred: $e");
          }
        } finally {
          // Ensure the loading indicator is hidden
          if (mounted) {
            showLoadingIndicator(context: context, showLoader: false);
          }
        }
      }
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
      Fluttertoast.showToast(
        msg: "An error occurred. Please try again later.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
