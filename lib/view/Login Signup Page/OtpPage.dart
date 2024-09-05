import 'package:flutter/material.dart';
import 'package:kpathshala/app_base/common_imports.dart';
import 'package:kpathshala/repository/authentication_repository.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final AuthService _authService = AuthService(); // Instantiate AuthService
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isOtpSent = false;
  bool _isOtpVerified = false;

  void _sendOtp() async {
    String mobile = _mobileController.text.trim();
    if (mobile.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your mobile number.")),
      );
      return;
    }

    final response = await _authService.sendOtp(mobile);
    if (response['error'] == null || !response['error']) {
      setState(() {
        _isOtpSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP sent to $mobile.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send OTP: ${response['message']}")),
      );
    }
  }

  void _verifyOtp() async {
    String mobile = _mobileController.text.trim();
    int otp = int.tryParse(_otpController.text.trim()) ?? 0;

    final response =
        await _authService.verifyOtp(mobile, otp, "unique-device-id");
    if (response['error'] == null || !response['error']) {
      setState(() {
        _isOtpVerified = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP verified successfully.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to verify OTP: ${response['message']}")),
      );
    }
  }

  void _registerUser() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String mobile = _mobileController.text.trim();

    final response =
        await _authService.registerUser(name: name, email: email, mobile: mobile, deviceId: "");
    if (response['error'] == null || !response['error']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration successful.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration failed: ${response['message']}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text('K_Pathsala Auth'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _mobileController,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16.0),
              if (_isOtpSent) ...[
                TextField(
                  controller: _otpController,
                  decoration: InputDecoration(
                    labelText: 'Enter OTP',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _verifyOtp,
                  child: Text('Verify OTP'),
                ),
              ] else
                ElevatedButton(
                  onPressed: _sendOtp,
                  child: Text('Send OTP'),
                ),
              SizedBox(height: 16.0),
              if (_isOtpVerified) ...[
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _registerUser,
                  child: Text('Register'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
