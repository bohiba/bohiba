import 'dart:async';
import 'dart:ui' as ui;

import 'package:bohiba/component/image_path.dart';
import 'package:bohiba/controllers/location_controller.dart';
import 'package:bohiba/services/api_end_point.dart';
import 'package:bohiba/core/network/dio_serivce.dart';
import 'package:bohiba/services/global_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FuelStationFinderController extends GetxController {
  // Controller
  final LocationController locationController = Get.find<LocationController>();
  late GoogleMapController mapController;

  // Dio Service
  final DioService _dioService = DioService();

  // Throttle
  Timer? _throttle;

  // ClusterManager
  final Rx<ClusterManager> myCluster = ClusterManager(
    clusterManagerId: ClusterManagerId('my cluster'),
  ).obs;

  // Marker
  Rx<Set<Marker>> nearbyMarkers = Rx<Set<Marker>>(<Marker>{});
  Rx<Marker> marker = Marker(
    markerId: MarkerId("bohiba_marker"),
  ).obs;

  // Bitmap Descriptor
  Rx<BitmapDescriptor> petrolPumpIcon = BitmapDescriptor.defaultMarker.obs;

  // LatLng
  Rxn<LatLng> currentPosition = Rxn<LatLng>();

  final String _googleApiKey = "AIzaSyCN0tM4lVbUAKsRqHY1Ixu5WdD1BQL7t60";

  @override
  void onInit() {
    super.onInit();

    Future.delayed(Duration.zero, () async {
      Position? position = await locationController.getCurrentLocation();

      if (position != null) {
        currentPosition.value = LatLng(position.latitude, position.longitude);
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: currentPosition.value!,
              zoom: 13,
            ),
          ),
        );
        await fetchNearbyPetrolPumps(
          LatLng(position.latitude, position.longitude),
          showProgress: true,
        );
      }
      update();
    });
  }

  onCameraMovement() {
    if (_throttle?.isActive ?? false) {
      return;
    }

    _throttle = Timer(
      const Duration(seconds: 2),
      () {
        fetchNearbyPetrolPumps(
          currentPosition.value!,
        );
      },
    );
  }

  Future<void> fetchNearbyPetrolPumps(LatLng location, {bool showProgress = false}) async {
    if (showProgress) GlobalService.showProgress();
    final String url = ApiEndPoint.apiNearbySearch;
    final lat = location.latitude;
    final lng = location.longitude;
    final radius = '5000';
    final type = 'gas_station';

    try {
      GlobalService.printHandler('$url?location=$lat,$lng&radius=$radius&type=$type&key=$_googleApiKey');
      final MapResponse response = await _dioService.getMap(
        '$url?location=$lat,$lng&radius=$radius&type=$type&key=$_googleApiKey',
      );
      if (showProgress) GlobalService.dismissProgress();

      if (response.statusCode == 200) {
        final List? data = response.data;

        if (data == null || data.isEmpty) {
          GlobalService.showAppToast(message: "No petrol pumps found");
          return;
        }

        GlobalService.printHandler("Nearby Petrol Pump : $data");

        nearbyMarkers.value = data.where((place) {
          final bool operationalStatus = place['business_status'] == "OPERATIONAL";
          final bool openNow = place['opening_hours']?['open_now'] ?? false;

          return operationalStatus && openNow;
        }).map((place) {
          final lat = place['geometry']['location']['lat'];
          final lng = place['geometry']['location']['lng'];
          final name = place['name'];
          final id = place['place_id'];

          return Marker(
            markerId: MarkerId(id),
            position: LatLng(lat, lng),
            icon: petrolPumpIcon.value,
            infoWindow: InfoWindow(
              title: name,
              snippet: "${place['rating']?.toString() ?? '0'} Star",
            ),
          );
        }).toSet();
      }
    } catch (e) {
      if (showProgress) GlobalService.dismissProgress();
      GlobalService.printHandler("Error fetching places: $e");
    }
  }

  Future<void> loadMarker() async {
    petrolPumpIcon.value = await bitmapDescriptorFromSvgAsset(
      ImagePath.petrolPump,
      const Size(80, 80),
    );
  }

  Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(
    String assetName,
    Size size,
  ) async {
    // Load SVG data
    final String svgString = await rootBundle.loadString(assetName);

    // Create DrawableRoot
    final PictureInfo pictureInfo = await vg.loadPicture(
      SvgStringLoader(svgString),
      null,
    );

    // Convert to image
    final ui.Image image = await pictureInfo.picture.toImage(
      size.width.toInt(),
      size.height.toInt(),
    );

    final ByteData? bytes = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List());
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}
