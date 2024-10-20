import 'dart:developer';

import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kpathshala/repository/payment/payment_repository.dart';
import 'package:kpathshala/view/exam_main_page/quiz_attempt_page/quiz_attempt_page_imports.dart';

class SSLCommerzPage extends StatefulWidget {
  final int packageId;
  const SSLCommerzPage({super.key,required this.packageId});

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
    formData['phone'] = "";
    formData['amount'] = 10.0;
    formData['multicard'] = '';
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
    String formattedDate = '${now.day.toString().padLeft(2, '0')}${now.month.toString().padLeft(2, '0')}${now.year.toString().substring(now.year.toString().length - 2)}''${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';

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

<<<<<<< HEAD
  Future<void> sslCommerzCustomizedCall() async {
    Sslcommerz sslcommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        //Use the ipn if you have valid one, or it will fail the transaction.
        ipn_url: "www.ipnurl.com",
        multi_card_name: formData['multicard'],
        currency: SSLCurrencyType.BDT,
        product_category: "Food",
        sdkType: _radioSelected == SdkType.TESTBOX
            ? SSLCSdkType.TESTBOX
            : SSLCSdkType.LIVE,
        store_id: formData['store_id'],
        store_passwd: formData['store_password'],
        total_amount: formData['amount'],
        tran_id: "1231321321321312",
      ),
    );

    sslcommerz
        .addEMITransactionInitializer(
            sslcemiTransactionInitializer: SSLCEMITransactionInitializer(
                emi_options: 1, emi_max_list_options: 9, emi_selected_inst: 0))
        .addShipmentInfoInitializer(
            sslcShipmentInfoInitializer: SSLCShipmentInfoInitializer(
                shipmentMethod: "yes",
                numOfItems: 5,
                shipmentDetails: ShipmentDetails(
                    shipAddress1: "Ship address 1",
                    shipCity: "Faridpur",
                    shipCountry: "Bangladesh",
                    shipName: "Ship name 1",
                    shipPostCode: "7860")))
        .addCustomerInfoInitializer(
          customerInfoInitializer: SSLCCustomerInfoInitializer(
            customerState: "Chattogram",
            customerName: "Abu Sayed Chowdhury",
            customerEmail: "abc@gmail.com",
            customerAddress1: "Anderkilla",
            customerCity: "Chattogram",
            customerPostCode: "200",
            customerCountry: "Bangladesh",
            customerPhone: formData['phone'],
          ),
        )
        .addProductInitializer(
            sslcProductInitializer:
                // ***** ssl product initializer for general product STARTS*****
                SSLCProductInitializer(
          productName: "Water Filter",
          productCategory: "Widgets",
          general: General(
            general: "General Purpose",
            productProfile: "Product Profile",
          ),
        )
            // ***** ssl product initializer for general product ENDS*****

            // ***** ssl product initializer for non physical goods STARTS *****
            // SSLCProductInitializer.WithNonPhysicalGoodsProfile(
            //     productName:
            //   "productName",
            //   productCategory:
            //   "productCategory",
            //   nonPhysicalGoods:
            //   NonPhysicalGoods(
            //      productProfile:
            //       "Product profile",
            //     nonPhysicalGoods:
            //     "non physical good"
            //       ))
            // ***** ssl product initializer for non physical goods ENDS *****

            // ***** ssl product initialization for travel vertices STARTS *****
            //       SSLCProductInitializer.WithTravelVerticalProfile(
            //          productName:
            //         "productName",
            //         productCategory:
            //         "productCategory",
            //         travelVertical:
            //         TravelVertical(
            //               productProfile: "productProfile",
            //               hotelName: "hotelName",
            //               lengthOfStay: "lengthOfStay",
            //               checkInTime: "checkInTime",
            //               hotelCity: "hotelCity"
            //             )
            //       )
            // ***** ssl product initialization for travel vertices ENDS *****

            // ***** ssl product initialization for physical goods STARTS *****

            // SSLCProductInitializer.WithPhysicalGoodsProfile(
            //     productName: "productName",
            //     productCategory: "productCategory",
            //     physicalGoods: PhysicalGoods(
            //         productProfile: "Product profile",
            //         physicalGoods: "non physical good"))

            // ***** ssl product initialization for physical goods ENDS *****

            // ***** ssl product initialization for telecom vertice STARTS *****
            // SSLCProductInitializer.WithTelecomVerticalProfile(
            //     productName: "productName",
            //     productCategory: "productCategory",
            //     telecomVertical: TelecomVertical(
            //         productProfile: "productProfile",
            //         productType: "productType",
            //         topUpNumber: "topUpNumber",
            //         countryTopUp: "countryTopUp"))
            // ***** ssl product initialization for telecom vertice ENDS *****
            )
        .addAdditionalInitializer(
          sslcAdditionalInitializer: SSLCAdditionalInitializer(
            valueA: "value a ",
            valueB: "value b",
            valueC: "value c",
            valueD: "value d",
            extras: {"key": "key", "key2": "key2"},
          ),
        );

    SSLCTransactionInfoModel result = await sslcommerz.payNow();
    paymentStatusCheck(result);
  }

  void paymentStatusCheck(SSLCTransactionInfoModel result) async {
    try {
      log("result status ::${result.status ?? ""}");

      if (result.status!.toLowerCase() == "failed") {
        Fluttertoast.showToast(
          msg: "Transaction failed. Please try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else if (result.status!.toLowerCase() == "closed") {
        Fluttertoast.showToast(
          msg: "Transaction canceled by the user.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
            msg:
                "Transaction is ${result.status} and Amount is ${result.amount ?? 0}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      debugPrint(e.toString());
=======
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
    }
    else if (result.status!.toLowerCase() == "closed") {
      Fluttertoast.showToast(
        msg: "Transaction canceled.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    else {
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
              msg: "Transaction ${result.status}. Amount: ${result.amount ?? 0} BDT",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0,
            );

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
>>>>>>> 2f5d96be17042b651dc92e65b0a98fab6c3516c7
    }
  }
}
<<<<<<< HEAD
=======
}
>>>>>>> 2f5d96be17042b651dc92e65b0a98fab6c3516c7
