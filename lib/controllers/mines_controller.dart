import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '/model/mines_model.dart';

class MinesController extends GetxController {
  Rx<MinesModel> minesModel = MinesModel().obs;
  RxList<MinesModel> arrMines = <MinesModel>[].obs;

  GoogleMapController? mapController;
  LatLng? lastPosition;

  @override
  void onInit() {
    super.onInit();
    minesModel.value = Get.arguments as MinesModel;
    Future.delayed(Duration.zero, () async {
      ever(minesModel, (model) async {
        if (model.latitude != null && model.longitude != null) {
          lastPosition = LatLng(model.latitude!, model.longitude!);
          await moveCamera(lastPosition!.latitude, lastPosition!.longitude);
        }
      });
    });
  }

  Future<void> moveCamera(double lat, double lng) async {
    final newPosition = LatLng(lat, lng);
    if (lastPosition != null && lastPosition!.latitude == lat && lastPosition!.longitude == lng) {
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
}
