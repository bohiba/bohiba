import '/services/device_info_service.dart';
import '/services/global_service.dart';
import '/services/profile_service.dart';
import '/services/db_service.dart';
import '/services/dio_serivce.dart';
import '/services/pref_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressAuthController extends GetxController {
  final DBService dbService = DBService();
  final PrefUtils prefUtils = PrefUtils();
  final DioService dioService = DioService();

  final TextEditingController aHouseCtrl = TextEditingController();
  final TextEditingController aLocalityCtrl = TextEditingController();
  final TextEditingController aCityCtrl = TextEditingController();
  final TextEditingController aStreetCtrl = TextEditingController();
  final TextEditingController aDistrictCtrl = TextEditingController();
  final TextEditingController aStateCtrl = TextEditingController();
  final TextEditingController aCountryCtrl = TextEditingController();
  final TextEditingController aPincodeCtrl = TextEditingController();

  GlobalKey<FormState> addressAuthKey = GlobalKey<FormState>();

  RxBool enableLeading = false.obs;

  @override
  void onInit() {
    Map argument = Get.arguments;
    enableLeading.value = argument['showLeading'];
    super.onInit();
  }

  Future<int> addAddress() async {
    GlobalService.closeKeyboard();

    if (!(addressAuthKey.currentState!.validate())) {
      return 0;
    }

    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    Map<String, dynamic> bodyObj = {
      'house_no': aHouseCtrl.text.trim(),
      'locality': aLocalityCtrl.text.trim(),
      'city': aCityCtrl.text.trim(),
      'street': aStreetCtrl.text.trim(),
      'district': aDistrictCtrl.text.trim(),
      'state': aStateCtrl.text.trim(),
      'pin_code': aPincodeCtrl.text.trim(),
      'country': aCountryCtrl.text.trim(),
    };

    int verifyAddress = await ProfileService.addAddress(bodyMap: bodyObj);
    return verifyAddress;
  }
}
