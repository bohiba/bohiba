import '/dist/app_enums.dart';
import '/services/global_service.dart';
import '/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateUserController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController vPwdController = TextEditingController();
  final TextEditingController vCnfrmController = TextEditingController();

  GlobalKey<FormState> createUserFormKey = GlobalKey<FormState>();

  DateTime? pickedDate;

  Future<int> registerUser({required String txtEmail}) async {
    GlobalService.closeKeyboard();

    if (!(createUserFormKey.currentState!.validate())) {
      return 0;
    } else if (vPwdController.text != vCnfrmController.text) {
      GlobalService.appSnackBar(
          status: AlertStatus.info,
          desc: 'Password does`nt match. Please retry again.');
      return 0;
    }
    Map<String, dynamic> bodyObj = {
      'name': nameController.text.trim().toUpperCase(),
      'email': txtEmail,
      'mobile_number': mobileController.text.trim(),
      'dob': dateController.text.trim(),
      'password': vPwdController.text,
    };

    int result = await ProfileService.createUser(bodyMap: bodyObj);

    return result;
  }
}
