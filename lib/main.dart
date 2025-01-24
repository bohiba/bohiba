import 'package:bohiba/dist/controller_exports.dart';
import 'package:bohiba/routes/bohiba_route.dart';
import 'package:bohiba/component/screen_utils.dart';
import 'package:bohiba/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
    (_) => runApp(const MyApp()),
  );
  Get.lazyPut<AddVehicleController>(() => AddVehicleController());
  Get.lazyPut<GlobalController>(() => GlobalController());
  Get.lazyPut<SplashController>(() => SplashController());
  Get.lazyPut<SignInController>(() => SignInController());
  Get.lazyPut<SignUpController>(() => SignUpController());
  Get.lazyPut<UserAuthController>(() => UserAuthController());
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
        getPages: AppRoute.pages,
        initialRoute: AppRoute.signIn,
      ),
    );
  }
}
