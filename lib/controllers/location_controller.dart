import '/dist/app_enums.dart';

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
  RxString userTitleMsg = ''.obs;
  RxString userSubTitle = ''.obs;

  @override
  onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await getCurrentAddress();
    });
  }

  Future<Map<String, dynamic>?> getCurrentAddress() async {
    if (!await DeviceInfoService.hasInternet()) {
      return null;
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
    arrLocation.clear();
    Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.low));
    List<Placemark> arrPlacemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    List locList = [];
    String? pinResObj;

    for (Placemark placemark in arrPlacemarks) {
      if (placemark.postalCode == null) {
        userTitleMsg.value = 'No Location Found';
        userSubTitle.value =
            'Failed while fetching location. Refresh to try again.';
        GlobalService.dismissProgress();
        return null;
      } else {
        if (placemark.isoCountryCode == 'IN') {
          try {
            var response = await Dio()
                .get('${ApiEndPoint.apiPostalCode}/${placemark.postalCode}');
            if (response.data[0]['PostOffice'] == null) {
              userTitleMsg.value = 'No Location Found';
              userSubTitle.value =
                  'Failed while fetching location. Refresh to try again.';
              GlobalService.dismissProgress();
              return null;
            }
            pinResObj = response.data[0]['PostOffice'][0]['District'];
          } catch (e) {
            GlobalService.dismissProgress();
            userTitleMsg.value = 'Failed';
            userSubTitle.value =
                'Unstable network connection! Refresh to try again';
            GlobalService.appSnackBar(
                status: AlertStatus.failure,
                desc: 'Please retry something went wrong.');
            return null;
          }
        } else {
          userTitleMsg.value = 'No Service';
          userSubTitle.value =
              'Ooop`s currently we are not available on this region.';
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
    arrLocation.value = (latLang['address'] as List)
        .map((toElement) => Map<String, dynamic>.from(toElement))
        .toList();
    GlobalService.dismissProgress();
    return locationObj;
  }

  Map<String, dynamic> selectAddress(int index) {
    selectedIndex.value = index;
    return arrLocation[index];
  }
}
