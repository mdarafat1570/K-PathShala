import 'dart:io';

import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:kpathshala/base/base_repository.dart';

import '../../api/api_contaner.dart';
import '../../api/json_response.dart';

class OtpPageV1 extends StatefulWidget {
  @override
  _OtpPageV1State createState() => _OtpPageV1State();
}

class _OtpPageV1State extends State<OtpPageV1> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final BaseRepository _repository =
      BaseRepository(); // Assuming BaseRepositoryImpl is implemented

  bool _isSendingOtp = false;
  bool _isVerifyingOtp = false;

  Future<String?> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? deviceId;

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id; // Unique ID on Android
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor; // Unique ID on iOS
      }
    } catch (e) {
      print('Error fetching device ID: $e');
    }

    return deviceId;
  }

  Future<void> sendOtp() async {
    String mobileNumber = _mobileController.text.trim();
    String email =
        "user@example.com"; // Replace with the actual email if needed

    if (mobileNumber.isNotEmpty) {
      setState(() {
        _isSendingOtp = true;
      });

      String? deviceId = await getDeviceId();
      final data = {
        'mobile': mobileNumber,
        'email': email,
        'device_id': deviceId ?? '',
      };

      try {
        final response = await _repository.fetchData(
          AuthorizationEndpoints.sendOTP(mobileNumber),
          data,
          (response) => JsonResponse.fromJson(response),
          isPost: true,
        );

        // Handle response
        if (response.isSucceeded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('OTP sent successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send OTP')),
          );
        }
      } catch (e) {
        print('Error sending OTP: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending OTP')),
        );
      } finally {
        setState(() {
          _isSendingOtp = false;
        });
      }
    }
  }

  Future<void> verifyOtp() async {
    String mobileNumber = _mobileController.text.trim();
    String otp = _otpController.text.trim();
    String deviceId = await getDeviceId() ?? '';

    if (mobileNumber.isNotEmpty && otp.isNotEmpty) {
      setState(() {
        _isVerifyingOtp = true;
      });

      final data = {
        'mobile': mobileNumber,
        'otp': otp,
        'device_id': deviceId,
        'device_name': 'android', // Replace with 'ios' if on iOS
      };

      try {
        final response = await _repository.fetchData(
          AuthorizationEndpoints.verifyOTP,
          data,
          (response) => JsonResponse.fromJson(response),
          isPost: true,
        );

        // Handle response
        if (response.isSucceeded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('OTP verified successfully')),
          );
          // Optionally, navigate to another screen or perform further actions
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to verify OTP')),
          );
        }
      } catch (e) {
        print('Error verifying OTP: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error verifying OTP')),
        );
      } finally {
        setState(() {
          _isVerifyingOtp = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('OTP Authentication'),
      ),
      body: Padding(
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
            SizedBox(height: 16),
            TextField(
              controller: _otpController,
              decoration: InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSendingOtp ? null : sendOtp,
              child: _isSendingOtp
                  ? CircularProgressIndicator()
                  : Text('Send OTP'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isVerifyingOtp ? null : verifyOtp,
              child: _isVerifyingOtp
                  ? CircularProgressIndicator()
                  : Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
