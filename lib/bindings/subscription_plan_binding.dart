import 'package:get/get.dart';
import '/controllers/subscription_plan_controller.dart';

class SubscriptionPlanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubscriptionPlanController>(() => SubscriptionPlanController());
  }
}
