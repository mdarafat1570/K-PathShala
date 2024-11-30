import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:kpathshala/app_theme/app_color.dart';

class ConnectionLost extends StatefulWidget {
  final VoidCallback onConnectionRestored;

  const ConnectionLost({super.key, required this.onConnectionRestored});

  @override
  State<ConnectionLost> createState() => _ConnectionLostState();
}

class _ConnectionLostState extends State<ConnectionLost> {
  late StreamSubscription _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _startListeningForConnection();
  }

  void _startListeningForConnection() {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((result) async {
      if (result != ConnectivityResult.none) {
        // Check if the internet is actually available
        bool isConnected = await InternetConnection().hasInternetAccess;
        if (isConnected) {
          widget.onConnectionRestored(); // Trigger API call
          Navigator.of(context).pop(); // Close the ConnectionLost page
        }
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
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
                const SizedBox(height: 10),
                const Text(
                  'No internet connection',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Try these steps to get back online:',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                // Add your steps here
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    bool isConnected =
                        await InternetConnection().hasInternetAccess;
                    if (isConnected) {
                      widget.onConnectionRestored(); // Trigger API call
                      Navigator.of(context).pop(); // Close this page
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Still no internet connection'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.navyBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
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
      ),
    );
  }
}
