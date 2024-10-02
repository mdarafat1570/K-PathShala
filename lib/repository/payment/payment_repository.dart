import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:kpathshala/api/api_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentRepository {
  Future<Map<String, dynamic>> paymentPost({
    required int packageId,
    int? bookId,
    int? couponId,
    required String payReferenceNumber,
    required double totalAmount,
    required double grossTotal,
    double? discountAmount,
    double? vatAmount,
    required String paymentMethod,
  }) async {
    final url = Uri.parse(KpatshalaPaymentHistory.paymentPost);

    // Get the token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';

    if (token.isEmpty) {
      throw Exception('Authentication token is missing');
    }

    // Set up headers
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    // Create the body for the POST request
    final body = {
      "package_id": packageId,
      if (bookId != null) "book_id": bookId, // Conditionally add if not null
      if (couponId != null) "coupon_id": couponId, // Conditionally add if not null
      "pay_reference_number": payReferenceNumber,
      "total_amount": totalAmount,
      if (discountAmount != null) "discount_amount": discountAmount, // Conditionally add if not null
      if (vatAmount != null) "vat_amount": vatAmount, // Conditionally add if not null
      "gross_total": grossTotal,
      "payment_method": paymentMethod,
      "payment_status" : "successful",
    };

    // Send the POST request
    final response = await http.post(url, headers: headers, body: json.encode(body));

    // Check the status code and handle errors
    if (response.statusCode == 200) {
      // log(json.decode(response.body));
      return json.decode(response.body);
    } else {
      // Log more detailed error information if needed
      throw Exception('Failed to process payment. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  }
}
