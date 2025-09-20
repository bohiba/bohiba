import '/services/api_end_point.dart';

import '../services/device_info_service.dart';
import '../services/global_service.dart';
import '/controllers/master_controller.dart';
import '/routes/app_route.dart';
import '/services/db_service.dart';
import '/services/dio_serivce.dart';
import '/services/pref_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  MasterController get _masterController => Get.put(MasterController());

  final DBService _dbService = DBService();
  final PrefUtils _prefUtils = PrefUtils();
  final DioService _dioService = DioService();

  final TextEditingController idController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController vPwdController = TextEditingController();
  final TextEditingController vCnfrmController = TextEditingController();

  DateTime pickedDate = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await _prefUtils.init();
      // _masterController = Get.put(MasterController());
    });
  }

  Future<void> verifyEmail({required String email}) async {
    GlobalService.closeKeyboard();
    if (!await DeviceInfoService.hasInternet()) {
      return;
    }
    if (!GlobalService.isEmail(email)) {
      GlobalService.showAppToast(message: 'Please Enter Vaild Email.');
      return;
    }
    Map<String, dynamic> bodyObj = {'email': email};
    GlobalService.showProgress();
    ApiResponse serviceResponse = await _dioService.post(
      ApiEndPoint.apiVerifyEmail,
      body: bodyObj,
      withToken: false,
    );
    GlobalService.dismissProgress();
    switch (serviceResponse.statusCode) {
      case 401:
        GlobalService.showAppToast(message: serviceResponse.message);
        break;
      case 200:
        emailController.clear();
        GlobalService.showAppToast(message: serviceResponse.message);
        await Get.toNamed(
          AppRoute.otpScreen,
          arguments: {"email": email, "nxtRoute": AppRoute.createUser},
        );
      default:
    }
  }

  Future<void> verifyOtp({
    required String txtEmail,
    required String txtOtp,
  }) async {
    if (!await DeviceInfoService.hasInternet()) {
      return;
    }
    GlobalService.showProgress();
    Map<String, dynamic> bodyObj = {
      'email': txtEmail,
      'otp': txtOtp,
    };
    ApiResponse serviceResponse = await _dioService.post(
      ApiEndPoint.apiVerifyOtp,
      body: bodyObj,
      withToken: false,
    );

    switch (serviceResponse.statusCode) {
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: serviceResponse.message);
        break;
      case 200:
        String token = serviceResponse.data['token'];
        _dioService.setToken(token);
        await _prefUtils.saveString(PrefUtils.token, token);
        GlobalService.dismissProgress();

        GlobalService.showAppToast(message: serviceResponse.message);
        Get.offNamed(
          AppRoute.createUser,
          arguments: {
            'email': txtEmail,
            'token': token,
          },
        );
      default:
    }
  }

  Future<void> resend() async {
    if (!await DeviceInfoService.hasInternet()) {
      return;
    }
    GlobalService.showProgress();
    ApiResponse serviceResponse = await _dioService.post(
      ApiEndPoint.apiResendOtp,
      withToken: false,
    );
    GlobalService.dismissProgress();
    switch (serviceResponse.statusCode) {
      case 401:
        GlobalService.showAppToast(message: serviceResponse.message);
        break;
      case 200:
        GlobalService.showAppToast(message: serviceResponse.message);
        break;
      default:
    }
  }

  Future<void> registerUser({
    required String txtName,
    required String txtEmail,
    required String txtMobile,
    required String txtDob,
    required String txtPwd,
    required String txtCnfrmPwd,
    required String token,
  }) async {
    if (!await DeviceInfoService.hasInternet()) {
      return;
    }
    GlobalService.closeKeyboard();
    GlobalService.showProgress();
    Map<String, dynamic> bodyObj = {
      'name': txtName,
      'email': txtEmail,
      'mobile_number': txtMobile,
      'dob': txtDob,
      'password': txtPwd,
    };
    ApiResponse serviceResponse = await _dioService.post(
      ApiEndPoint.apiCreateUser,
      body: bodyObj,
    );
    GlobalService.dismissProgress();
    switch (serviceResponse.statusCode) {
      case 401:
        GlobalService.showAppToast(message: serviceResponse.message);
        break;
      case 200:
        // Move to Address Verification
        Get.offNamed(
          AppRoute.userAddressAuthScreen,
          arguments: {'email': txtEmail},
        );
        break;
      default:
    }
  }

  /*
  =======================================================================================
  ||                                    SIGNIN API                                     ||
  =======================================================================================
  */

  Future<void> signin({required String uuid, required String password}) async {
    GlobalService.closeKeyboard();
    if (!await DeviceInfoService.hasInternet()) {
      return;
    }
    GlobalService.showProgress();
    ApiResponse serviceResponse = await _dioService.post(
      ApiEndPoint.apiLogin,
      body: {
        'uuid': uuid,
        'password': password,
      },
      withToken: false,
    );

    switch (serviceResponse.statusCode) {
      case 401:
        // Display Issue
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: serviceResponse.message);
        break;
      case 200:
        String token = serviceResponse.data['token'];
        _dioService.setToken(token);

        await _prefUtils.saveString(PrefUtils.token, token);
        GlobalService.printHandler("App Token: $token");
        await _masterController.profileApi();

        await _masterController.mainApi();

        Get.offAllNamed(AppRoute.navBar);
        idController.clear();
        pwdController.clear();
        GlobalService.dismissProgress();
        break;
      default:
    }
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

  Future<void> logout() async {
    if (!await DeviceInfoService.hasInternet()) {
      return;
    }
    GlobalService.showProgress();
    ApiResponse serviceResponse = await _dioService.post(ApiEndPoint.apiLogout);
    GlobalService.dismissProgress();
    switch (serviceResponse.statusCode) {
      case 498:
        // Token refresh
        await refreshToken();
        break;
      case 401:
        // Display Issue
        break;
      case 200:
        _dbService.clearAllBox();
        _dbService.disposeDB();
        _dioService.clearToken();
        _prefUtils.clearPreferencesData();
        Get.offAllNamed(AppRoute.signIn);
      default:
    }
  }
}
