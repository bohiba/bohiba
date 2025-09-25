import '../controllers/role_controller.dart';
import '/dist/app_enums.dart';
import '/services/api_end_point.dart';
import '/services/device_info_service.dart';
import '/services/dio_serivce.dart';
import '/services/global_service.dart';

import '/services/db_service.dart';

import '/model/profile_model.dart';

class ProfileService {
  static final DBService _dBService = DBService();
  static final DioService _dioService = DioService();

  static Future<int> verifyDoc({required Map<String, dynamic> bodyMap}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    ApiResponse response =
        await _dioService.post(ApiEndPoint.apiEditDoc, body: bodyMap);

    switch (response.statusCode) {
      case 200:
        VerificationModel verificationModel =
            VerificationModel.fromJson(response.data);
        ProfileModel? profileModel = await getProfile();
        profileModel!.verification = verificationModel;

        GlobalService.dismissProgress();
        return 1;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: response.message);
        return 0;
      default:
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: 'Something went wrong');
        return 0;
    }
  }

  static Future<int> setRole({required Map<String, dynamic> bodyMap}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    ApiResponse response =
        await _dioService.post(ApiEndPoint.apiSetRole, body: bodyMap);
    switch (response.statusCode) {
      case 200:
        Map<dynamic, dynamic> resMap = response.data as Map<dynamic, dynamic>;
        ProfileModel? profileModel = await getProfile();
        profileModel!.roleId = resMap['role_id'];
        int updateSucess = await updateProfile(profile: profileModel);
        GlobalService.dismissProgress();
        return updateSucess;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: response.message);
        return 0;
      default:
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: 'Something went wrong');
        return 0;
    }
  }

  static Future<int> addAddress({required Map<String, dynamic> bodyMap}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    ApiResponse response =
        await _dioService.post(ApiEndPoint.apiAddAddress, body: bodyMap);

    switch (response.statusCode) {
      case 201:
        VerificationModel verificationModel =
            VerificationModel.fromJson(response.data);
        ProfileModel? profileModel = await getProfile();
        profileModel!.verification = verificationModel;
        int updateSucess = await updateProfile(profile: profileModel);
        GlobalService.dismissProgress();
        return updateSucess;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: response.message);
        return 0;
      default:
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: 'Something went wrong');
        return 0;
    }
  }

  static Future<int> verifyEmail({required String txtEmail}) async {
    if (!GlobalService.isEmail(txtEmail)) {
      GlobalService.showAppToast(message: 'Please Enter Vaild Email.');
      return 0;
    }

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
        GlobalService.showAppToast(message: serviceResponse.message);
        return 0;
      case 200:
        GlobalService.showAppToast(message: serviceResponse.message);
        return 1;
      default:
        GlobalService.showAppToast(message: 'Something went wrong');
        return 0;
    }
  }

  static Future<ProfileModel?> getProfile(
      {MethodType type = MethodType.local}) async {
    if (type == MethodType.local) {
      return await _dBService.getData<ProfileModel>(tblProfile, profileKey);
    } else {
      if (!await DeviceInfoService.hasInternet()) {
        return null;
      }
      GlobalService.showProgress();
      await _dBService.clearAllBox();
      ApiResponse serviceResponse =
          await _dioService.get(ApiEndPoint.apiProfile);

      switch (serviceResponse.statusCode) {
        case 401:
          GlobalService.dismissProgress();
          GlobalService.showAppToast(message: serviceResponse.message);
          return null;
        case 200:
          if (serviceResponse.data == null) return null;
          ProfileModel profileModel =
              ProfileModel.fromJson(serviceResponse.data);
          int dbSuccess = await addProfile(profileModel: profileModel);
          GlobalService.dismissProgress();
          await RoleService.initRole();
          GlobalService.printHandler("Profile Added in DB: $dbSuccess");
          return profileModel;
        default:
          GlobalService.dismissProgress();
          GlobalService.showAppToast(message: 'Something went wrong');
          return null;
      }
    }
  }

  static Future<int> createUser({required Map<String, dynamic> bodyMap}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();

    ApiResponse serviceResponse = await _dioService.post(
      ApiEndPoint.apiCreateUser,
      body: bodyMap,
    );

    switch (serviceResponse.statusCode) {
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: serviceResponse.message);
        return 0;
      case 200 || 201:
        ProfileModel profile = ProfileModel.fromJson(serviceResponse.data);
        int insertSuccess = await addProfile(profileModel: profile);
        GlobalService.dismissProgress();
        return insertSuccess;
      default:
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: 'Something went wrong');
        return 0;
    }
  }

  static Future<int> addProfile({required ProfileModel profileModel}) async {
    return await _dBService.putData<ProfileModel>(
      tblProfile,
      profileKey,
      profileModel,
    );
  }

  static Future<int> updateProfile({required ProfileModel profile}) async {
    return await _dBService.putData(tblProfile, profileKey, profile);
  }
}
