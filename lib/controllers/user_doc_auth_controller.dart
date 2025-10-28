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

  @override
  void onInit() {
    super.onInit();

    Map<String, dynamic> argument = Get.arguments as Map<String, dynamic>;
    role = argument['role_id'];
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
    int success = await ProfileService.addDocument(bodyMap: bodyObj);
    return success;
  }

  @override
  void dispose() {
    verifyDocFormKey = GlobalKey<FormState>();
    super.dispose();
  }
}
