import '/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDocAuthController extends GetxController {
  TextEditingController aadharNumberController = TextEditingController();
  TextEditingController panNumberController = TextEditingController();
  TextEditingController dlNumberController = TextEditingController();
  GlobalKey<FormState> verifyDocFormKey = GlobalKey<FormState>();

  int role = 9;
  bool get isTruckOwner => role == 6;
  RxString strtoken = ''.obs;

  @override
  void onInit() {
    super.onInit();

    Map<String, dynamic> argument = Get.arguments as Map<String, dynamic>;
    role = argument['role_id'];
    strtoken.value = argument['token'];
  }

  Future<int> validateUserDoc() async {
    if (!verifyDocFormKey.currentState!.validate()) {
      return 0;
    }
    Map<String, dynamic> bodyObj = {
      "aadhaar_number": aadharNumberController.text.trim().replaceAll('-', ''),
      "pan_number": panNumberController.text.trim(),
      if (!isTruckOwner) "dl_number": dlNumberController.text.trim(),
    };
    int success = await ProfileService.addDocument(
        bodyMap: bodyObj, token: strtoken.value);
    return success;
  }

  @override
  void onClose() {
    aadharNumberController.dispose();
    panNumberController.dispose();
    dlNumberController.dispose();
    verifyDocFormKey = GlobalKey<FormState>();
    super.onClose();
  }
}
