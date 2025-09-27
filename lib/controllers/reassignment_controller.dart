import '/dist/app_enums.dart';

import '/services/trip_service.dart';

import '/controllers/trip_controller.dart';
import '/model/trip_model.dart';
import 'package:get/get.dart';

class ReassignmentController extends GetxController {
  final TripController tripController = Get.find<TripController>();
  Rx<Reassignment> reassignment = Reassignment().obs;

  @override
  void onInit() {
    reassignment.value = Get.arguments as Reassignment;
    super.onInit();
  }

  Future<void> getReassign() async {
    tripController.tripInfo.value = (await tripController.getTripInfo(
      methodType: MethodType.server,
      tripInfo: tripController.tripInfo.value,
    ))!;

    reassignment.value =
        tripController.tripInfo.value.reassignment!.firstWhere((reassign) {
      return reassign.id == reassignment.value.id;
    });
  }

  Future<void> deleteReassign({
    required TripModel tripInfo,
    required int expenseId,
  }) async {
    Get.back();
    int deleteSucess =
        await TripService.deleteReassign(trip: tripInfo, expenseId: expenseId);
    if (deleteSucess > 0) {
      Get.back(result: true);
    } else {
      Get.back(result: false);
    }
  }
}
