import 'package:bohiba/controllers/share_contoroller.dart';
import 'package:get/get.dart';

class ShareBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ShareController>(ShareController());
  }
}
