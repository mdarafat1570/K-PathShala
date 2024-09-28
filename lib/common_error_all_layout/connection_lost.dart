import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kpathshala/app_theme/app_color.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // To check internet connection

class ConnectionLost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/no_internet_lay_out.svg',
                height: 400,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 10),
              const Text(
                'Your connection is lost',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Please check your internet connection and try again.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  var connectivityResult =
                      await Connectivity().checkConnectivity();
                  if (connectivityResult != ConnectivityResult.none) {
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Still no internet connection')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.navyBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
