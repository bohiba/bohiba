import 'dart:async';

import 'theme/bohiba_theme.dart';
import '/controllers/theme_controller.dart';
import '/services/firebase_app_service.dart';
import 'services/global_service.dart';
import '/component/screen_utils.dart';
import 'package:get/get.dart';
import 'routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    FirebaseMessaging.onBackgroundMessage(
        firebaseMessagingBackgroundHandler);

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    runApp(MyApp());
  }, (error, errorstack) {
    GlobalService.printHandler(
        '\n=============\n|  App Crashed: ${error.toString()} |\n=============\n');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtils.getDimensions(context);
    final controller =
        Get.put<ThemeController>(ThemeController());
    return Obx(() {
      return AnimatedTheme(
        data: controller.isDarkMode
            ? BohibaTheme.lightTheme
            : BohibaTheme.darkTheme,
        duration: const Duration(seconds: 1),
        curve: Curves.easeIn,
        child: ScreenUtilInit(
          child: GetMaterialApp(
            theme: BohibaTheme.lightTheme,
            darkTheme: BohibaTheme.darkTheme,
            themeMode: controller.themeMode.value,
            // debugShowMaterialGrid: true,
            debugShowCheckedModeBanner: false,
            getPages: AppRoute.routes,
            initialRoute: AppRoute.splashScreen,
          ),
        ),
      );
    });
  }
}
