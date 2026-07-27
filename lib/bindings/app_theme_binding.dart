import 'package:get/get.dart';
import '/controllers/theme_controller.dart';

class AppThemeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ThemeController>(() => ThemeController(), fenix: true);
  }
}
