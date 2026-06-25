# Bohiba — Push Notification Architecture

## Stack

| Layer | Package |
|---|---|
| FCM transport | `firebase_messaging ^16.4.0` |
| Local display | `flutter_local_notifications ^19.5.0` |
| Channel ID | `bohiba_alerts` (max importance, sound, vibration, lights) |

---

## Message Types (FCM)

| Type | Payload | Who shows it |
|---|---|---|
| **Notification message** | has `notification` block (± `data`) | OS auto-shows when app is killed/background; app shows when foreground |
| **Data-only message** | only `data` block, no `notification` | App always shows via `flutter_local_notifications` |

> **Preferred:** backend should send **data-only** messages (`title`/`body` inside `data`). This gives the app full control and avoids OS vs handler conflicts.

---

## App States & Handler Matrix

| App state | Handler that fires | Who renders the notification |
|---|---|---|
| **Foreground** | `FirebaseMessaging.onMessage` | `showLocalNotification()` |
| **Background** | `firebaseMessagingBackgroundHandler` (separate isolate) | `showLocalNotification()` — Flutter plugin suppresses OS auto-show |
| **Killed** + notification message | `firebaseMessagingBackgroundHandler` | OS native layer (already shown before isolate starts) |
| **Killed** + data-only | `firebaseMessagingBackgroundHandler` | `showLocalNotification()` |

---

## Architecture

```
FCM server push
      │
      ▼
┌─────────────────────────────────────────┐
│  App state?                             │
│                                         │
│  FOREGROUND ──► onMessage.listen()      │
│                      │                  │
│                      ▼                  │
│              showLocalNotification()    │
│                                         │
│  BACKGROUND ──► firebaseMessaging       │
│  or KILLED        BackgroundHandler()   │
│                      │                  │
│             appWasKilled?               │
│             message.notification≠null? │
│                      │                  │
│              YES ──► skip (OS showed)   │
│              NO  ──► showLocalNotification()
└─────────────────────────────────────────┘
```

**Notification tap routing** (all three entry points → `_handlePayload`):

```
Tap (foreground local notif) ──► onDidReceiveNotificationResponse
Tap (background FCM)         ──► onMessageOpenedApp
Tap (killed → cold start)    ──► getInitialMessage()
                                        │
                                        ▼
                                 _handlePayload(data)
                                 (extend with Get.toNamed routing)
```

---

## Key Files

| File | Role |
|---|---|
| `lib/services/firebase_app_service.dart` | All FCM + local notification logic |
| `lib/main.dart` | Registers `firebaseMessagingBackgroundHandler` before `runApp` |
| `android/app/src/main/AndroidManifest.xml` | Channel meta-data for OS auto-show |

---

## AndroidManifest Meta-data

```xml
<!-- OS uses this channel when it auto-shows a killed-state notification message -->
<meta-data
    android:name="com.google.firebase.messaging.default_notification_channel_id"
    android:value="bohiba_alerts" />

<meta-data
    android:name="com.google.firebase.messaging.default_notification_icon"
    android:resource="@mipmap/ic_launcher" />
```

---

## Fixes Applied

### Fix 1 — Background handler was a no-op
`initFirebase()` was commented out in `firebaseMessagingBackgroundHandler`. The isolate started cold with no Firebase instance, so nothing ran.  
**Fix:** uncomment `initFirebase()` and call `_initLocalNotifications()` inside the handler.

### Fix 2 — Wrong channel ID in foreground
`onMessage` listener passed channel ID `'channelId'` (a literal placeholder) instead of `'bohiba_alerts'`. The channel didn't exist, so the notification used Android's default low-importance channel (no sound/vibration).  
**Fix:** replaced with the `_kChannelId` constant used everywhere.

### Fix 3 — Duplicate when app killed
When killed, two things happen for a notification message: (1) the FCM native SDK renders it in the system tray, then (2) it spawns the Dart background isolate which also called `showLocalNotification()` → **two notifications**.  
**Fix:** capture `Firebase.apps.isEmpty` **before** calling `initFirebase()`. An empty list means the isolate started cold (app was killed). If killed AND message has a `notification` block, skip `showLocalNotification()` — the OS already showed it.

```dart
final bool appWasKilled = Firebase.apps.isEmpty;   // check BEFORE initFirebase
await FirebaseAppService.initFirebase();

final bool osAlreadyShowed = appWasKilled && message.notification != null;
if (!osAlreadyShowed) {
  await FirebaseAppService.showLocalNotification(message);
}
```

### Fix 4 — Data-only messages showed nothing
`showLocalNotification()` returned early when `message.notification == null`. Data-only messages (no `notification` block) were silently dropped.  
**Fix:** fall back to `message.data['title']` / `message.data['body']` before returning.

```dart
final String? title = notification?.title ?? message.data['title'];
final String? body  = notification?.body  ?? message.data['body'];
if (title == null && body == null) return;
```

### Fix 5 — No tap handling
Tapping a background or terminated notification did nothing.  
**Fix:** wired `onMessageOpenedApp`, `getInitialMessage()`, and `onDidReceiveNotificationResponse` — all three funnel into `_handlePayload(data)` for central routing.

### Fix 6 — iOS foreground silent
iOS was suppressing notifications while the app was in the foreground.  
**Fix:** `setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true)`.

### Fix 7 — @pragma missing
`firebaseMessagingBackgroundHandler` lacked `@pragma('vm:entry-point')`. R8/ProGuard strips unannotated top-level functions in release builds → background notifications silently stopped working in production.  
**Fix:** added the annotation.

---

## Backend Recommendation

Send **data-only** FCM payloads (no `notification` block). Put `title`, `body`, and routing fields inside `data`:

```json
{
  "data": {
    "title": "Trip Update",
    "body": "Your truck has been loaded.",
    "type": "trip_update",
    "id": "456"
  }
}
```

This gives the app full rendering control across all states and eliminates the killed-state duplicate entirely (Fix 3 becomes unnecessary but remains as a safety net).
