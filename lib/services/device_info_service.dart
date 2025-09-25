import 'dart:io';
import 'package:bohiba/services/global_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  /// Check internet connectivity
  static Future<bool> hasInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    bool internet = (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi));
    if (!internet) {
      GlobalService.showAppToast(message: 'No Internet');
    }
    return internet;
  }

  /// Get basic device info as a Map
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
        return {
          'platform': 'Android',
          'model': androidInfo.model,
          'manufacturer': androidInfo.manufacturer,
          'androidVersion': androidInfo.version.release,
          'sdkInt': androidInfo.version.sdkInt,
          'isPhysicalDevice': androidInfo.isPhysicalDevice,
          'extra': androidInfo.model
        };
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
        return {
          'platform': 'iOS',
          'manufacturer': iosInfo.data,
          'systemName': iosInfo.systemName,
          'systemVersion': iosInfo.systemVersion,
          'isPhysicalDevice': iosInfo.isPhysicalDevice,
        };
      } else {
        return {'platform': 'Unsupported', 'error': 'Unsupported platform'};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}
