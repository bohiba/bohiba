import '/dist/app_enums.dart';
import '/model/trip_model.dart';
import '/services/trip_service.dart';
import 'package:get/get.dart';

class TripExpenseController extends GetxController {
  Rx<TripExpense> tripExpense = TripExpense().obs;

  @override
  void onInit() {
    tripExpense.value = Get.arguments;
    super.onInit();
  }

  Future<void> getExpense() async {
    TripModel? trip = await TripService.getTrip(
        method: MethodType.local, tripId: tripExpense.value.tripId!);
    if (trip != null) {
      tripExpense.value = trip.expenses!.firstWhere((expense) {
        return expense.id == tripExpense.value.id;
      });
    }
  }

  Future<void> deleteExpense({required int expenseId}) async {
    Get.back();
    int deleteSucess = await TripService.deleteExpense(expenseId: expenseId);
    if (deleteSucess > 0) {
      Get.back(result: true);
    } else {
      Get.back(result: false);
    }
  }
}
