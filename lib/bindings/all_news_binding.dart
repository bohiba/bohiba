import '/controllers/all_news_controller.dart';
import 'package:get/get.dart';

class AllNewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AllNewsController>(AllNewsController());
  }
}
