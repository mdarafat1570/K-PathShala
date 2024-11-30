import 'dart:convert';
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
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';

    if (token.isEmpty) {
      throw Exception('Authentication token is missing');
    }
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = {
      "package_id": packageId,
      if (bookId != null) "book_id": bookId,
      if (couponId != null) "coupon_id": couponId,
      "pay_reference_number": payReferenceNumber,
      "total_amount": totalAmount,
      if (discountAmount != null) "discount_amount": discountAmount,
      if (vatAmount != null) "vat_amount": vatAmount,
      "gross_total": grossTotal,
      "payment_method": paymentMethod,
      "payment_status": "successful",
    };

    final response =
        await http.post(url, headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to process payment. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  }
}
