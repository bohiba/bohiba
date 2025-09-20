import '/controllers/trip_controller.dart';
import '/dist/app_enums.dart';
import '/model/trip_model.dart';
import '/services/trip_service.dart';
import 'package:get/get.dart';

class TripExpenseController extends GetxController {
  final TripController tripController = Get.find<TripController>();
  Rx<TripExpense> tripExpense = TripExpense().obs;

  @override
  void onInit() {
    tripExpense.value = Get.arguments;
    super.onInit();
  }

  Future<void> getExpense() async {
    tripController.tripInfo.value = (await tripController.getTripInfo(
      methodType: MethodType.server,
      tripInfo: tripController.tripInfo.value,
    ))!;

    tripExpense.value =
        tripController.tripInfo.value.expenses!.firstWhere((expense) {
      return expense.id == tripExpense.value.id;
    });
  }

  Future<void> deleteExpense(
      {required TripModel tripInfo, required int expenseId}) async {
    Get.back();
    int deleteSucess =
        await TripService.deleteExpense(trip: tripInfo, expenseId: expenseId);
    if (deleteSucess > 0) {
      Get.back(result: true);
    } else {
      Get.back(result: false);
    }
  }
}
