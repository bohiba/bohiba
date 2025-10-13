import 'dart:io';
import '/dist/app_enums.dart';
import 'pref_utils.dart';
import 'rating_service.dart';
import 'api_end_point.dart';
import 'device_info_service.dart';
import 'dio_serivce.dart';
import 'global_service.dart';
import 'db_service.dart';
import 'main_service.dart';
import '/model/profile_model.dart';
import '../model/logged_in_user_model.dart';
import '/controllers/role_controller.dart';

class ProfileService {
  static final DBService _dBService = DBService();
  static final DioService _dioService = DioService();
  static final PrefUtils _prefUtils = PrefUtils();

  static Future<int> switchAccount({required LoggedInAccountModel user}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    if (user.token != null) {
      String token = user.token!;
      _prefUtils.clearPreferencesData();
      await _prefUtils.saveString(PrefUtils.token, token);
      _dioService.setToken(token);
      _dBService.resetAndReInitDB();
      GlobalService.printHandler("Reset Token: $token");
    }
    ProfileModel? profileModel = await getProfile(type: MethodType.api);
    Map? mainObj = await MainService.mainApi(type: MethodType.api);

    return (mainObj != null && profileModel != null) ? 1 : 0;
  }

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
        GlobalService.appSnackBar(
            status: AlertStatus.warning, desc: response.message);
        return 0;
      default:
        GlobalService.dismissProgress();
        GlobalService.appSnackBar(
            status: AlertStatus.failure, desc: 'Something went wrong');
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
        GlobalService.appSnackBar(
            status: AlertStatus.info, desc: response.message);
        return 0;
      default:
        GlobalService.dismissProgress();
        GlobalService.appSnackBar(
            status: AlertStatus.failure, desc: 'Something went wrong');
        return 0;
    }
  }

  static Future<int> setImage(
      {required String imagePath, required List<File> imageFile}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    Map<String, dynamic> bodyObj = {
      "profile_image": imagePath,
    };
    ApiResponse response = await _dioService.upload(
      ApiEndPoint.apiSetProfileImage,
      bodyObj,
      imageFile,
    );

    switch (response.statusCode) {
      case 200:
        ProfileModel? oldProfile = await getProfile();
        oldProfile!.profileImg = response.data.toString();
        int success = await updateProfile(profile: oldProfile);
        GlobalService.dismissProgress();
        return success;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.appSnackBar(
            status: AlertStatus.info, desc: response.message);
        return 0;
      default:
        GlobalService.dismissProgress();
        GlobalService.appSnackBar(
            status: AlertStatus.warning, desc: 'Something went wrong');
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
        GlobalService.appSnackBar(
            status: AlertStatus.info, desc: response.message);
        return 0;
      default:
        GlobalService.dismissProgress();
        GlobalService.appSnackBar(
            status: AlertStatus.warning, desc: 'Something went wrong');
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
      ApiResponse serviceResponse =
          await _dioService.get(ApiEndPoint.apiProfile);

      switch (serviceResponse.statusCode) {
        case 401:
          GlobalService.dismissProgress();
          GlobalService.appSnackBar(
              status: AlertStatus.info, desc: serviceResponse.message);
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
          GlobalService.appSnackBar(
              status: AlertStatus.warning, desc: 'Something went wrong');
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
        GlobalService.appSnackBar(
            status: AlertStatus.info, desc: serviceResponse.message);
        return 0;
      case 200 || 201:
        ProfileModel profile = ProfileModel.fromJson(serviceResponse.data);
        int insertSuccess = await addProfile(profileModel: profile);
        GlobalService.dismissProgress();
        return insertSuccess;
      default:
        GlobalService.dismissProgress();
        GlobalService.appSnackBar(
            status: AlertStatus.warning, desc: 'Something went wrong');
        return 0;
    }
  }

  static Future<int> addProfile({required ProfileModel profileModel}) async {
    int success = await RatingService.addAllRating(
      ratingList: profileModel.ratings ?? [],
    );
    GlobalService.printHandler("Rating Added in DB: $success");
    return await _dBService.putData<ProfileModel>(
      tblProfile,
      profileKey,
      profileModel,
    );
  }

  static Future<int> updateProfile({required ProfileModel profile}) async {
    return await _dBService.putData(tblProfile, profileKey, profile);
  }

  static Future<List<LoggedInAccountModel>> getLoggedAccount() async {
    return await _dBService
        .getAllData<LoggedInAccountModel>(tblLoggedInUserList);
  }

  static Future<int> loggedInUser(
      {required LoggedInAccountModel loggedInUser}) async {
    return await _dBService.putData<LoggedInAccountModel>(
      tblLoggedInUserList,
      "${loggedInUser.uuid}",
      loggedInUser,
    );
  }
}
