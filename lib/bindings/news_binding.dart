import '/controllers/news_controller.dart';
import 'package:get/get.dart';

class NewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NewsController>(NewsController());
  }
}
