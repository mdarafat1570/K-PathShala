import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kpathshala/api/api_container.dart';

import '../../model/payment_model/payment_history_model.dart'; // Contains AuthorizationEndpoints

class PaymentHistoryRepository {
  static const String _tokenKey = 'authToken';

  // Fetch payment history
  Future<PaymentHistoryModel> fetchPaymentHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);

    if (token == null) {
      throw Exception('No authentication token found.');
    }

    final url = Uri.parse(KpatshalaPaymentHistory.paymentHistory);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return PaymentHistoryModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to retrieve payment history.');
    }
  }
}
