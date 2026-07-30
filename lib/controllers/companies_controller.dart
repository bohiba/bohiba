import 'package:bohiba/dist/enums/enum_favourite_type.dart';
import 'package:bohiba/services/favourite_service.dart';

import '/services/company_service.dart';

import '/model/truck_model.dart';
import '/pages/company/company_live_queue_status.dart';
import '/model/company_model.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'home_controller.dart';

class CompaniesController extends GetxController {
  Rx<CompanyModel?> minesModel = CompanyModel().obs;
  RxList<CompanyModel> arrMines = <CompanyModel>[].obs;
  RxList<TruckModel> arrTruck = <TruckModel>[].obs;
  RxList<QueueStatusList> arrQueue = <QueueStatusList>[].obs;

  GoogleMapController? mapController;
  LatLng? lastPosition;

  @override
  void onInit() {
    super.onInit();
    minesModel.value = Get.arguments as CompanyModel;
    Future.delayed(Duration.zero, () async {
      minesModel.value =
          await CompanyService.getCompany(minesModel.value?.id ?? 0);
      ever(minesModel, (CompanyModel? model) async {
        if (model?.latitude != null && model?.longitude != null) {
          lastPosition = LatLng(model!.latitude!, model.longitude!);
          await moveCamera(lastPosition!.latitude, lastPosition!.longitude);
        }
      });
    });

    arrQueue.value = getDemoQueueList();
  }

  Future<void> moveCamera(double lat, double lng) async {
    final newPosition = LatLng(lat, lng);
    if (lastPosition != null &&
        lastPosition!.latitude == lat &&
        lastPosition!.longitude == lng) {
      return;
    }
    lastPosition = newPosition;
    if (mapController == null) return;

    await mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: newPosition,
          zoom: 16,
        ),
      ),
    );
  }

  @override
  void onClose() {
    mapController?.dispose();
    super.onClose();
  }

  // DEMO DATA
  List<QueueStatusList> getDemoQueueList() {
    return [
      QueueStatusList(
        id: 33,
        vechileId: 'OD14AC5857',
        status: 0,
        watingTime: '43',
        owned: 1,
      ),
      QueueStatusList(
        id: 1,
        vechileId: 'MH12KT9045',
        status: 3,
        watingTime: '43',
        owned: 0,
      ),
      QueueStatusList(
        id: 2,
        vechileId: 'KA05PL3321',
        status: 3,
        watingTime: '42',
        owned: 0,
      ),
      QueueStatusList(
        id: 3,
        vechileId: 'TN09ZX1184',
        status: 3,
        watingTime: '42',
        owned: 0,
      ),
      QueueStatusList(
        id: 4,
        vechileId: 'CG04LM7623',
        status: 3,
        watingTime: '42',
        owned: 0,
      ),
      QueueStatusList(
        id: 5,
        vechileId: 'WB22QR4410',
        status: 2,
        watingTime: '42',
        owned: 0,
      ),
      QueueStatusList(
        id: 6,
        vechileId: 'RJ18DF9032',
        status: 2,
        watingTime: '42',
        owned: 0,
      ),
      QueueStatusList(
        id: 7,
        vechileId: 'AP16GH7285',
        status: 1,
        watingTime: '42',
        owned: 0,
      ),
      QueueStatusList(
        id: 8,
        vechileId: 'BR11TY5541',
        status: 1,
        watingTime: '42',
        owned: 0,
      ),
      QueueStatusList(
        id: 9,
        vechileId: 'UP32JK6678',
        status: 0,
        watingTime: '42',
        owned: 0,
      ),
      QueueStatusList(
        id: 10,
        vechileId: 'GJ01MN2456',
        status: 0,
        watingTime: '42',
        owned: 0,
      ),
    ];
  }

  Future<void> syncFavourite() async {
    Map<String, dynamic> favObj = {
      'asset_type': EnumFavouriteType.mines.index,
      'asset_id': minesModel.value?.id,
    };

    bool success = await FavouriteService.addOrRemoveFav(favObj);
    minesModel.value?.isFav = success;
    minesModel.refresh();

    if (Get.isRegistered<HomeController>()) {
      await Get.find<HomeController>().refreshFavouriteList();
    }
  }
}
