import 'dart:convert';
import 'dart:developer';

import 'package:kpathshala/repository/payment/payment_repository.dart';
import 'package:kpathshala/view/common_widget/common_loading_indicator.dart';

import '../../../app_base/common_imports.dart';

class MyForm extends StatefulWidget {
  final String packageId;
  final String total;

  const MyForm({super.key, required this.packageId, required this.total});

  @override
  MyFormState createState() => MyFormState();
}

class MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _field1Controller = TextEditingController();
  final TextEditingController _field2Controller =
      TextEditingController(text: DateTime.now().toIso8601String());
  final TextEditingController _field3Controller = TextEditingController();
  final TextEditingController _field4Controller = TextEditingController();
  final TextEditingController _field5Controller =
      TextEditingController(text: "card");

  @override
  void initState() {
    super.initState();
    _field1Controller.text = widget.packageId;
    _field3Controller.text = widget.total;
    _field4Controller.text = widget.total;
  }

  @override
  void dispose() {
    _field1Controller.dispose();
    _field2Controller.dispose();
    _field3Controller.dispose();
    _field4Controller.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _packagePayment();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Flutter Form Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                enabled: false,
                controller: _field1Controller,
                decoration: const InputDecoration(labelText: 'Package Id'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter package id';
                  }
                  return null;
                },
              ),
              const Gap(10),
              TextFormField(
                enabled: false,
                controller: _field2Controller,
                decoration: const InputDecoration(
                    labelText: 'Payment Reference Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter payment reference number';
                  }
                  return null;
                },
              ),
              const Gap(10),
              TextFormField(
                enabled: false,
                controller: _field3Controller,
                decoration: const InputDecoration(labelText: 'Total Amount'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Amount';
                  }
                  return null;
                },
              ),
              const Gap(10),
              TextFormField(
                enabled: false,
                controller: _field4Controller,
                decoration: const InputDecoration(labelText: 'Gross Total'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter gross total';
                  }
                  return null;
                },
              ),
              const Gap(10),
              TextFormField(
                enabled: false,
                controller: _field5Controller,
                decoration: const InputDecoration(labelText: 'Payment Method'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter payment Method';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _packagePayment() async {
    // Dismiss the keyboard to improve UX
    FocusScope.of(context).unfocus();

    // Input validation (add more checks if needed)
    if (_field1Controller.text.isEmpty ||
        _field2Controller.text.isEmpty ||
        _field3Controller.text.isEmpty ||
        _field4Controller.text.isEmpty ||
        _field5Controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    try {
      // Show loading indicator
      showLoadingIndicator(context: context, showLoader: true);

      // Parse input data
      final int packageId = int.parse(_field1Controller.text);
      final String payReferenceNumber = _field2Controller.text;
      final double totalAmount = double.parse(_field3Controller.text);
      final double grossTotal = double.parse(_field4Controller.text);
      final String paymentMethod = _field5Controller.text;

      // Make payment request
      final response = await PaymentRepository().paymentPost(
        packageId: packageId,
        payReferenceNumber: payReferenceNumber,
        totalAmount: totalAmount,
        grossTotal: grossTotal,
        paymentMethod: paymentMethod,
      );

      log(jsonEncode(response));

      // Process the response
      if ((response['error'] == null || !response['error']) && mounted) {
        // Hide loading indicator
        showLoadingIndicator(context: context, showLoader: false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment successful.")),
        );

        log("Payment successful.");
        // Optionally store token or any other data
        // final prefs = await SharedPreferences.getInstance();
        // prefs.setString('paymentToken', response['payment_token'] ?? '');

        // Perform any other success actions
      } else {
        if (mounted) {
          showLoadingIndicator(context: context, showLoader: false);
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text("Payment failed: ${response['message']}")),
          // );
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
}
