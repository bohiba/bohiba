import 'package:bohiba/services/global_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum AppFlavor { prod, beta }

// ---------------------------------------------------------------------------
// Base contract — add new flavor-specific fields here as the app grows
// ---------------------------------------------------------------------------
abstract class FlavorConfig {
  String get appName;
  String get baseUrl;
  String get imageUrl;
  String get packageName;
  String get dbName;

  // Firebase
  String get firebaseApiKey;
  String get firebaseAppId;
  String get firebaseMessagingSenderId;
  String get firebaseProjectId;
  String get firebaseDatabaseUrl;
  String get firebaseStorageBucket;
}

// ---------------------------------------------------------------------------
// Production
// ---------------------------------------------------------------------------
class ProdConfig implements FlavorConfig {
  const ProdConfig();

  @override
  String get appName => 'Bohiba';

  @override
  String get baseUrl => 'https://bohiba.com/api';

  @override
  String get imageUrl => 'https://bohiba.com/storage/images';

  @override
  String get packageName => 'com.app.bohiba';

  @override
  String get dbName => 'bohiba.db';

  @override
  String get firebaseApiKey => 'AIzaSyCN0tM4lVbUAKsRqHY1Ixu5WdD1BQL7t60';

  @override
  String get firebaseAppId => '1:449684563968:android:e510d9c11349ec3dc6d0e5';

  @override
  String get firebaseMessagingSenderId => '449684563968';

  @override
  String get firebaseProjectId => 'bohiba-14d80';

  @override
  String get firebaseDatabaseUrl =>
      'https://bohiba-14d80-default-rtdb.firebaseio.com';

  @override
  String get firebaseStorageBucket => 'bohiba-14d80.appspot.com';
}

// ---------------------------------------------------------------------------
// Beta / Testing
// ---------------------------------------------------------------------------
class BetaConfig implements FlavorConfig {
  const BetaConfig();

  @override
  String get appName => 'Bohiba Beta';

  @override
  String get baseUrl => 'https://beta-server-t1.bohiba.com/api';

  @override
  String get imageUrl => 'https://beta-server-t1.bohiba.com/storage/images';

  @override
  String get packageName => 'com.app.bohiba.test';

  @override
  String get dbName => 'bohiba_beta.db';

  @override
  String get firebaseApiKey => 'AIzaSyCN0tM4lVbUAKsRqHY1Ixu5WdD1BQL7t60';

  @override
  String get firebaseAppId => '1:449684563968:android:5ae73d29d52c040dc6d0e5';

  @override
  String get firebaseMessagingSenderId => '449684563968';

  @override
  String get firebaseProjectId => 'bohiba-14d80';

  @override
  String get firebaseDatabaseUrl =>
      'https://bohiba-14d80-default-rtdb.firebaseio.com';

  @override
  String get firebaseStorageBucket => 'bohiba-14d80.appspot.com';
}

// ---------------------------------------------------------------------------
// AppConfig — single access point used across the app
// Flavor is resolved automatically from the package name set by Gradle.
// No --dart-define or entry-point switching required.
// ---------------------------------------------------------------------------
class AppConfig {
  AppConfig._();

  static FlavorConfig _config = const ProdConfig();

  static Future<void> initAppFlavor() async {
    final info = await PackageInfo.fromPlatform();
    _setFlavorFromPackage(info.packageName);
  }

  static void _setFlavorFromPackage(String packageName) {
    _config = packageName == 'com.app.bohiba.test'
        ? const BetaConfig()
        : const ProdConfig();

    GlobalService.printHandler("App Flavor : ${_config.appName}");
  }

  static FlavorConfig get current => _config;

  // Convenience shortcuts
  static String get baseUrl => _config.baseUrl;
  static String get imageUrl => _config.imageUrl;
  static String get appName => _config.appName;
  static String get packageName => _config.packageName;
  static String get dbName => _config.dbName;

  // Firebase shortcuts
  static String get firebaseApiKey => _config.firebaseApiKey;
  static String get firebaseAppId => _config.firebaseAppId;
  static String get firebaseMessagingSenderId =>
      _config.firebaseMessagingSenderId;
  static String get firebaseProjectId => _config.firebaseProjectId;
  static String get firebaseDatabaseUrl => _config.firebaseDatabaseUrl;
  static String get firebaseStorageBucket => _config.firebaseStorageBucket;

  static bool get isProd => _config is ProdConfig;
  static bool get isBeta => _config is BetaConfig;
}
