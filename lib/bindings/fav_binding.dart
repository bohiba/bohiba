import '/controllers/fav_controller.dart';
import 'package:get/get.dart';

class FavBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<FavController>(FavController());
  }
}
