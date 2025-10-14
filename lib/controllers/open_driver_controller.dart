import 'package:bohiba/model/rating_model.dart';

import '/dist/app_enums.dart';
import '/model/driver_model.dart';
import '/services/open_driver_service.dart';
import 'package:get/get.dart';

class OpenDriverController extends GetxController {
  Rx<DriverModel> openDriver = DriverModel().obs;
  RxBool popResult = false.obs;
  RxDouble avgRating = 0.0.obs;

  @override
  void onInit() {
    openDriver.value = Get.arguments;
    popResult.value = false;
    super.onInit();

    Future.delayed(Duration.zero, () async {
      if (openDriver.value.licenseDetail == null) {
        await getOpenDriver(
            id: openDriver.value.id!, methodType: MethodType.api);
      } else {
        await getOpenDriver(
          id: openDriver.value.id!,
          methodType: MethodType.local,
        );
      }
    });
  }

  Future<void> connect() async {
    if (openDriver.value.profile?.connect != null) return;
    openDriver.value.profile!.connect = 'pending';
    DriverModel? openDriverInfo =
        await OpenDriverService.connectDriver(driverInfo: openDriver.value);
    if (openDriverInfo != null) {
      popResult.value = true;
      openDriver.value = openDriverInfo;
    }
  }

  Future<void> getOpenDriver(
      {required int id, required MethodType methodType}) async {
    DriverModel? driverInfo = await OpenDriverService.getOpenDriverPrfl(
        driverId: id, type: methodType);
    if (driverInfo != null) {
      openDriver.value = driverInfo;
      avgRating.value = _getAverageRating(driverInfo.rating);
    }
  }

  double _getAverageRating(List<RatingModel>? ratings) {
    if (ratings == null || ratings.isEmpty) return 0.0;
    final double total =
        ratings.fold<double>(0.0, (sum, item) => sum + (item.rating ?? 0));
    return total / ratings.length;
  }
}
