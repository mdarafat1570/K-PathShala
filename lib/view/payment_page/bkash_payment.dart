import 'dart:convert';

import 'package:kpathshala/app_base/common_imports.dart';
import 'package:http/http.dart' as http;

class BkashPayment extends StatefulWidget {
  @override
  _BkashPaymentState createState() => _BkashPaymentState();
}

class _BkashPaymentState extends State<BkashPayment> {
  final _formKey = GlobalKey<FormState>();
  String _paymentID = '';
  bool _isLoading = false;
  String _errorMessage = '';

  // Step 1: Get authentication token from bKash
  Future<void> getAuthToken() async {
    try {
      final response = await http.post(
        Uri.parse('https://checkout.sandbox.bka.sh/v1.2.0-beta/checkout/token/grant'),
        headers: {
          'Content-Type': 'application/json',
          'username': 'your_username',
          'password': 'your_password',
        },
        body: jsonEncode({
          'app_key': 'your_app_key',
          'app_secret': 'your_app_secret',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Auth Token: ${data['id_token']}');
        return data['id_token'];
      } else {
        throw Exception('Failed to get auth token: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting auth token: $e');
    }
  }

  // Step 2: Create a payment
  Future<void> createPayment(String token) async {
    try {
      final response = await http.post(
        Uri.parse('https://checkout.sandbox.bka.sh/v1.2.0-beta/checkout/payment/create'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': token,
          'x-app-key': 'your_app_key',
        },
        body: jsonEncode({
          'amount': '100', // Replace with desired amount
          'currency': 'BDT',
          'intent': 'sale',
          'merchantInvoiceNumber': 'inv1234', // Replace with your invoice number
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Payment Created: ${data['paymentID']}');
        setState(() {
          _paymentID = data['paymentID'];
        });
      } else {
        throw Exception('Failed to create payment: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating payment: $e');
    }
  }
  

  // Step 3: Execute the payment
  Future<void> executePayment(String token) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://checkout.sandbox.bka.sh/v1.2.0-beta/checkout/payment/execute/$_paymentID'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': token,
          'x-app-key': 'your_app_key',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Payment Executed: ${data['transactionStatus']}');
        // Handle successful payment here (e.g., show success message)
      } else {
        throw Exception('Failed to execute payment: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error executing payment: $e');
    }
  }

  Future<void> startBkashPayment() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final token = await getAuthToken();
      // await createPayment(token);
      // await executePayment(token);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('bKash Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the amount';
                  }
                  return null;
                },
                onChanged: (value) {
                  // Update the amount in the createPayment function if needed
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isLoading ? null : startBkashPayment,
                child: Text(_isLoading ? 'Processing...' : 'Pay with bKash'),
              ),
              SizedBox(height: 16.0),
              if (_errorMessage.isNotEmpty) Text(_errorMessage, style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}