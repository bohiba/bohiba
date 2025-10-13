import '/dist/app_enums.dart';
import '/model/profile_model.dart';
import '../model/logged_in_user_model.dart';

import 'db_service.dart';
import 'profile_service.dart';
import 'api_end_point.dart';
import 'device_info_service.dart';
import 'dio_serivce.dart';
import 'global_service.dart';
import 'pref_utils.dart';

class AuthService {
  static final DioService _dioService = DioService();
  static final DBService _dbService = DBService();
  static final PrefUtils _prefUtils = PrefUtils();

  static Future<bool> refreshToken() async {
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

  static Future<int> logOut() async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    ApiResponse serviceResponse = await _dioService.post(ApiEndPoint.apiLogout);
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
        _dbService.clearAllBox();
        _dbService.disposeDB();
        _dioService.clearToken();
        await _prefUtils.clearPreferencesData();
        return 1;
      default:
        return 0;
    }
  }

  static Future<int> signin(
      {required String uuid, required String password}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
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
        GlobalService.dismissProgress();
        GlobalService.appSnackBar(
          status: AlertStatus.failure,
          desc: 'Invalid UUID or password. Please retry again.',
        );
        return 0;

      case 200:
        await _dbService.clearAllBox();
        String token = serviceResponse.data['token'];
        _dioService.setToken(token);
        await _prefUtils.saveString(PrefUtils.token, token);
        GlobalService.printHandler("App Token: $token");
        ProfileModel? loggedInUser =
            await ProfileService.getProfile(type: MethodType.api);
        if (loggedInUser != null) {
          await ProfileService.loggedInUser(
            loggedInUser: LoggedInAccountModel(
              uuid: loggedInUser.uuid,
              name: loggedInUser.name,
              email: loggedInUser.email,
              token: token,
              isLoggedIn: true,
            ),
          );
        }
        GlobalService.dismissProgress();
        return 1;
      default:
        GlobalService.appSnackBar(
          status: AlertStatus.failure,
          desc: 'Something went wrong. Please try after sometime',
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
        GlobalService.appSnackBar(
          status: AlertStatus.info,
          desc: response.message,
        );
        return 0;
      case 200:
        GlobalService.appSnackBar(
          status: AlertStatus.success,
          desc: 'Otp send successfully',
        );
        return 1;
      default:
        GlobalService.appSnackBar(
          status: AlertStatus.warning,
          desc: 'Something went wrong',
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
        GlobalService.appSnackBar(
          status: AlertStatus.info,
          desc: serviceResponse.message,
        );
        return 0;
      case 200:
        GlobalService.appSnackBar(
          status: AlertStatus.success,
          desc: 'Otp send successfully',
        );
        return 1;
      default:
        GlobalService.appSnackBar(
          status: AlertStatus.warning,
          desc: 'Something went wrong',
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
        GlobalService.appSnackBar(
          status: AlertStatus.warning,
          desc: serviceResponse.message,
        );
        return 0;
      case 200:
        String token = serviceResponse.data['token'];
        _dioService.setToken(token);
        await _prefUtils.saveString(PrefUtils.token, token);
        GlobalService.dismissProgress();
        GlobalService.appSnackBar(
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
        GlobalService.appSnackBar(
          status: AlertStatus.success,
          desc: 'Otp sent successfully',
        );
        return 1;
      case 401:
        GlobalService.appSnackBar(
          status: AlertStatus.info,
          desc: response.message,
        );
        return 0;
      default:
        GlobalService.appSnackBar(
          status: AlertStatus.warning,
          desc: 'Something went wrong. Please try after sometime',
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
        GlobalService.appSnackBar(
            status: AlertStatus.warning, desc: serviceResponse.message);
        return 0;
      case 200:
        GlobalService.appSnackBar(
            status: AlertStatus.success, desc: serviceResponse.message);
        return 1;
      default:
        GlobalService.appSnackBar(
            status: AlertStatus.failure, desc: 'Something went wrong');
        return 0;
    }
  }
}
