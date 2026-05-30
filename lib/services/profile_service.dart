import 'dart:io';
import '/dist/enums/api_status_code.dart';

import '/services/rating_service.dart';

import 'pref_utils.dart';
import 'api_end_point.dart';
import 'device_info_service.dart';
import '/core/network/dio_serivce.dart';
import 'global_service.dart';
import 'main_service.dart';
import 'db2_service.dart';

import '/dist/enums/app_enums.dart';
import '/model/profile_model.dart';
import '/model/rating_model.dart';
import '/model/logged_in_user_model.dart';

class ProfileService {
  static final DioService _dioService = DioService();
  static final DatabaseService _databaseService = DatabaseService();
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
      // _dBService.resetAndReInitDB();
      // Clear DB while switching account
      GlobalService.printHandler("Reset Token: $token");
    }
    ProfileModel? profileModel = await getProfile(type: MethodType.api);
    Map? mainObj =
        await MainService.mainApi(type: MethodType.api, showProgress: true);

    return (mainObj != null && profileModel != null) ? 1 : 0;
  }

  static Future<int> addDocument(
      {required Map<String, dynamic> bodyMap, String? token}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    ApiResponse response = await _dioService.post(
      ApiEndPoint.apiEditDoc,
      body: bodyMap,
      headers: (token != null)
          ? {
              'Authorization': 'Bearer $token',
            }
          : null,
      withToken: token != null ? false : true,
    );

    switch (response.statusCode) {
      case 200:
        GlobalService.showSnackBar(
            status: AlertStatus.warning, desc: response.message);
        return 1;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
            status: AlertStatus.warning, desc: response.errorMessage);
        return 0;
      default:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
            status: AlertStatus.failure, desc: response.errorMessage);
        return 0;
    }
  }

  static Future<ProfileModel?> updateUserProfile(
      {required Map<String, dynamic> bodyMap}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return null;
    }
    Map<String, dynamic> bodyParam = {};
    if (bodyMap.containsKey('name')) {
      bodyParam['name'] = bodyMap['name'];
    }
    if (bodyMap.containsKey('email')) {
      bodyParam['email'] = bodyMap['email'];
    }
    if (bodyMap.containsKey('mobile_number')) {
      bodyParam['mobile_number'] = bodyMap['mobile_number'];
    }
    if (bodyMap.containsKey('role_id')) {
      bodyParam['role_id'] = bodyMap['role_id'];
    }
    if (bodyMap.containsKey('is_active')) {
      bodyParam['is_active'] = bodyMap['is_active'];
    }
    if (bodyMap.containsKey('job_status')) {
      bodyParam['job_status'] = bodyMap['job_status'];
    }

    GlobalService.showProgress();
    ApiResponse response =
        await _dioService.post(ApiEndPoint.apiEditUser, body: bodyParam);
    GlobalService.dismissProgress();
    switch (response.statusCode) {
      case 200:
        ProfileModel? profileModel = await getProfile(type: MethodType.api);
        return profileModel;
      case 400:
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Profile',
          desc: response.message,
        );
        return null;
      default:
        GlobalService.showSnackBar(
          status: AlertStatus.failure,
          title: 'Profile',
          desc: 'Failed to update profile',
        );
        return null;
    }
  }

  static Future<int> setRole({
    required Map<String, dynamic> bodyMap,
    bool initRole = false,
    String? token,
  }) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    ApiResponse response = await _dioService.post(
      ApiEndPoint.apiSetRole,
      body: bodyMap,
      headers: (token != null && token.isNotEmpty)
          ? {
              'Authorization': 'Bearer $token',
            }
          : null,
      withToken: token != null && token.isNotEmpty ? false : true,
    );
    switch (response.statusCode) {
      case 200:
        if (initRole) {
          GlobalService.dismissProgress();
          return 1;
        }
        Map<dynamic, dynamic> resMap = response.data as Map<dynamic, dynamic>;
        String updateImgQuery =
            '''UPDATE $tblProfile SET roleId = ${resMap['role_id']}''';
        int success = await _databaseService.updateData(updateImgQuery);
        GlobalService.dismissProgress();
        return success;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
            status: AlertStatus.info, desc: response.message);
        return 0;
      default:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.failure,
          title: 'Profile',
          desc: 'Failed to set role',
        );
        return 0;
    }
  }

  static Future<int> setImage({required List<File> imageFile}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    ApiResponse response = await _dioService.upload(
      ApiEndPoint.apiSetProfileImage,
      imageFile,
      fileField: 'profile_image',
    );
    GlobalService.dismissProgress();
    switch (response.statusCode) {
      case 200:
        String strQueryUpdate =
            '''UPDATE $tblProfile SET image = '${response.data}' ''';
        int updateProfile = await _databaseService.updateData(strQueryUpdate);
        if (updateProfile > 0) {
          GlobalService.showSnackBar(
              status: AlertStatus.success, desc: response.message);
          return 1;
        }
        return 0;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
            status: AlertStatus.info, desc: response.message);
        return 0;
      default:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
            status: AlertStatus.warning, desc: 'Failed to set image');
        return 0;
    }
  }

  static Future<StatusCode> addOrUpdateAddress({
    required Map<String, dynamic> bodyMap,
    bool initAddress = false,
    required String token,
  }) async {
    if (!await DeviceInfoService.hasInternet()) {
      return StatusCode.networkError;
    }
    GlobalService.showProgress();
    ApiResponse response = await _dioService.post(
      ApiEndPoint.apiAddAddress,
      body: bodyMap,
      withToken: false,
      headers: {'Authorization': 'Bearer $token'},
    );

    StatusCode statusCode = StatusCode.fromCode(response.statusCode);
    switch (statusCode) {
      case StatusCode.ok || StatusCode.created:
        if (initAddress) {
          GlobalService.dismissProgress();
          return StatusCode.noContent;
        }
        ProfileModel profile = ProfileModel.fromJson(response.data);
        String strQueryUpdate = '''UPDATE $tblProfile SET
          houseNo = '${profile.houseNo}'
        , locality = '${profile.locality}'
        , street = '${profile.street}'
        , city = '${profile.city}'
        , district = '${profile.district}'
        , state = '${profile.state}'
        , country = '${profile.country}'
        , pinCode = '${profile.pinCode}';
        ''';
        int updateProfile = await _databaseService.updateData(strQueryUpdate);
        GlobalService.dismissProgress();
        if (updateProfile > 0) return statusCode;
        return statusCode;
      default:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          desc: response.errorMessage,
        );
        return statusCode;
    }
  }

  static Future<ProfileModel?> getProfile({
    MethodType type = MethodType.local,
    bool showProgress = true,
  }) async {
    if (type == MethodType.local) {
      String strProfileQuery = ''' SELECT * FROM $tblProfile LIMIT 1''';
      List<Map<String, dynamic>> arrProfileList =
          await _databaseService.executeQuery(strProfileQuery) ?? [];
      if (arrProfileList.isNotEmpty) {
        Map<String, dynamic> profileRow = arrProfileList.first;
        ProfileModel profile = ProfileModel.fromDb(profileRow);

        String strRatingQuery =
            ''' SELECT * FROM $tblRating WHERE driverUuid = '${profileRow['uuid']}' ''';
        List<Map<String, dynamic>>? arrRatingList =
            await _databaseService.executeQuery(strRatingQuery);
        List<RatingModel> arrRatingModel = [];
        if (arrRatingList != null) {
          arrRatingModel = arrRatingList.map((e) {
            return RatingModel.fromDB(e);
          }).toList();
        }

        profile.ratings = [];
        profile.ratings!.addAll(arrRatingModel);
        return profile;
      }
      return null;
    } else {
      if (!await DeviceInfoService.hasInternet()) {
        return null;
      }
      if (showProgress) GlobalService.showProgress();
      ApiResponse res = await _dioService.get(ApiEndPoint.apiProfile);
      StatusCode statusCode = StatusCode.fromCode(res.statusCode);
      switch (statusCode) {
        case StatusCode.ok:
          if (res.data == null) return null;
          Map resObj = res.data;
          Map<String, dynamic> resMap = ProfileModel.toDB(res.data);
          List<Map>? arrProfile = await getAllProfile();
          int dbSuccess = 0;
          if (arrProfile == null || arrProfile.isEmpty) {
            dbSuccess = await addLocalProfile(profile: resMap);
          } else {
            dbSuccess = await updateLocalProfile(profile: resMap);
          }
          if (showProgress) GlobalService.dismissProgress();
          if (dbSuccess > 0) {
            ProfileModel profileModel = ProfileModel.fromDb(resMap);
            await _prefUtils.saveInt(PrefUtils.roleKey, resMap['roleId']);
            if (resObj.containsKey('ratings') &&
                resObj['ratings'] != null &&
                resObj['ratings'] is List &&
                (resObj['ratings'] as List).isNotEmpty) {
              List arrRating = resObj['ratings'];
              List<Map<String, dynamic>> arrMapRating = arrRating.map((e) {
                e['driverUuid'] = profileModel.uuid;
                return RatingModel.toDB(e);
              }).toList();

              int successInsert =
                  await RatingService.insertAll(ratingList: arrMapRating);
              if (successInsert > 0) {
                List<RatingModel> arrRatingModel = arrMapRating.map((e) {
                  return RatingModel.fromDB(e);
                }).toList();
                GlobalService.printHandler(
                    'Insert Rating into DB: $successInsert');
                profileModel.ratings = [];
                profileModel.ratings?.addAll(arrRatingModel);
              }
            }
            GlobalService.printHandler('Insert Profile into DB: $dbSuccess');
            return profileModel;
          }
          return null;
        case StatusCode.notFound:
          if (showProgress) GlobalService.dismissProgress();
          GlobalService.showSnackBar(
              status: AlertStatus.info, desc: res.message);
          return null;
        case StatusCode.unauthorized:
          if (showProgress) GlobalService.dismissProgress();
          GlobalService.showSnackBar(
              status: AlertStatus.info, desc: res.errorMessage);
          return null;
        case StatusCode.internalServerError:
          if (showProgress) GlobalService.dismissProgress();
          GlobalService.showSnackBar(
              status: AlertStatus.failure, desc: res.errorMessage);
          return null;
        default:
          if (showProgress) GlobalService.dismissProgress();
          GlobalService.showSnackBar(
              status: AlertStatus.warning, desc: res.errorMessage);
          return null;
      }
    }
  }

  static Future<String?> createUser(
      {required Map<String, dynamic> bodyMap}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return null;
    }
    GlobalService.showProgress();
    ApiResponse res =
        await _dioService.post(ApiEndPoint.apiCreateUser, body: bodyMap);

    StatusCode statusCode = StatusCode.fromCode(res.statusCode);
    switch (statusCode) {
      case StatusCode.created:
        Map<String, dynamic> resObj = res.data;
        // _dioService.setToken(resObj["token"]);
        // await _prefUtils.saveString(PrefUtils.token, resObj["token"]);
        GlobalService.dismissProgress();
        return resObj["token"] as String?;
      case StatusCode.unauthorized:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
            status: AlertStatus.info, desc: res.errorMessage);
        return null;
      default:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Set Role',
          desc: res.errorMessage,
        );
        return null;
    }
  }

  static Future<int> addLocalProfile(
      {required Map<String, dynamic> profile}) async {
    final String insertQuery = '''
    INSERT INTO $tblProfile (
      uuid, image, name, email, mobileNumber, dob, roleId, jobStatus,
      trucks, driver, panNumber, aadharNumber, dlNumber, verified,
      houseNo, locality, street, city, district, state, country, pinCode
    ) VALUES (
      '${profile['uuid'] ?? 'NULL'}', '${profile['image'] ?? 'NULL'}', '${profile['name'] ?? 'NULL'}', '${profile['email'] ?? 'NULL'}',
      '${profile['mobileNumber'] ?? ''}', '${profile['dob'] ?? ''}', ${profile['roleId'] ?? 9}, '${profile['jobStatus'] ?? ''}',
      ${profile['trucks'] ?? 0}, ${profile['driver'] ?? 0}, '${profile['panNumber'] ?? 'NULL'}', '${profile['aadharNumber'] ?? 'NULL'}',
      '${profile['dlNumber'] ?? 'NULL'}', '${profile['verified'] ?? 0}', '${profile['houseNo'] ?? 'NULL'}',
      '${profile['locality'] ?? 'NULL'}', '${profile['street'] ?? 'NULL'}', '${profile['city'] ?? 'NULL'}', '${profile['district'] ?? 'NULL'}',
      '${profile['state'] ?? 'NULL'}', '${profile['country'] ?? 'NULL'}', '${profile['pinCode'] ?? 'NULL'}'
    )
  ''';
    int insertProfile = await _databaseService.insertData(insertQuery);
    return insertProfile;
  }

  static Future<int> updateLocalProfile(
      {required Map<String, dynamic> profile}) async {
    final String updateQuery = '''
      UPDATE $tblProfile SET
        uuid = '${profile['uuid'] ?? 'NULL'}',
        image = '${profile['image'] ?? 'NULL'}',
        name = '${profile['name'] ?? 'NULL'}',
        email = '${profile['email'] ?? 'NULL'}',
        mobileNumber = '${profile['mobileNumber'] ?? 'NULL'}',
        dob = '${profile['dob'] ?? 'NULL'}',
        roleId = ${profile['roleId'] ?? 9},
        jobStatus = '${profile['jobStatus'] ?? 'NULL'}',
        trucks = ${profile['trucks'] ?? 0},
        driver = ${profile['driver'] ?? 0},
        panNumber = '${profile['panNumber'] ?? 'NULL'}',
        aadharNumber = '${profile['aadharNumber'] ?? 'NULL'}',
        dlNumber = '${profile['dlNumber'] ?? 'NULL'}',
        verified = ${profile['verified'] ?? 0},
        houseNo = '${profile['houseNo'] ?? 'NULL'}',
        locality = '${profile['locality'] ?? 'NULL'}',
        street = '${profile['street'] ?? 'NULL'}',
        city = '${profile['city'] ?? 'NULL'}',
        district = '${profile['district'] ?? 'NULL'}',
        state = '${profile['state'] ?? 'NULL'}',
        country = '${profile['country'] ?? 'NULL'}',
        pinCode = '${profile['pinCode'] ?? 'NULL'}'
      WHERE uuid = '${profile['uuid']}'
    ''';
    int updateSucess = await _databaseService.updateData(updateQuery);
    return updateSucess;
  }

  static Future<int> updateTruckNo({required bool deleteTruck}) async {
    ProfileModel? profile = await getProfile();

    if (profile == null) {
      return 0;
    }

    if (deleteTruck) {
      profile.trucks = (profile.trucks != null && profile.trucks! > 0)
          ? profile.trucks! - 1
          : 0;
    } else {
      profile.trucks = (profile.trucks == null) ? 1 : (profile.trucks! + 1);
    }

    final String strUpdateQuery =
        ''' UPDATE $tblProfile SET trucks = ${profile.trucks ?? 0} WHERE uuid = '${profile.uuid}' ''';
    int updateSuccess = await _databaseService.updateData(strUpdateQuery);
    return updateSuccess;
  }

  static Future<int> updateDriverNo({required bool deleteDriver}) async {
    ProfileModel? profile = await getProfile();
    if (profile == null) {
      return 0;
    }
    if (deleteDriver) {
      profile.driver = (profile.driver != null && profile.driver! > 0)
          ? profile.driver! - 1
          : 0;
    } else {
      profile.driver = (profile.driver == null) ? 1 : (profile.driver! + 1);
    }
    final String strUpdateQuery =
        ''' UPDATE $tblProfile SET driver = ${profile.driver ?? 0} WHERE uuid = '${profile.uuid}' ''';
    int updateSuccess = await _databaseService.updateData(strUpdateQuery);
    return updateSuccess;
  }

  static Future<List<LoggedInAccountModel>> getLoggedAccount() async {
    String strQueryList = ''' SELECT * FROM $tblLoggedInUserList ''';
    List<Map<String, dynamic>> arrLoggedInUser =
        await _databaseService.executeQuery(strQueryList) ?? [];

    List<LoggedInAccountModel> arrLoggedList = arrLoggedInUser
        .map((user) => LoggedInAccountModel(
              uuid: user['userUuid'],
              name: user['name'],
              email: user['email'],
              token: user['token'],
            ))
        .toList();
    return arrLoggedList;
  }

  static Future<int> loggedInUser({
    required LoggedInAccountModel loggedInUser,
  }) async {
    String strInsertLoggedUser = '''
    INSERT OR IGNORE INTO $tblLoggedInUserList (
    userUuid
    , name
    , email
    , roleId
    , token
    ) VALUES (
     '${loggedInUser.uuid}'
    , '${loggedInUser.name}'
    , '${loggedInUser.email}'
    , '${loggedInUser.roleId}'
    , '${loggedInUser.token}'
    );''';
    int insertUser = await _databaseService.insertData(strInsertLoggedUser);
    return insertUser;
  }

  static Future<List<Map>?> getAllProfile() async {
    String strGetQuery = ''' SELECT * FROM $tblProfile ''';
    List<Map>? arrProfile = await _databaseService.executeQuery(strGetQuery);
    return arrProfile;
  }
}
