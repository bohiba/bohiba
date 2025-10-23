import 'package:bohiba/dist/app_enums.dart';

import 'master_controller.dart';

import '/services/truck_service.dart';
import '/model/truck_model.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class TruckController extends GetxController {
  final MasterController masterController = Get.find<MasterController>();
  final RefreshController refreshTruckPage =
      RefreshController(initialRefresh: false);

  Rx<TruckModel> truckModel = TruckModel().obs;

  RxBool isDriverAssigned = false.obs;

  @override
  void onInit() {
    super.onInit();
    int truckId = Get.arguments;
    Future.delayed(Duration.zero, () async {
      await getTruckInfo(id: truckId);
    });
  }

  Future<void> onRefreshTruckPage() async {
    if (truckModel.value.regdNumber != null) {
      await getTruckInfo(id: truckModel.value.id!, type: MethodType.api);
      refreshTruckPage.refreshCompleted();
    }
  }

  Future<TruckModel?> getTruckInfo({
    required int id,
    MethodType type = MethodType.local,
  }) async {
    TruckModel? truck =
        await TruckService.getTruck(truckId: id, methodType: type);
    if (truck != null) {
      truckModel.value = truck;
    }
    isDriverAssigned.value = truckModel.value.driverUuid == null ? false : true;
    return truck;
  }

  Future<int> deleteTruck({required int truckId}) async {
    int success = await TruckService.deleteTruck(truckId: truckId);
    return success;
  }
}
