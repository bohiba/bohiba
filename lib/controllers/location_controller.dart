import 'dart:async';

import 'package:bohiba/dist/enums/location_enums.dart';

import '/services/api_end_point.dart';
import '/services/device_info_service.dart';
import '/services/dio_serivce.dart';
import '/services/global_service.dart';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationController extends GetxController {
  // Dio Service
  DioService dioService = DioService();

  // Subscription
  StreamSubscription<Position>? _positionSubscription;

  // Settings
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 10,
  );

  // Enums
  final Rx<LocationStateStatus> status = LocationStateStatus.initial.obs;

  // Position
  final Rx<Position?> currentPosition = Rx<Position?>(null);

  // Map
  RxMap<String, dynamic> latLang = <String, dynamic>{}.obs;

  // List of Places
  RxList<Map<String, dynamic>> arrLocation = <Map<String, dynamic>>[].obs;

  // Int
  RxInt selectedIndex = (-1).obs;
  RxBool isTracking = false.obs;
  RxBool isMockLocation = false.obs;

  // String
  RxString userTitleMsg = ''.obs;
  RxString userSubTitle = ''.obs;
  final RxString errorMessage = ''.obs;

  bool get hasLocation => currentPosition.value != null;

  double? get latitude => currentPosition.value?.latitude;

  double? get longitude => currentPosition.value?.longitude;

  String get latLngString => '${latitude ?? 0}, ${longitude ?? 0}';

  @override
  onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await initialize();
    });
  }

  Future<void> initialize() async {
    try {
      status.value = LocationStateStatus.loading;

      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        status.value = LocationStateStatus.serviceDisabled;

        errorMessage.value = 'Location service is disabled';

        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        status.value = LocationStateStatus.permissionDenied;

        errorMessage.value = 'Location permission denied';

        return;
      }

      if (permission == LocationPermission.deniedForever) {
        status.value = LocationStateStatus.permissionDeniedForever;

        errorMessage.value = 'Location permission permanently denied';

        return;
      }

      await getCurrentLocation();

      status.value = LocationStateStatus.success;
    } catch (e, stack) {
      _handleError(
        e,
        stack,
        customMessage: 'Failed to initialize location service',
      );
    }
  }

  Future<Position?> getCurrentLocation() async {
    try {
      GlobalService.showProgress();
      status.value = LocationStateStatus.loading;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      currentPosition.value = position;

      isMockLocation.value = position.isMocked;

      status.value = LocationStateStatus.success;
      GlobalService.dismissProgress();
      return position;
    } catch (e, stack) {
      GlobalService.dismissProgress();
      _handleError(
        e,
        stack,
        customMessage: 'Unable to fetch current location',
      );

      return null;
    }
  }

  Future<void> startLocationTracking() async {
    try {
      if (isTracking.value) return;

      isTracking.value = true;

      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (Position position) {
          currentPosition.value = position;
          isMockLocation.value = position.isMocked;
        },
        onError: (error) {
          GlobalService.printHandler(
            'Location Stream Error: $error',
          );

          errorMessage.value = error.toString();

          status.value = LocationStateStatus.error;
        },
      );
    } catch (e, stack) {
      _handleError(
        e,
        stack,
        customMessage: 'Failed to start location tracking',
      );
    }
  }

  double calculateDistanceInMeters({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  double calculateBearing({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.bearingBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  Future<LocationPermission> checkPermissionStatus() async {
    return Geolocator.checkPermission();
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  void _handleError(
    Object error,
    StackTrace stack, {
    String? customMessage,
  }) {
    GlobalService.printHandler('LOCATION ERROR: $error');
    GlobalService.printHandler('stackTrace: $stack');

    errorMessage.value = customMessage ?? error.toString();

    status.value = LocationStateStatus.error;
  }

  Future<Map<String, dynamic>?> getCurrentAddress() async {
    if (!await DeviceInfoService.hasInternet()) {
      return null;
    }
    GlobalService.showProgress();
    arrLocation.clear();
    Position position = currentPosition.value!;
    List<Placemark> arrPlacemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    List locList = [];
    String? pinResObj;

    for (Placemark placemark in arrPlacemarks) {
      if (placemark.postalCode == null) {
        userTitleMsg.value = 'No Location Found';
        userSubTitle.value = 'Failed while fetching location. Refresh to try again.';
        GlobalService.dismissProgress();
        return null;
      } else {
        if (placemark.isoCountryCode == 'IN') {
          try {
            var response = await Dio().get('${ApiEndPoint.apiPostalCode}/${placemark.postalCode}');
            if (response.data[0]['PostOffice'] == null) {
              userTitleMsg.value = 'No Location Found';
              userSubTitle.value = 'Failed while fetching location. Refresh to try again.';
              GlobalService.dismissProgress();
              return null;
            }
            pinResObj = response.data[0]['PostOffice'][0]['District'];
          } catch (e) {
            GlobalService.dismissProgress();
            userTitleMsg.value = 'Failed';
            userSubTitle.value = 'Unstable network connection! Refresh to try again';
            return null;
          }
        } else {
          userTitleMsg.value = 'No Service';
          userSubTitle.value = 'Ooop`s currently we are not available on this region.';
          GlobalService.dismissProgress();
          return null;
        }
        Map<String, dynamic> placemarkObj = {
          'name': placemark.name ?? '',
          'locality': placemark.subLocality ?? '',
          'street': placemark.street ?? '',
          'city': placemark.locality ?? '',
          'district': pinResObj ?? placemark.subAdministrativeArea ?? '',
          'state': placemark.administrativeArea ?? '',
          'pincode': placemark.postalCode ?? '',
          'country': placemark.country ?? '',
        };
        locList.add(placemarkObj);
      }
    }

    Map<String, dynamic> locationObj = {
      'address': locList,
      'lat_lang': {
        "latitude": position.latitude,
        "longitude": position.longitude,
      },
    };

    if (arrPlacemarks.isEmpty) {
      throw Exception('No address found for location');
    }

    // final place = arrPlacemarks.first;
    latLang.value = locationObj;
    arrLocation.value = (latLang['address'] as List).map((toElement) => Map<String, dynamic>.from(toElement)).toList();
    GlobalService.dismissProgress();
    return locationObj;
  }

  Map<String, dynamic> selectAddress(int index) {
    selectedIndex.value = index;
    return arrLocation[index];
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
    super.dispose();
  }
}
