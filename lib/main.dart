import 'package:bohiba/controllers/add_vehicle_controller.dart';
import 'package:bohiba/controllers/global_controller.dart';
import 'package:bohiba/controllers/signin_controller.dart';
import 'package:bohiba/controllers/signup_controller.dart';
import 'package:bohiba/controllers/user_auth_controller.dart';
import 'package:bohiba/routes/bohiba_route.dart';
import 'package:bohiba/utils/screen_utils.dart';
import 'package:bohiba/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:bohiba/pages/widget/app_theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
    (_) => runApp(
      const MyApp(),
    ),
  );
  Get.lazyPut(() => AddVehicleController());
  Get.lazyPut(() => GlobalController());
  Get.lazyPut(() => SplashController());
  Get.lazyPut(() => SignInController());
  Get.lazyPut(() => SignUpController());
  Get.lazyPut(() => UserAuthController());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    BohibaResponsiveScreen.getDimensions(context);
    return ScreenUtilInit(
      child: GetMaterialApp(
        theme: bohibaTheme,
        // debugShowMaterialGrid: true,
        debugShowCheckedModeBanner: false,
        getPages: BohibaRoute.pages,
        initialRoute: BohibaRoute.signIn,
      ),
    );
  }
}
