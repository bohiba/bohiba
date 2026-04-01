import 'dart:convert';

import 'package:dio/dio.dart';

import '/routes/app_route.dart';
import '/services/firebase_app_service.dart';
import '/services/main_service.dart';
import '/services/user_role_type.dart';
import 'package:get/get.dart';

import '/controllers/role_controller.dart';
import '../dist/enums/app_enums.dart';
import '/model/profile_model.dart';
import '/model/logged_in_user_model.dart';
import 'profile_service.dart';
import 'api_end_point.dart';
import 'device_info_service.dart';
import 'dio_serivce.dart';
import 'global_service.dart';
import 'pref_utils.dart';
import 'db2_service.dart';

class AuthService {
  static final DioService _dioService = DioService();
  static final PrefUtils _prefUtils = PrefUtils();
  static final DatabaseService _databaseService = DatabaseService();

  static Future<bool> refreshToken() async {
    if (!await DeviceInfoService.hasInternet()) {
      return false;
    }
    GlobalService.showProgress();
    ApiResponse serviceResponse = await _dioService.post(
      ApiEndPoint.apiRefreshToken,
    );
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

  static Future<int> logOut() async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    String strFirebaseToken = _prefUtils.getString(PrefUtils.keyFirebaseToken);
    if (strFirebaseToken.isEmpty) {
      return 0;
    }
    Map firebaseTokenInfo = jsonDecode(strFirebaseToken);
    ApiResponse serviceResponse = await _dioService.post(ApiEndPoint.apiLogout, body: {
      "device_id": firebaseTokenInfo['device_id'],
    });
    GlobalService.dismissProgress();
    switch (serviceResponse.statusCode) {
      case 498:
        // Token refresh
        await refreshToken();
        return 2;
      case 401:
        // Display Issue
        return 0;
      case 200:
        await _databaseService.clearDBData();
        _dioService.clearToken();
        await _prefUtils.clearPreferencesData();
        return 1;
      default:
        return 0;
    }
  }

  static Future<int> signin({
    required String uuid,
    required String password,
  }) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    ApiResponse serviceResponse = await _dioService.post(
      ApiEndPoint.apiLogin,
      contentType: Headers.formUrlEncodedContentType,
      body: {'uuid': uuid, 'password': password},
      withToken: false,
    );

    switch (serviceResponse.statusCode) {
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.failure,
          desc: 'Invalid UUID or password. Please retry again.',
        );
        return 0;

      case 200:
        String token = serviceResponse.data['token'];
        _dioService.setToken(token);
        await _prefUtils.saveString(PrefUtils.token, token);
        GlobalService.printHandler("App Token: $token");
        ProfileModel? loggedInUser = await ProfileService.getProfile(
          type: MethodType.api,
          showProgress: false,
        );
        RoleService.initRole(loggedInUser);
        Map<String, dynamic>? mainService = await MainService.mainApi(
          type: MethodType.api,
          showProgress: false,
        );

        await FirebaseAppService.registerToken();
        if (loggedInUser != null) {
          await ProfileService.loggedInUser(
            loggedInUser: LoggedInAccountModel(
              uuid: loggedInUser.uuid,
              name: loggedInUser.name,
              email: loggedInUser.email,
              token: token,
              roleId: loggedInUser.roleId,
            ),
          );
        }

        if (loggedInUser?.roleId == UserRoles.truckOwner) {
          await Get.offAllNamed(AppRoute.truckOwnerNavBar);
        } else if (loggedInUser?.roleId == UserRoles.driver) {
          await Get.offAllNamed(AppRoute.truckDriverNavBar);
        }

        GlobalService.dismissProgress();
        return (loggedInUser != null && mainService != null) ? 1 : 0;
      default:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.failure,
          desc: 'Failed to signin',
        );
        return 0;
    }
  }

  static Future<int> resetPassword() async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    ApiResponse response = await _dioService.post(ApiEndPoint.apiResetPassword);
    GlobalService.dismissProgress();
    switch (response.statusCode) {
      case 401:
        GlobalService.showSnackBar(
          status: AlertStatus.info,
          desc: response.message,
        );
        return 0;
      case 200:
        GlobalService.showSnackBar(
          status: AlertStatus.success,
          desc: 'Otp send successfully',
        );
        return 1;
      default:
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          desc: 'Faile to reset password',
        );
        return 0;
    }
  }

  static Future<int> resendOtp(String email) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    ApiResponse serviceResponse = await _dioService.post(
      ApiEndPoint.apiResendOtp,
      body: {'email': email},
      withToken: false,
    );
    GlobalService.dismissProgress();
    switch (serviceResponse.statusCode) {
      case 401:
        GlobalService.showSnackBar(
          status: AlertStatus.info,
          desc: serviceResponse.message,
        );
        return 0;
      case 200:
        GlobalService.showSnackBar(
          status: AlertStatus.success,
          desc: 'Otp send successfully',
        );
        return 1;
      default:
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          desc: 'Failed to resend otp.',
        );
        return 0;
    }
  }

  static Future<int> verifyOtp({
    required String txtEmail,
    required String txtOtp,
  }) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    Map<String, dynamic> bodyObj = {'email': txtEmail, 'otp': txtOtp};
    ApiResponse serviceResponse = await _dioService.post(
      ApiEndPoint.apiVerifyOtp,
      body: bodyObj,
      withToken: false,
    );

    switch (serviceResponse.statusCode) {
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          desc: serviceResponse.message,
        );
        return 0;
      case 200:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.success,
          desc: serviceResponse.message,
        );
        return 1;
      default:
        return 0;
    }
  }

  static Future<int> emailOtp({required String email}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }

    final Map<String, dynamic> bodyObj = {'email': email};
    GlobalService.showProgress();
    ApiResponse response = await _dioService.post(
      ApiEndPoint.apiForgotPassword,
      body: bodyObj,
      withToken: false,
    );
    GlobalService.dismissProgress();
    switch (response.statusCode) {
      case 200:
        GlobalService.showSnackBar(
          status: AlertStatus.success,
          desc: 'Otp sent successfully',
        );
        return 1;
      case 401:
        GlobalService.showSnackBar(
          status: AlertStatus.info,
          desc: response.message,
        );
        return 0;
      default:
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          desc: 'Failed to send otp',
        );
        return 0;
    }
  }

  static Future<int> verifyEmail({required String txtEmail}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    Map<String, dynamic> bodyObj = {'email': txtEmail};
    GlobalService.showProgress();
    ApiResponse serviceResponse = await _dioService.post(
      ApiEndPoint.apiVerifyEmail,
      body: bodyObj,
      withToken: false,
    );
    GlobalService.dismissProgress();
    switch (serviceResponse.statusCode) {
      case 401:
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          desc: serviceResponse.message,
        );
        return 0;
      case 200:
        GlobalService.showSnackBar(
          status: AlertStatus.success,
          desc: serviceResponse.message,
        );
        return 1;
      default:
        GlobalService.showSnackBar(
          status: AlertStatus.failure,
          desc: 'Failed to send otp',
        );
        return 0;
    }
  }

  static Future<int> changePassword({required Map<String, dynamic> bodyObj}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    ApiResponse res = await _dioService.post(ApiEndPoint.apiResetPassword, body: bodyObj);
    GlobalService.dismissProgress();
    switch (res.statusCode) {
      case 200:
        _dioService.clearToken();
        Future.wait([
          _prefUtils.clearPreferencesData(),
          _databaseService.clearDBData(),
        ]);
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Security',
          desc: res.message,
        );
        return 1;
      case 401:
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Security',
          desc: res.message,
        );
        return 0;
      default:
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Security',
          desc: res.message,
        );
        return 0;
    }
  }
}
