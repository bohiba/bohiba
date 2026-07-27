import 'package:bohiba/dist/enums/api_status_code.dart';

import '/model/rating_model.dart';
import '/services/rating_service.dart';
import '/services/truck_service.dart';

import '../dist/enums/app_enums.dart';
import '../model/user_model.dart';
import 'api_end_point.dart';
import 'device_info_service.dart';
import '../core/network/dio_serivce.dart';
import 'db2_service.dart';
import 'global_service.dart';
import 'profile_service.dart';

class DriverService {
  static final DioService _dioService = DioService();
  static final DatabaseService _databaseService = DatabaseService();
  static int _currentPage = 1;
  static int _lastPage = 1;

  static Future<UserModel?> createDriver(
      {required Map<String, dynamic> bodyObj, int? truckId}) async {
    if (!await DeviceInfoService.hasInternet()) return null;
    if (bodyObj['type'] == 0) {
      GlobalService.showDialog(
        status: AlertStatus.info,
        title: 'Feature Not Yet Supported',
        description:
            'Currently this feature is not support. We are working on it. Please try using `UUID`.',
      );
      return null;
    }
    GlobalService.showProgress();
    ApiResponse response =
        await _dioService.post(ApiEndPoint.apiDriver, body: bodyObj);
    StatusCode statusCode = StatusCode.fromCode(response.statusCode);
    switch (statusCode) {
      case StatusCode.ok:
      case StatusCode.created:
        UserModel driver = UserModel.fromJson(response.data);
        int insertSuccess = await insertDriver(driver: driver);
        if (insertSuccess > 0) {
          await ProfileService.updateDriverNo(deleteDriver: false);
        }
        if (truckId != null) {
          await TruckService.assignDriver(truckId: truckId, driver: driver);
        }
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.success,
          title: 'Driver',
          desc: response.message,
        );
        return driver;
      case StatusCode.badRequest:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Driver',
          desc: response.errorMessage,
          showTimer: 10,
        );
        return null;
      default:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.failure,
          title: 'Driver',
          desc: 'Failed to add driver',
        );
        return null;
    }
  }

  static Future<List<UserModel>?> getAllDriver({
    bool reset = false,
    bool showProgress = false,
    MethodType methodType = MethodType.local,
  }) async {
    if (methodType == MethodType.local) {
      String strGetQuery =
          ''' SELECT id, image, uuid, name, licenseNumber FROM $tblDriver ORDER BY updatedAt DESC ''';
      List<Map<String, dynamic>> arrDriver =
          await _databaseService.executeQuery(strGetQuery) ?? [];
      List<UserModel> driverModelList = arrDriver.map((e) {
        return UserModel.fromDB(e);
      }).toList();

      return driverModelList;
    } else {
      if (!await DeviceInfoService.hasInternet()) return null;

      if (reset) {
        await DriverService.clearAllDriver();
        _currentPage = 1;
        _lastPage = 1;
      }
      if (_currentPage > _lastPage) {
        return null;
      }
      if (showProgress) GlobalService.showProgress();

      ApiResponse response = await _dioService
          .get('${ApiEndPoint.apiDriver}?pageNo=$_currentPage');

      StatusCode statusCode = StatusCode.fromCode(response.statusCode);
      switch (statusCode) {
        case StatusCode.ok:
          if (response.pagination != null) {
            Map<dynamic, dynamic> paginate = response.pagination!;
            _currentPage = paginate['current_page'] + 1;
            _lastPage = paginate['last_page'];
          }

          List<dynamic> driverList = response.data as List<dynamic>;
          List<Map<String, dynamic>> dbDriverList = driverList.map((json) {
            return UserModel.toDB(json);
          }).toList();
          int success = await insertAllDriver(dbDriverList);
          if (success > 0) {
            GlobalService.printHandler('Insert Success $success');
          }
          if (showProgress) GlobalService.dismissProgress();
          List<UserModel> model = dbDriverList.map((json) {
            return UserModel.fromDB(json);
          }).toList();
          return model;
        case StatusCode.unauthorized:
          if (showProgress) GlobalService.dismissProgress();
          GlobalService.showSnackBar(
            status: AlertStatus.warning,
            title: 'Driver',
            desc: response.message,
          );
          return null;
        default:
          if (showProgress) GlobalService.dismissProgress();
          GlobalService.showSnackBar(
            status: AlertStatus.failure,
            title: 'Driver',
            desc: 'Failed to get trucks',
          );
          return null;
      }
    }
  }

  static Future<UserModel?> getDriver(
      {required int id, MethodType type = MethodType.local}) async {
    if (type == MethodType.local) {
      String strGetDriver =
          ''' SELECT * FROM $tblDriver WHERE id = $id LIMIT 1 ''';
      List<Map<String, dynamic>> driverList =
          await _databaseService.executeQuery(strGetDriver) ?? [];

      if (driverList.isNotEmpty) {
        UserModel driver = UserModel.fromDB(driverList.first);
        final String? uuid = driver.profile?.driverUuid;
        if (uuid != null && uuid.isNotEmpty) {
          driver.rating = await RatingService.getLatestRatingsForDriver(driverUuid: uuid);
        }
        return driver;
      } else {
        return null;
      }
    } else {
      if (!await DeviceInfoService.hasInternet()) return null;
      GlobalService.showProgress();
      ApiResponse response =
          await _dioService.get('${ApiEndPoint.apiDriver}/$id');

      switch (response.statusCode) {
        case 200:
          UserModel driver = UserModel.fromJson(response.data);
          Map driverObj = response.data;
          final String? uuid = driver.profile?.driverUuid;
          if (driverObj.containsKey('rating')) {
            List<dynamic> ratingList = driverObj['rating'];
            List<Map<String, dynamic>> arrRatingObj = ratingList.map((rating) {
              final Map<String, dynamic> r = Map<String, dynamic>.from(rating as Map);
              r['driverUuid'] = uuid;
              return RatingModel.toDB(r);
            }).toList();

            await RatingService.insertAll(ratingList: arrRatingObj);
          }
          String strUpdateQuery = '''
            UPDATE $tblDriver SET
              isFav = ${driver.isFav ?? 0},
              isSynced = ${driver.isSynced ?? 0},
              image = ${driver.profile?.image != null ? "'${driver.profile?.image}'" : 'NULL'},
              uuid = ${driver.profile?.driverUuid != null ? "'${driver.profile?.driverUuid}'" : 'NULL'},
              name = ${driver.profile?.name != null ? "'${driver.profile?.name}'" : 'NULL'},
              email = ${driver.profile?.email != null ? "'${driver.profile?.email}'" : 'NULL'},
              mobileNumber = ${driver.profile?.mobileNumber != null ? "'${driver.profile?.mobileNumber}'" : 'NULL'},
              dob = ${driver.profile?.dob != null ? "'${driver.profile?.dob}'" : 'NULL'},
              roleId = ${driver.profile?.roleId ?? 8},
              isActive = ${driver.profile?.isActive ?? 0},
              connect = ${driver.profile?.connect != null ? "'${driver.profile?.connect}'" : 'NULL'},
              verified = ${driver.address?.verified != null ? "'${driver.address?.verified}'" : 0},
              houseNo = ${driver.address?.houseNo != null ? "'${driver.address?.houseNo}'" : 'NULL'},
              locality = ${driver.address?.locality != null ? "'${driver.address?.locality}'" : 'NULL'},
              street = ${driver.address?.street != null ? "'${driver.address?.street}'" : 'NULL'},
              city = ${driver.address?.city != null ? "'${driver.address?.city}'" : 'NULL'},
              district = ${driver.address?.district != null ? "'${driver.address?.district}'" : 'NULL'},
              state = ${driver.address?.state != null ? "'${driver.address?.state}'" : 'NULL'},
              country = ${driver.address?.country != null ? "'${driver.address?.country}'" : 'NULL'},
              pinCode = ${driver.address?.pinCode != null ? "'${driver.address?.pinCode}'" : 'NULL'},
              licenseNumber = ${driver.licenseDetail?.licenseNumber != null ? "'${driver.licenseDetail?.licenseNumber}'" : 'NULL'},
              dlStatus = ${driver.licenseDetail?.status != null ? "'${driver.licenseDetail?.status}'" : 'NULL'},
              cov = ${driver.licenseDetail?.cov != null ? "'${driver.licenseDetail?.cov}'" : 'NULL'},
              rto = ${driver.licenseDetail?.rto != null ? "'${driver.licenseDetail?.rto}'" : 'NULL'},
              validFrom = ${driver.licenseDetail?.validityFrom != null ? "'${driver.licenseDetail?.validityFrom}'" : 'NULL'},
              validTill = ${driver.licenseDetail?.validityTill != null ? "'${driver.licenseDetail?.validityTill}'" : 'NULL'},
              updatedAt = ${driver.updatedAt != null ? "'${driver.updatedAt}'" : 'NULL'}
            WHERE uuid = '${driver.profile?.driverUuid}'
          ''';

          int updateSuccess = await _databaseService.updateData(strUpdateQuery);
          GlobalService.dismissProgress();
          if (updateSuccess > 0) {
            return driver;
          }
          return null;
        case 401:
          GlobalService.dismissProgress();
          GlobalService.showSnackBar(
            status: AlertStatus.warning,
            title: 'Driver',
            desc: response.message,
          );
          return null;
        default:
          GlobalService.dismissProgress();
          GlobalService.showSnackBar(
            status: AlertStatus.failure,
            title: 'Driver',
            desc: 'Failed to update driver',
          );
          return null;
      }
    }
  }

  static Future<int> deleteDriver({required int driverId}) async {
    if (!await DeviceInfoService.hasInternet()) return 0;
    GlobalService.showProgress();
    String strDelQuery = ''' DELETE FROM $tblDriver WHERE id = $driverId ''';
    int successDel = await _databaseService.delete(strDelQuery);

    if (successDel > 0) {
      ApiResponse serviceResponse =
          await _dioService.delete("${ApiEndPoint.apiDriver}/$driverId");

      StatusCode code = StatusCode.fromCode(serviceResponse.statusCode);
      switch (code) {
        case StatusCode.ok:
          await removeDriverFromTruck(driverId: driverId);
          await ProfileService.updateDriverNo(deleteDriver: true);
          GlobalService.dismissProgress();
          GlobalService.showSnackBar(
            status: AlertStatus.success,
            title: 'Driver',
            desc: serviceResponse.message,
          );
          return successDel;
        case StatusCode.badRequest:
          GlobalService.dismissProgress();
          GlobalService.showSnackBar(
            status: AlertStatus.warning,
            title: 'Driver',
            desc: serviceResponse.errorMessage,
          );
          return 0;
        default:
          GlobalService.dismissProgress();
          GlobalService.showSnackBar(
            status: AlertStatus.failure,
            title: 'Driver',
            desc: serviceResponse.errorMessage,
          );
          return 0;
      }
    } else {
      GlobalService.dismissProgress();
      GlobalService.showSnackBar(
        status: AlertStatus.failure,
        title: 'Driver',
        desc: 'Unable to delete. Driver doesn\'t exist',
      );
      return 0;
    }
  }

  static Future<int> removeDriverFromTruck({required int driverId}) async {
    String strUpdateQuery = ''' UPDATE $tblTrucks SET 
      driverId = NULL
    , driverImage = NULL
    , driverUuid = NULL
    , driverName = NULL
    , driverMobileNumber = NULL
    WHERE driverId = ? ''';

    return await _databaseService
        .updateData(strUpdateQuery, argument: [driverId]);
  }

  static Future<int> insertDriver({required UserModel driver}) async {
    String strInsertQuery = '''
          INSERT INTO $tblDriver (
            id,
            isFav,
            isSynced,
            image,
            uuid,
            name,
            email,
            mobileNumber,
            dob,
            roleId,
            isActive,
            connect,
            verified,
            houseNo,
            locality,
            street,
            city,
            district,
            state,
            country,
            pinCode,
            licenseNumber,
            dlStatus,
            cov,
            rto,
            validFrom,
            validTill,
            updatedAt
          ) VALUES (
            ${driver.id ?? 'NULL'},
            ${driver.isFav ?? 0},
            ${driver.isSynced ?? 0},
            ${driver.profile?.image != null ? "'${driver.profile!.image}'" : 'NULL'},
            ${driver.profile?.driverUuid != null ? "'${driver.profile!.driverUuid}'" : 'NULL'},
            ${driver.profile?.name != null ? "'${driver.profile!.name}'" : 'NULL'},
            ${driver.profile?.email != null ? "'${driver.profile!.email}'" : 'NULL'},
            ${driver.profile?.mobileNumber != null ? "'${driver.profile!.mobileNumber}'" : 'NULL'},
            ${driver.profile?.dob != null ? "'${driver.profile!.dob}'" : 'NULL'},
            ${driver.profile?.roleId ?? 8},
            ${driver.profile?.isActive != null ? "'${driver.profile!.isActive}'" : 'NULL'},
            ${driver.profile?.connect != null ? "'${driver.profile!.connect}'" : 'NULL'},
            ${driver.address?.verified != null ? "'${driver.address!.verified}'" : 0},
            ${driver.address?.houseNo != null ? "'${driver.address!.houseNo}'" : 'NULL'},
            ${driver.address?.locality != null ? "'${driver.address!.locality}'" : 'NULL'},
            ${driver.address?.street != null ? "'${driver.address!.street}'" : 'NULL'},
            ${driver.address?.city != null ? "'${driver.address!.city}'" : 'NULL'},
            ${driver.address?.district != null ? "'${driver.address!.district}'" : 'NULL'},
            ${driver.address?.state != null ? "'${driver.address!.state}'" : 'NULL'},
            ${driver.address?.country != null ? "'${driver.address!.country}'" : 'NULL'},
            ${driver.address?.pinCode != null ? "'${driver.address!.pinCode}'" : 'NULL'},
            ${driver.licenseDetail?.licenseNumber != null ? "'${driver.licenseDetail!.licenseNumber}'" : 'NULL'},
            ${driver.licenseDetail?.status != null ? "'${driver.licenseDetail!.status}'" : 'NULL'},
            ${driver.licenseDetail?.cov != null ? "'${driver.licenseDetail!.cov}'" : 'NULL'},
            ${driver.licenseDetail?.rto != null ? "'${driver.licenseDetail!.rto}'" : 'NULL'},
            ${driver.licenseDetail?.validityFrom != null ? "'${driver.licenseDetail!.validityFrom}'" : 'NULL'},
            ${driver.licenseDetail?.validityTill != null ? "'${driver.licenseDetail!.validityTill}'" : 'NULL'},
            ${driver.updatedAt != null ? "'${driver.updatedAt}'" : 'NULL'}
          )
          ''';
    int insertSuccess = await _databaseService.insertData(strInsertQuery);
    return insertSuccess;
  }

  static Future<int> insertAllDriver(
      List<Map<String, dynamic>> listDriver) async {
    int insert = await _databaseService.insertAllData(tblDriver, listDriver);
    return insert;
  }

  static Future<int> clearAllDriver() async {
    String strDeleteQuery = ''' DELETE FROM $tblDriver ''';
    int deleteSuccess = await _databaseService.delete(strDeleteQuery);

    if (deleteSuccess > 0) {
      GlobalService.printHandler('DELETED ALL DRIVER');
    }
    return deleteSuccess;
  }
}
