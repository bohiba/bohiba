import 'package:bohiba/controllers/fuel_station_finder_controller.dart';
import 'package:bohiba/dist/component_exports.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FuelStationFinderPage extends GetView<FuelStationFinderController> {
  const FuelStationFinderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(
        title: "Diesel Station",
        showLeading: true,
      ),
      body: Obx(() {
        return GoogleMap(
          zoomControlsEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          clusterManagers: {controller.myCluster.value},
          markers: controller.nearbyMarkers.value,
          initialCameraPosition: CameraPosition(
            target: controller.currentPosition.value ??
                LatLng(21.8787089, 84.91837679999999),
            zoom: 13,
          ),
          onMapCreated: controller.onMapCreated,
          onCameraMove: (onCameraMove) {
            controller.currentPosition.value = onCameraMove.target;
            controller.onCameraMovement();
          },
        );
      }),
    );
  }
}
