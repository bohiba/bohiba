import '../controllers/set_image_controller.dart';
import 'package:get/get.dart';

class SetImageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SetImageController>(() => SetImageController());
  }
}
