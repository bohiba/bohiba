import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 3), () async {
      await checkRouteSetting();
    });
  }

  Future<void> checkRouteSetting() async {}
}
