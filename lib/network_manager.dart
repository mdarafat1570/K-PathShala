
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:kpathshala/app_base/common_imports.dart';

class ConnectivityController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  late final StreamSubscription _streamSubscription;
  var isConnected = true.obs;
  bool _isDialogOpen = true;

  @override
  void onInit() {
    super.onInit();
    _checkInternetConnectivity();
    _streamSubscription =
        _connectivity.onConnectivityChanged.listen(_handleConnectionChange);
  }

  Future<void> _checkInternetConnectivity() async {
    List<ConnectivityResult> connection = await _connectivity.checkConnectivity();

    _handleConnectionChange(connection);
  }

  void _handleConnectionChange(List<ConnectivityResult> connections) {
    if (connections.contains(ConnectivityResult.none)) {
      isConnected.value = false;

      showInternetDialog();
    } else {
      isConnected.value = true;
      _closeDialog();
    }
  }
  void showInternetDialog() {
    Get.dialog(AlertDialog(
      title: const Text("Offline"),
      content: const Text("You're offline. connect and try again"),
      actions: [
        SizedBox(
          height: 40,
          width: 40,
          child: ElevatedButton(onPressed: () {}, child: const Text("Retry")),
        )
      ],
    ));
  }
  void _closeDialog() {
    if (_isDialogOpen) {
      Get.back();
      _isDialogOpen = false;
    }
  }
  @override
  void onClose() {
    _streamSubscription.cancel();
    _closeDialog();
    super.onClose();
  }
}
