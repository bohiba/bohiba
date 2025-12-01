import '/controllers/open_driver_list_controller.dart';
import 'package:get/get.dart';

class AllOpenDriverBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OpenDriverListController>(() => OpenDriverListController());
  }
}
