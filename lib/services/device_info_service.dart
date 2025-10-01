import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:local_auth/local_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '/services/global_service.dart';
import '/services/pref_utils.dart';

class DeviceInfoService {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  static final PrefUtils _prefUtils = PrefUtils();
  static final LocalAuthentication _auth = LocalAuthentication();
  static late PackageInfo _packageInfo;

  static bool isBioMetricEnabled() {
    return _prefUtils.loadBiometricSetting();
  }

  static Future<Map<String, dynamic>> getAppInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
    return {
      'appName': _packageInfo.appName,
      'packageName': _packageInfo.packageName,
      'version': _packageInfo.version,
      'buildNumber': _packageInfo.buildNumber,
      'signature': _packageInfo.buildSignature,
      'installerStore': _packageInfo.installerStore ?? 'Unknwon',
      'installTime': _packageInfo.installTime,
      'updateTime': _packageInfo.updateTime,
    };
  }

  /// Check internet connectivity
  static Future<bool> hasInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    bool internet = (connectivityResult.contains(ConnectivityResult.none));
    if (internet) {
      GlobalService.showAppToast(message: 'No Internet');
    }
    return !internet;
  }

  /// Get basic device info as a Map
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
        return {
          'platform': 'Android',
          'iconData': 0xf3a9,
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
          'platform': iosInfo.isiOSAppOnMac,
          'iconData': 0xf3a9,
          'model': iosInfo.model,
          'manufacturer': iosInfo.data,
          'systemName': iosInfo.systemName,
          'systemVersion': iosInfo.systemVersion,
          'isPhysicalDevice': iosInfo.isPhysicalDevice,
        };
      } else if (kIsWeb) {
        WebBrowserInfo webInfo = await _deviceInfoPlugin.webBrowserInfo;
        return {
          'platform': 'Web',
          'iconData': 0xf152,
          'browserName': webInfo.browserName.name,
          'userAgent': webInfo.userAgent ?? '',
          'appVersion': webInfo.appVersion ?? '',
          'platformDetail': webInfo.platform ?? '',
          'hardwareConcurrency': webInfo.hardwareConcurrency,
          'isPhysicalDevice': false,
        };
      } else {
        return {'platform': 'Unsupported', 'error': 'Unsupported platform'};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  /// Check if device supports biometric
  Future<bool> canCheckBiometrics() async {
    return await _auth.canCheckBiometrics;
  }

  /// Authenticate user
  static Future<bool> authenticateUser() async {
    try {
      bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to access Bohiba',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true, // re-authenticate on resume
          useErrorDialogs: false,
        ),
      );
      return didAuthenticate;
    } catch (e) {
      GlobalService.printHandler("Biometric error: $e");
      return false;
    }
  }

  static Future<void> setBioMetric({required bool isEnable}) async {
    await _prefUtils.toggleBiometric(isEnable);
  }
}
