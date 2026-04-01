import '/controllers/mines_controller.dart';
import 'package:get/get.dart';

import '/component/screen_utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MinesLocation extends GetView<MinesController> {
  const MinesLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        String? markerId = controller.minesModel.value.id.toString();

        return Padding(
          padding: EdgeInsets.symmetric(vertical: ScreenUtils.height15),
          child: Column(
            children: [
              SizedBox(
                height: ScreenUtils.height * 0.195,
                width: double.maxFinite,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: GoogleMap(
                    padding: EdgeInsets.zero,
                    zoomControlsEnabled: false,
                    onMapCreated: (mapCtrl) async {
                      controller.mapController = mapCtrl;
                      final model = controller.minesModel.value;

                      if (model.latitude != null && model.longitude != null) {
                        await controller.moveCamera(model.latitude!, model.longitude!);
                      }
                    },
                    // Uncomment if you want to drag map
                    // scrollGesturesEnabled: false,
                    /*gestureRecognizers: {
                      Factory<OneSequenceGestureRecognizer>(
                        () => EagerGestureRecognizer(),
                      ),
                    },*/
                    initialCameraPosition: CameraPosition(
                      target: LatLng(controller.minesModel.value.latitude!, controller.minesModel.value.longitude!),
                      zoom: 16,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId(markerId),
                        position: LatLng(
                          controller.minesModel.value.latitude!,
                          controller.minesModel.value.longitude!,
                        ),
                        infoWindow: InfoWindow(
                          title: controller.minesModel.value.name,
                        ),
                      ),
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
