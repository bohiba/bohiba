import '/dist/app_enums.dart';
import '/services/trip_service.dart';
import '/model/trip_model.dart';
import 'package:get/get.dart';

class ReassignmentController extends GetxController {
  Rx<Reassignment> reassignment = Reassignment().obs;

  @override
  void onInit() {
    reassignment.value = Get.arguments as Reassignment;
    super.onInit();
  }

  Future<void> getReassign() async {
    TripModel? trip = await TripService.getTrip(
        method: MethodType.local, tripId: reassignment.value.tripId!);
    if (trip != null) {
      reassignment.value = trip.reassignment!.firstWhere((reassign) {
        return reassign.id == reassignment.value.id;
      });
    }
  }

  Future<void> deleteReassign({required int expenseId}) async {
    Get.back();
    int deleteSucess = await TripService.deleteReassign(expenseId: expenseId);
    if (deleteSucess > 0) {
      Get.back(result: true);
    } else {
      Get.back(result: false);
    }
  }
}
