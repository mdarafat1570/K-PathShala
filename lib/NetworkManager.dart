// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';

// class NetworkManager {
//   static final NetworkManager _instance = NetworkManager._internal();
//   bool _isConnected = true;
//   final StreamController<bool> _controller = StreamController<bool>.broadcast();

//   factory NetworkManager() {
//     return _instance;
//   }

//   NetworkManager._internal();

//   Stream<bool> get connectionStream => _controller.stream;

//   void initialize(BuildContext context) {
//     // Listen for connectivity changes
//     Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
//           // Check if the result indicates no connection
//           bool newConnectionStatus = result != ConnectivityResult.none;

//           // If the status changed, update the connection state and show dialog if disconnected
//           if (newConnectionStatus != _isConnected) {
//             _isConnected = newConnectionStatus;
//             _controller.add(_isConnected);

//             if (!_isConnected) {
//               _showNoInternetDialog(context);
//             }
//           }
//         } as void Function(List<ConnectivityResult> event)?);
//   }

//   void _showNoInternetDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible:
//           false, // Prevent closing the dialog by tapping outside
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('No Internet Connection'),
//           content: const Text('Please check your internet connection.'),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:kpathshala/app_base/common_imports.dart';

class ConectivityController extends GetxController {
  final Connectivity _conectivity = Connectivity();

  late final StreamSubscription _streamSubscription;

  var _isConected = true.obs;

  bool _isDialogopen = true;

  @override
  void onInit() {
    super.onInit();
    _checkinternetconectivity();
    _streamSubscription =
        _conectivity.onConnectivityChanged.listen(_handleConectionChange);
  }

  Future<void> _checkinternetconectivity() async {
    List<ConnectivityResult> conection = await _conectivity.checkConnectivity();

    _handleConectionChange(conection);
  }

  void _handleConectionChange(List<ConnectivityResult> conections) {
    if (conections.contains(ConnectivityResult.none)) {
      _isConected.value = false;

      showInternetDialof();
    } else {
      _isConected.value = true;
      _closeDialog();
    }
  }

  void showInternetDialof() {
    Get.dialog(AlertDialog(
      title: Text("Offlinbe"),
      content: Text("You're offline. conect and try again"),
      actions: [
        SizedBox(
          height: 40,
          width: 40,
          child: ElevatedButton(onPressed: () {}, child: Text("Retry")),
        )
      ],
    ));
  }

  void _closeDialog() {
    if (_isDialogopen) {
      Get.back();
      _isDialogopen = false;
    }
  }

  @override
  void onClose() {
    _streamSubscription.cancel();
    _closeDialog();
    super.onClose();
  }
}
