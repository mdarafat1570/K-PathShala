import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

Future<String?> getDeviceId() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String? deviceId;

  try {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id; 
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor; 
    }
  } catch (e) {
    print('Error fetching device ID: $e');
  }

  return deviceId;
}
