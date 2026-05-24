import 'package:bohiba/dist/enums/api_status_code.dart';

import '/services/api_end_point.dart';
import '/services/device_info_service.dart';
import '/services/global_service.dart';
import '/core/network/dio_serivce.dart';
import '/services/pref_utils.dart';
import '/services/auth_service.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final PrefUtils _prefUtils = PrefUtils();
  final DioService _dioService = DioService();

  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  final TextEditingController idController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();

  Future<StatusCode> signin(
      {required String uuid, required String password}) async {
    GlobalService.closeKeyboard();
    if (!signInFormKey.currentState!.validate()) {
      return StatusCode.unprocessableEntity;
    }
    StatusCode successLogin =
        await AuthService.signin(uuid: uuid, password: password);

    if (successLogin.isSuccess) {
      idController.clear();
      pwdController.clear();
      return successLogin;
    }
    return successLogin;
  }

  Future<bool> refreshToken() async {
    if (!await DeviceInfoService.hasInternet()) {
      return false;
    }
    GlobalService.showProgress();
    ApiResponse serviceResponse =
        await _dioService.post(ApiEndPoint.apiRefreshToken);
    GlobalService.dismissProgress();
    switch (serviceResponse.statusCode) {
      case 401:
        return false;
      case 200:
        String token = serviceResponse.data['token'];
        _dioService.setToken(token);
        _prefUtils.clearPreferencesData();
        await _prefUtils.saveString(PrefUtils.token, token);
        GlobalService.printHandler("Refresh Token: $token");
        return true;
      default:
        return false;
    }
  }

  String? validateUUIDField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter valid UUID';
    } else if (value.length > 7) {
      return 'UUID is too short. Please Enter valid UUID';
    } else {
      return null;
    }
  }

  void disposeController() {
    idController.dispose();
    pwdController.dispose();
  }

  @override
  void onClose() {
    signInFormKey = GlobalKey<FormState>();
    disposeController();
    super.onClose();
  }
}
