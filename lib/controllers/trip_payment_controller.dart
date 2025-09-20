import 'package:bohiba/controllers/trip_controller.dart';
import 'package:bohiba/dist/app_enums.dart';
import 'package:bohiba/model/trip_model.dart';
import 'package:bohiba/services/trip_service.dart';
import 'package:get/get.dart';

class TripPaymentController extends GetxController {
  final TripController tripController = Get.find<TripController>();
  Rx<TripPayment> tripPayment = TripPayment().obs;

  @override
  void onInit() {
    tripPayment.value = Get.arguments;
    super.onInit();
  }

  Future<void> getPayment() async {
    tripController.tripInfo.value = (await tripController.getTripInfo(
      methodType: MethodType.server,
      tripInfo: tripController.tripInfo.value,
    ))!;

    tripPayment.value =
        tripController.tripInfo.value.payments!.firstWhere((payment) {
      return payment.id == tripPayment.value.id;
    });
  }

  Future<void> deletePayment(
      {required TripModel tripInfo, required int paymentId}) async {
    Get.back();
    int deleteSucess =
        await TripService.deletePayment(trip: tripInfo, paymentId: paymentId);
    if (deleteSucess > 0) {
      Get.back(result: true);
    } else {
      Get.back(result: false);
    }
  }
}
