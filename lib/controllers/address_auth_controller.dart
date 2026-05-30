import '/dist/enums/api_status_code.dart';
import '/services/global_service.dart';
import '/services/profile_service.dart';
import '/core/network/dio_serivce.dart';
import '/services/pref_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressAuthController extends GetxController {
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
  final RxString token = ''.obs;

  @override
  void onInit() {
    Map? argument = Get.arguments;
    token.value = argument?['token'] ?? '';
    enableLeading.value = argument?['showLeading'] ?? false;
    super.onInit();
  }

  Future<StatusCode> addAddress() async {
    GlobalService.closeKeyboard();

    if (!(addressAuthKey.currentState!.validate())) {
      return StatusCode.unprocessableEntity;
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

    StatusCode statusCode = await ProfileService.addOrUpdateAddress(
      bodyMap: bodyObj,
      token: token.value,
      initAddress: true,
    );
    return statusCode;
  }

  @override
  void dispose() {
    token.close();
    super.dispose();
  }
}
