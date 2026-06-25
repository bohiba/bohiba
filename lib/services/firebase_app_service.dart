import 'dart:convert';
import 'dart:io';

import '../core/network/dio_serivce.dart';
import '/services/api_end_point.dart';
import '/services/device_info_service.dart';
import '/services/global_service.dart';
import '/services/pref_utils.dart';
import '/theme/bohiba_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// ─────────────────────────────────────────────
// Channel constant — single source of truth.
// AndroidManifest meta-data must match this id.
// ─────────────────────────────────────────────
const String _kChannelId = 'bohiba_alerts';
const String _kChannelName = 'Bohiba Alerts';
const String _kChannelDesc =
    'Notifications for trip updates, payments & announcements';

const AndroidNotificationChannel _kAndroidChannel = AndroidNotificationChannel(
  _kChannelId,
  _kChannelName,
  description: _kChannelDesc,
  importance: Importance.max,
  playSound: true,
  enableLights: true,
  enableVibration: true,
);

// Shared plugin instance — top-level so the background isolate can reach it.
final FlutterLocalNotificationsPlugin _localNotifications =
    FlutterLocalNotificationsPlugin();

class FirebaseAppService {
  static final PrefUtils _prefUtils = PrefUtils();
  static final DioService _dioService = DioService();

  // ── Firebase init ─────────────────────────────────────────────────────────

  static Future<void> initFirebase() async {
    if (Firebase.apps.isNotEmpty) return;

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

  // ── Local notifications init ──────────────────────────────────────────────
  // Safe to call from both the main isolate and the background isolate.

  static Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Don't re-request permission here — FCM already handled it.
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _localNotifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );

    // Create the high-importance channel on Android (no-op on iOS).
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_kAndroidChannel);
  }

  // ── Show notification ─────────────────────────────────────────────────────
  // Called from onMessage (foreground) AND from the background isolate handler.

  static Future<void> showLocalNotification(RemoteMessage message) async {
    // Prefer the FCM `notification` block; fall back to data payload fields
    // so data-only messages (background/terminated) still surface a banner.
    final notification = message.notification;
    final String? title = notification?.title ?? message.data['title'];
    final String? body = notification?.body ?? message.data['body'];
    if (title == null && body == null) return;

    await _localNotifications.show(
      message.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _kChannelId,
          _kChannelName,
          channelDescription: _kChannelDesc,
          icon: '@mipmap/ic_launcher',
          importance: Importance.max,
          priority: Priority.high,
          enableVibration: true,
          onlyAlertOnce: true,
          color: bohibaTheme.colorScheme.primary,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      // Carry FCM data so _onLocalNotificationTap can route.
      payload: jsonEncode(message.data),
    );
  }

  // ── Tap handlers ──────────────────────────────────────────────────────────

  static void _onLocalNotificationTap(NotificationResponse response) {
    _handlePayload(response.payload);
  }

  // FCM tap: app was BACKGROUND (already running, brought to foreground).
  static void _onMessageOpenedApp(RemoteMessage message) {
    GlobalService.printHandler(
        'FCM opened app from background: ${message.messageId}');
    _handlePayload(jsonEncode(message.data));
  }

  // FCM tap: app was TERMINATED (cold start).
  static Future<void> _handleTerminatedTap() async {
    final RemoteMessage? initial =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      GlobalService.printHandler(
          'FCM opened app from terminated: ${initial.messageId}');
      _handlePayload(jsonEncode(initial.data));
    }
  }

  // Central routing dispatcher — add navigation when the backend defines
  // a notification schema, e.g. data['type'] == 'trip_update'.
  static void _handlePayload(String? payload) {
    if (payload == null || payload.isEmpty) return;
    try {
      final Map<String, dynamic> data = jsonDecode(payload);
      GlobalService.printHandler('Notification payload: $data');
      // Example:
      // if (data['type'] == 'trip_update') Get.toNamed(AppRoute.tripDetail, arguments: data['id']);
    } catch (_) {}
  }

  // ── Public init ───────────────────────────────────────────────────────────

  static Future<void> initNotification() async {
    try {
      // 1. Request OS permission.
      final NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      GlobalService.printHandler(
          'FCM permission: ${settings.authorizationStatus}');

      // 2. iOS: show banners while the app is in the foreground.
      if (Platform.isIOS) {
        await FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      }

      // 3. Set up local notifications + Android channel.
      await _initLocalNotifications();

      // 4. FOREGROUND — FCM suppresses the system banner; we show it ourselves.
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        GlobalService.printHandler('FCM foreground: ${message.messageId}');
        showLocalNotification(message);
      });

      // 5. BACKGROUND tap — app was running, user tapped the notification.
      FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

      // 6. TERMINATED tap — check once at startup.
      _handleTerminatedTap();

      // 7. Subscribe to broadcast topic.
      await FirebaseMessaging.instance.subscribeToTopic('all');
    } catch (e) {
      GlobalService.printHandler('Firebase initNotification error: $e');
    }
  }

  // ── Token registration ────────────────────────────────────────────────────

  static Future<void> registerToken() async {
    if (!await DeviceInfoService.hasInternet()) return;

    initNotification();

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
          GlobalService.printHandler('APNS token not yet available');
        }
      } else {
        fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
      }
    }

    if (fcmToken.isEmpty || fcmToken == "null") return;

    final Map deviceInfo = await DeviceInfoService.getDeviceInfo();
    final Map appInfo = await DeviceInfoService.getAppInfo();

    final Map<String, dynamic> paramObj = {
      'device_id': deviceInfo['device_id'],
      'fcm_token': fcmToken,
      'platform': deviceInfo['platform'],
      'app_version': "v${appInfo['version']}.${appInfo['buildNumber']}",
      'device_name': deviceInfo['model'],
    };

    ApiResponse res =
        await _dioService.post(ApiEndPoint.firbaseToken, body: paramObj);
    switch (res.statusCode) {
      case 200:
        GlobalService.printHandler('FCM REGISTER SUCCESS: ${res.data}');
        await _prefUtils.saveString(
            PrefUtils.keyFirebaseToken, jsonEncode(res.data));
        GlobalService.dismissProgress();
      case 401:
        GlobalService.dismissProgress();
      default:
        GlobalService.dismissProgress();
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Background isolate handler — MUST be a top-level function annotated with
// @pragma('vm:entry-point') so R8/ProGuard do not strip it in release builds.
//
// Android spins a SEPARATE Dart isolate for this when the app is killed.
// For FCM messages that carry a `notification` block the OS shows the banner
// automatically using the channel declared in AndroidManifest; this handler
// still fires and shows a local notification for data-only messages.
// ─────────────────────────────────────────────────────────────────────────────
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Capture BEFORE initFirebase — this is the only reliable way to distinguish
  // killed vs backgrounded inside a background isolate:
  //   killed    → Firebase.apps.isEmpty (cold isolate, nothing initialised yet)
  //   background → Firebase.apps.isNotEmpty (main isolate already initialised it)
  final bool appWasKilled = Firebase.apps.isEmpty;

  await FirebaseAppService.initFirebase();
  await FirebaseAppService._initLocalNotifications();

  // When the app is killed and the message has a `notification` block, the FCM
  // native SDK already rendered it in the system tray before waking our isolate.
  // Showing again here would produce a duplicate. Skip it — the OS handled it.
  // In all other cases (backgrounded, or data-only while killed) we must show.
  final bool osAlreadyShowed = appWasKilled && message.notification != null;
  if (!osAlreadyShowed) {
    await FirebaseAppService.showLocalNotification(message);
  }

  GlobalService.printHandler(
      'FCM background handled: ${message.messageId} | killed=$appWasKilled | osShowed=$osAlreadyShowed');
}
