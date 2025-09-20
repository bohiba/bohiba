import 'dart:async';

import 'package:bohiba/services/device_info_service.dart';

import '/services/pref_utils.dart';
import '/theme/theme_changer.dart';

import 'services/global_service.dart';
import '/services/db_service.dart';
import 'package:get/get.dart';
import '/component/screen_utils.dart';
import 'routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'theme/bohiba_theme.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]).then((value) async {
      final DBService dbService = DBService();
      final PrefUtils prefUtils = PrefUtils();
      await prefUtils.init();
      await dbService.initDB();
      await DeviceInfoService.getDeviceInfo();
      Get.put(ThemeController());
      try {
        runApp(MyApp());
      } catch (e) {
        GlobalService.printHandler(e.toString());
      }
    });
  }, (error, errorstack) {
    GlobalService.printHandler(
        '\n=============\n|  App Crashed: ${error.toString()} |\n=============\n');
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  DBService dbService = DBService();
  final ThemeController themeController = Get.find();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        // dbService.clearAllBox();
        break;
      case AppLifecycleState.inactive:
        // dbService.disposeDB();
        break;
      case AppLifecycleState.resumed:
      // dbService.initDB();
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtils.getDimensions(context);

    return Obx(() {
      return AnimatedTheme(
        data: themeController.isDarkMode
            ? BohibaTheme.lightTheme
            : BohibaTheme.darkTheme,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeIn,
        child: ScreenUtilInit(
          child: GetMaterialApp(
            theme: BohibaTheme.lightTheme,
            darkTheme: BohibaTheme.darkTheme,
            themeMode: themeController.themeMode.value,
            // debugShowMaterialGrid: true,
            debugShowCheckedModeBanner: false,
            getPages: AppRoute.routes,
            initialRoute: AppRoute.splashScreen,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    dbService.disposeDB();
    super.dispose();
  }
}
