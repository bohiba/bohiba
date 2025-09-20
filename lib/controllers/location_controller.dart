import '/services/api_end_point.dart';

import '/services/device_info_service.dart';
import '/services/dio_serivce.dart';
import '/services/global_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationController extends GetxController {
  DioService dioService = DioService();
  RxMap<String, dynamic> latLang = <String, dynamic>{}.obs;

  RxList<Map<String, dynamic>> arrLocation = <Map<String, dynamic>>[].obs;

  RxInt selectedIndex = (-1).obs;

  Future<void> init() async {
    Future.delayed(Duration.zero, () async {
      latLang.value = await getCurrentAddress();
      arrLocation.value = (latLang['address'] as List)
          .map((toElement) => Map<String, dynamic>.from(toElement))
          .toList();
    });
  }

  Future<Map<String, dynamic>> getCurrentAddress() async {
    if (!await DeviceInfoService.hasInternet()) {
      
      return {};
    }
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied');
    }

    GlobalService.showProgress();

    Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high));
    List<Placemark> arrPlacemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    List arrLocation = [];
    String? pinResObj;
    for (Placemark placemark in arrPlacemarks) {
      if (placemark.postalCode == null || placemark.postalCode!.isEmpty) {
      } else {
        if (pinResObj == null) {
          var response = await Dio()
              .get('${ApiEndPoint.apiPostalCode}/${placemark.postalCode}');
          pinResObj = response.data[0]['PostOffice'][0]['District'];
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
        arrLocation.add(placemarkObj);
      }
    }

    Map<String, dynamic> locationObj = {
      'address': arrLocation,
      'lat_lang': {
        "latitude": position.latitude,
        "longitude": position.longitude,
      },
    };
    GlobalService.dismissProgress();
    if (arrPlacemarks.isEmpty) {
      throw Exception('No address found for location');
    }

    // final place = arrPlacemarks.first;

    return locationObj;
  }

  Map<String, dynamic> selectAddress(int index) {
    selectedIndex.value = index;
    return arrLocation[index];
  }
}
