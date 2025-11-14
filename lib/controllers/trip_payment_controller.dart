import '/dist/app_enums.dart';
import '/model/trip_model.dart';
import '/services/trip_service.dart';
import 'package:get/get.dart';

class TripPaymentController extends GetxController {
  Rx<TripPayment> tripPayment = TripPayment().obs;

  @override
  void onInit() {
    tripPayment.value = Get.arguments;
    super.onInit();
  }

  Future<void> getPayment() async {
    TripModel? trip = await TripService.getTrip(
        method: MethodType.local, tripId: tripPayment.value.tripId!);
    if (trip != null) {
      tripPayment.value = trip.payments!.firstWhere((payment) {
        return payment.id == tripPayment.value.id;
      });
    }
  }

  Future<void> deletePayment({required int paymentId}) async {
    Get.back();
    int deleteSucess = await TripService.deletePayment(paymentId: paymentId);
    if (deleteSucess > 0) {
      Get.back(result: true);
    }
  }
}
