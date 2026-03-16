import 'dart:convert';
import 'dart:io';

import '/services/dio_serivce.dart';
import '/services/api_end_point.dart';
import '/services/device_info_service.dart';
import '/services/global_service.dart';
import '/services/pref_utils.dart';
import '/theme/bohiba_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseAppService {
  static final PrefUtils _prefUtils = PrefUtils();
  static final DioService _dioService = DioService();

  static Future<void> initFirebase() async {
    if (Firebase.apps.isNotEmpty) {
      return;
    }

    if (Platform.isIOS) {
      await Firebase.initializeApp();
    } else {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyCN0tM4lVbUAKsRqHY1Ixu5WdD1BQL7t60",
          appId: "1:449684563968:android:e510d9c11349ec3dc6d0e5",
          messagingSenderId: "449684563968",
          projectId: "bohiba-14d80",
        ),
      );
    }
  }

  static Future<void> initNotification() async {
    try {
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      const AndroidNotificationChannel notificationChannel = AndroidNotificationChannel('bohiba_alerts', 'Bohiba Alerts',
          description: 'Notifications for trip updates, payments & announcements', importance: Importance.max, playSound: true, enableLights: true, enableVibration: true);

      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );

      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(notificationChannel);

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        GlobalService.printHandler('Permission Granted');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        GlobalService.printHandler('Provisional Permission Granted');
      } else {
        GlobalService.printHandler('Perssion is restricted by user');
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (Platform.isAndroid && notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            message.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'channelId',
                'channelName',
                channelDescription: 'channelDescription',
                icon: '@mipmap/ic_launcher',
                importance: Importance.max,
                priority: Priority.high,
                enableVibration: true,
                onlyAlertOnce: true,
                color: bohibaTheme.colorScheme.surface,
              ),
            ),
          );
        }
      });

      await FirebaseMessaging.instance.subscribeToTopic('all');
    } catch (e) {
      GlobalService.printHandler('Firebase Exception : ${e.toString()}');
    }
  }

  static Future<void> registerToken() async {
    String strFcmToken = _prefUtils.getString(PrefUtils.keyFirebaseToken);
    String fcmToken = '';
    if (strFcmToken.isNotEmpty) {
      Map fcmTokenObj = jsonDecode(strFcmToken);
      fcmToken = fcmTokenObj['fcm_token'];
    }
    if (fcmToken.isEmpty) {
      if (Platform.isIOS) {
        final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken != null) {
          fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
        } else {
          GlobalService.printHandler('APNS token is not available');
        }
      } else {
        fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
      }
    }

    if (fcmToken.isEmpty || fcmToken == "null") {
      return;
    }

    Map deviceInfo = await DeviceInfoService.getDeviceInfo();
    Map appInfo = await DeviceInfoService.getAppInfo();

    Map<String, dynamic> paramObj = {};
    paramObj['device_id'] = deviceInfo['device_id'];
    paramObj['fcm_token'] = fcmToken;
    paramObj['platform'] = deviceInfo['platform'];
    paramObj['app_version'] = "v${appInfo['version']}.${appInfo['buildNumber']}";
    paramObj['device_name'] = deviceInfo['model'];

    ApiResponse res = await _dioService.post(ApiEndPoint.firbaseToken, body: paramObj);
    switch (res.statusCode) {
      case 200:
        GlobalService.printHandler('FCM REGISTER SUCCESS: ${res.data}');
        await _prefUtils.saveString(PrefUtils.keyFirebaseToken, jsonEncode(res.data));
        GlobalService.dismissProgress();
        return;
      case 401:
        GlobalService.dismissProgress();
        return;
      default:
        GlobalService.dismissProgress();
        return;
    }
  }
}
