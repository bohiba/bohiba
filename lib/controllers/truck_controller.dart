import '/model/user_fav_model.dart';

import '/services/api_end_point.dart';
import '/services/fav_service.dart';
import '/services/device_info_service.dart';
import '/services/db_service.dart';
import '/services/dio_serivce.dart';
import '/services/global_service.dart';

import '/controllers/master_controller.dart';
import '/model/truck_model.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:get/get.dart';

class TruckController extends GetxController {
  final MasterController masterController = Get.find<MasterController>();

  DioService dioService = DioService();
  DBService dBService = DBService();

  final RefreshController refreshTruckPage =
      RefreshController(initialRefresh: false);

  Rx<TruckModel> truckModel = TruckModel().obs;

  RxBool isDriverAssigned = false.obs;

  @override
  void onInit() {
    super.onInit();
    int truckId = Get.arguments;
    Future.delayed(Duration.zero, () async {
      await getTruckInfo(id: truckId.toString());
    });
  }

  Future<void> onRefreshTruckPage() async {
    if (truckModel.value.registration != null) {
      await getTruckInfo(id: truckModel.value.id!.toString());
      refreshTruckPage.refreshCompleted();
    }
  }

  Future<TruckModel?> getTruckInfo({required String id}) async {
    TruckModel truck = await dBService.getData(tblTrucks, id) ?? TruckModel();
    truckModel.value = truck;
    isDriverAssigned.value = truckModel.value.driver == null ? false : true;
    return truck;
  }

  Future<void> handleFav(
      {required int assetId, required TruckModel truckModel}) async {
    if (truckModel.isFav) {
      bool _ = await FavService.findDeleteFav(assetId, 'trucks');
    } else {
      UserFavouriteModel? favModel =
          await FavService.createFav(assetType: 'trucks', assetId: assetId);
      truckModel.isFav = true;
      int insertSucess = await dBService.putData<TruckModel>(
          tblTrucks, favModel!.assetId.toString(), truckModel);
      GlobalService.printHandler('Fav data: $insertSucess');
    }
  }

  Future<void> deleteTruck({required int truckId}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return;
    }
    GlobalService.showProgress();
    ApiResponse serviceResponse =
        await dioService.delete("${ApiEndPoint.apiDeleteTruck}/$truckId");
    GlobalService.dismissProgress();
    switch (serviceResponse.statusCode) {
      case 401:
        GlobalService.showAppToast(message: serviceResponse.message);
        break;
      case 200:
        int dBSuccess =
            await dBService.deleteData<TruckModel>(tblTrucks, '$truckId');
        if (dBSuccess > 0) {
          GlobalService.showAppToast(message: serviceResponse.message);
          Get.back(result: true);
        }
        break;
      default:
    }
  }
}
