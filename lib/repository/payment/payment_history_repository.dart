import 'package:flutter/material.dart';
import 'package:kpathshala/api/api_container.dart';
import 'package:kpathshala/authentication/base_repository.dart';
import '../../model/payment_model/payment_history_model.dart'; // Contains AuthorizationEndpoints

class PaymentHistoryRepository {
  final BaseRepository _baseRepository = BaseRepository();
  Future<PaymentHistoryModel> fetchPaymentHistory(BuildContext context) async {
    try {
      final response = await _baseRepository
          .getRequest(KpatshalaPaymentHistory.paymentHistory, context: context);
      return PaymentHistoryModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to retrieve payment history: $e');
    }
  }
}
