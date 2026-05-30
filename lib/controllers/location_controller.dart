import 'dart:async';

import 'package:bohiba/dist/enums/location_enums.dart';
import 'package:dio/dio.dart';

import '/services/api_end_point.dart';
import '/services/device_info_service.dart';
import '/core/network/dio_serivce.dart';
import '/services/global_service.dart';
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

      await getCurrentLocation(isShowAppLoader: false);

      status.value = LocationStateStatus.success;
    } catch (e, stack) {
      _handleError(
        e,
        stack,
        customMessage: 'Failed to initialize location service',
      );
    }
  }

  Future<Position?> getCurrentLocation({bool isShowAppLoader = true}) async {
    try {
      if (isShowAppLoader) {
        GlobalService.showProgress();
      }
      status.value = LocationStateStatus.loading;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      currentPosition.value = position;

      isMockLocation.value = position.isMocked;

      status.value = LocationStateStatus.success;
      if (isShowAppLoader) {
        GlobalService.dismissProgress();
      }
      return position;
    } catch (e, stack) {
      if (isShowAppLoader) {
        GlobalService.dismissProgress();
      }
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
    userTitleMsg.value = '';
    userSubTitle.value = '';
    final Position? position = currentPosition.value;
    if (position == null) {
      userTitleMsg.value = 'No GPS Position';
      userSubTitle.value =
          'Could not read your location. Tap Refresh to try again.';
      GlobalService.dismissProgress();
      return null;
    }

    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        userTitleMsg.value = 'No Location Found';
        userSubTitle.value = 'No address found for your current location.';
        GlobalService.dismissProgress();
        return null;
      }

      final List<Map<String, dynamic>> locList = [];

      for (final Placemark placemark in placemarks) {
        if (placemark.isoCountryCode != 'IN') {
          userTitleMsg.value = 'No Service';
          userSubTitle.value = 'Bohiba is currently available in India only.';
          GlobalService.dismissProgress();
          return null;
        }

        // Skip placemarks that carry no PIN — they add no useful address data.
        if (placemark.postalCode == null || placemark.postalCode!.isEmpty) {
          continue;
        }

        // Prefer the postal API for accurate district name.
        // If the API is unreachable or its cert is expired, fall back to the
        // subAdministrativeArea field that the geocoding package already provides.
        final String district = await _resolveDistrict(
          postalCode: placemark.postalCode!,
          fallback: placemark.subAdministrativeArea ?? '',
        );

        locList.add({
          'name': placemark.name ?? '',
          'locality': placemark.subLocality ?? '',
          'street': placemark.street ?? '',
          'city': placemark.locality ?? '',
          'district': district,
          'state': placemark.administrativeArea ?? '',
          'pincode': placemark.postalCode ?? '',
          'country': placemark.country ?? '',
        });
      }

      if (locList.isEmpty) {
        userTitleMsg.value = 'No Location Found';
        userSubTitle.value =
            'Failed while fetching location. Tap Refresh to try again.';
        GlobalService.dismissProgress();
        return null;
      }

      final Map<String, dynamic> locationObj = {
        'address': locList,
        'lat_lang': {
          'latitude': position.latitude,
          'longitude': position.longitude,
        },
      };

      latLang.value = locationObj;
      arrLocation.value = locList;
      GlobalService.dismissProgress();
      return locationObj;
    } catch (e, stack) {
      GlobalService.dismissProgress();
      userTitleMsg.value = 'Failed';
      userSubTitle.value = 'Unable to fetch address. Tap Refresh to try again.';
      _handleError(e, stack, customMessage: 'Failed to resolve address');
      return null;
    }
  }

  /// Resolves the district name from the India Postal Code API.
  ///
  /// Uses the shared [dioService] Dio instance (not a bare `Dio()`) so all
  /// requests share the app's connection pool and timeout config.
  ///
  /// Falls back to [fallback] — the district value from the geocoding
  /// package — when the postal API is unreachable, returns bad data, or has
  /// an expired TLS certificate. The address still populates; only the
  /// district source changes silently.
  Future<String> _resolveDistrict({
    required String postalCode,
    required String fallback,
  }) async {
    try {
      final response = await dioService.dio.get(
        '${ApiEndPoint.apiPostalCode}/$postalCode',
        options: Options(extra: {'withToken': false}),
      );

      final data = response.data;
      if (data == null || data is! List || data.isEmpty) {
        return fallback;
      }

      final postOffices = data[0]['PostOffice'];
      if (postOffices == null || postOffices is! List || postOffices.isEmpty) {
        return fallback;
      }

      return (postOffices[0]['District'] as String?)?.trim().isNotEmpty == true
          ? postOffices[0]['District'] as String
          : fallback;
    } catch (e) {
      // api.postalpincode.in has intermittent uptime and cert-expiry issues.
      // Log it but never surface it to the user — the fallback district is good enough.
      GlobalService.printHandler(
          'Postal PIN API unavailable for $postalCode — using geocoding fallback. Error: $e');
      return fallback;
    }
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
