import '/model/profile_model.dart';
import '/model/user_list_model.dart';
import '/dist/app_enums.dart';
import '/services/profile_service.dart';
import '/services/api_end_point.dart';
import '/services/device_info_service.dart';
import '/services/global_service.dart';
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
  TextEditingController emailController = TextEditingController();
  // TextEditingController? otpController;
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
    if (email.isEmpty) {
      GlobalService.showAppToast(message: 'Email is required');
      return;
    }

    int verfiedEmail = await ProfileService.verifyEmail(txtEmail: email);
    if (verfiedEmail > 0) {
      await Get.toNamed(
        AppRoute.otpScreen,
        arguments: {"email": email, "nxtRoute": AppRoute.createUser},
      );
    }
  }

  Future<void> verifyOtp({
    required String txtEmail,
    required String txtOtp,
  }) async {
    if (txtOtp.isEmpty) {
      GlobalService.showAppToast(message: 'OTP is required');
      return;
    }

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

  Future<void> registerUser({required String txtEmail}) async {
    GlobalService.closeKeyboard();
    String? valid = formValidation();
    if (valid != null) {
      GlobalService.appSnackBar(status: AlertStatus.info, desc: valid);
      return;
    }
    Map<String, dynamic> bodyObj = {
      'name': nameController.text.trim().toUpperCase(),
      'email': txtEmail,
      'mobile_number': mobileController.text.trim(),
      'dob': dateController.text.trim(),
      'password': vPwdController.text,
    };

    int result = await ProfileService.createUser(bodyMap: bodyObj);
    if (result > 0) {
      Get.offNamed(
        AppRoute.userAddressAuthScreen,
        arguments: {'email': txtEmail},
      );
    }
  }

  String? formValidation() {
    String? errTxt;
    if (nameController.text.isEmpty) {
      return errTxt = 'Name is required';
    }

    if (mobileController.text.isEmpty) {
      return errTxt = 'Mobile no. is required';
    }
    if (dateController.text.isEmpty) {
      return errTxt = 'DOB is required';
    }
    if (vPwdController.text.isEmpty || vCnfrmController.text.isEmpty) {
      return errTxt = 'Password is required';
    }
    if (vPwdController.text != vCnfrmController.text) {
      return errTxt = 'Password doesn`t match';
    }
    if (vPwdController.text.length < 6 || vCnfrmController.text.length < 6) {
      return errTxt = 'Password is too short';
    }
    return errTxt;
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
        await _dbService.clearAllBox();
        ProfileModel? loggedInUser =
            await _masterController.profileApi(methodType: MethodType.api);
        await _masterController.mainApi();
        if (loggedInUser != null) {
          // logged In User
          await ProfileService.loggedInUser(
            loggedInUser: UserListModel(
              uuid: loggedInUser.uuid,
              name: loggedInUser.name,
              email: loggedInUser.email,
              password: password,
              isLoggedIn: true,
            ),
          );
        }

        Get.offAllNamed(AppRoute.navBar);
        idController.clear();
        pwdController.clear();
        GlobalService.dismissProgress();
        break;
      default:
        GlobalService.showAppToast(message: 'Something went wrong');
        break;
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
        await _prefUtils.clearPreferencesData();
        Get.offAllNamed(AppRoute.signIn);
      default:
    }
  }

  void disposeController() {
    idController.dispose();
    pwdController.dispose();
    emailController.dispose();
    nameController.dispose();
    mobileController.dispose();
    dateController.dispose();
    vPwdController.dispose();
    vCnfrmController.dispose();
  }

  @override
  void onClose() {
    disposeController();
    super.onClose();
  }
}
