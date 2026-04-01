import 'dart:io';

import '../dist/enums/app_enums.dart';
import '../model/user_model.dart';
import '/model/profile_model.dart';
import '/model/truck_model.dart';
import 'profile_service.dart';
import 'db2_service.dart';
import 'api_end_point.dart';
import 'device_info_service.dart';
import 'dio_serivce.dart';
import 'global_service.dart';

class TruckService {
  static final DioService _dioService = DioService();
  static final DatabaseService _databaseService = DatabaseService();
  static int _currentPage = 1;
  static int _lastPage = 1;

  static Future<int> createTruck({required String vehicleNumber}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    Map<String, dynamic> bodyObj = {'registration_number': vehicleNumber};
    GlobalService.showProgress();
    ApiResponse serviceResponse = await _dioService.post(
      ApiEndPoint.apiTrucks,
      body: bodyObj,
    );

    switch (serviceResponse.statusCode) {
      case 201:
        Map<String, dynamic> resObj = TruckModel.toDB(serviceResponse.data);
        int insert = await insertTruck(dbMap: resObj);
        await ProfileService.updateTruckNo(deleteTruck: false);
        GlobalService.dismissProgress();
        if (insert > 0) {
          GlobalService.showSnackBar(
            status: AlertStatus.success,
            title: 'Truck',
            desc: serviceResponse.message,
          );
        }
        return insert;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showDialog(
          status: AlertStatus.info,
          title: 'Truck',
          description: serviceResponse.message,
        );
        return 0;
      default:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.failure,
          desc: 'Failed to add truck',
        );
        return 0;
    }
  }

  static Future<List<TruckModel>?> getTruckList({
    bool reset = false,
    bool showProgress = false,
    MethodType type = MethodType.local,
  }) async {
    if (type == MethodType.local) {
      if (showProgress) GlobalService.showProgress();
      String strQueryTruckList = ''' SELECT 
            id
          , image
          , vhNumber
          , driverUuid
          , driverName
          , ownerUuid
          , ownerName
           FROM $tblTrucks ORDER BY createdAt DESC ''';
      List<Map<String, dynamic>> truckList = await _databaseService.executeQuery(strQueryTruckList) ?? [];
      if (showProgress) GlobalService.dismissProgress();
      if (truckList.isNotEmpty) {
        List<TruckModel> arrTruckModel = truckList.map((db) {
          return TruckModel.fromDB(db);
        }).toList();
        return arrTruckModel;
      }
      return null;
    } else {
      if (!await DeviceInfoService.hasInternet()) return [];

      if (reset) {
        await clearAllTrucks();
        _currentPage = 1;
        _lastPage = 1;
      }
      if (_currentPage > _lastPage) {
        return [];
      }
      if (showProgress) GlobalService.showProgress();
      ApiResponse res = await _dioService.get('${ApiEndPoint.apiTrucks}?page=$_currentPage');
      switch (res.statusCode) {
        case 200:
          List<dynamic> truckList = res.data as List;
          List<Map<String, dynamic>> dbTruckList = truckList.map((json) {
            return TruckModel.toDB(json);
          }).toList();

          int insertTruck = await TruckService.insertAll(dbTruckList);
          if (insertTruck > 0) {
            List<TruckModel> arrTruckModel = dbTruckList.map((json) {
              return TruckModel.fromDB(json);
            }).toList();
            return arrTruckModel;
          }
          if (showProgress) GlobalService.dismissProgress();
          return null;
        case 401:
          if (showProgress) GlobalService.dismissProgress();
          GlobalService.showSnackBar(
            status: AlertStatus.warning,
            title: 'Truck',
            desc: res.message,
          );
          return null;
        default:
          if (showProgress) GlobalService.dismissProgress();
          GlobalService.showSnackBar(
            status: AlertStatus.warning,
            title: 'Truck',
            desc: 'Failed to get trucks',
          );
          return null;
      }
    }
  }

  static Future<TruckModel?> getTruck({
    dynamic value,
    int type = 1,
    MethodType methodType = MethodType.local,
  }) async {
    if (methodType == MethodType.local) {
      String strGetQuery = '';
      if (type == 1) {
        strGetQuery = ''' SELECT * FROM $tblTrucks WHERE id = $value; ''';
      } else {
        strGetQuery = ''' SELECT * FROM $tblTrucks WHERE vhNumber = '$value'; ''';
      }
      GlobalService.showProgress();
      List<Map<String, dynamic>> arrTruckList = await _databaseService.executeQuery(strGetQuery) ?? [];
      GlobalService.dismissProgress();
      if (arrTruckList.isNotEmpty) {
        TruckModel truckModel = TruckModel.fromDB(arrTruckList.first);
        return truckModel;
      }

      return null;
    } else {
      if (!await DeviceInfoService.hasInternet()) return null;
      GlobalService.showProgress();
      ApiResponse apiRes = await _dioService.get("${ApiEndPoint.apiGetTruck}?value=$value&type=$type");

      switch (apiRes.statusCode) {
        case 200:
          Map<String, dynamic> dbMap = TruckModel.toDB(apiRes.data);
          String strUpdateQuery = '''
              UPDATE $tblTrucks SET
                  isFav = ${dbMap['isFav']}
                , image = '${dbMap['image']}'
                , vhNumber = '${dbMap['vhNumber']}'
                , driverId = ${dbMap['driverId'] ?? 'NULL'}
                , driverUuid = ${dbMap['driverUuid'] == null ? 'NULL' : "'${dbMap['driverUuid']}'"}
                , driverName = ${dbMap['driverName'] == null ? 'NULL' : "'${dbMap['driverName']}'"}
                , driverMobileNumber = ${dbMap['driverMobileNumber'] == null ? 'NULL' : "'${dbMap['driverMobileNumber']}'"}
                , registrationPlace = '${dbMap['registrationPlace']}'
                , registrationDate = '${dbMap['registrationDate']}'
                , rcStatus = '${dbMap['rcStatus']}'
                , rcModel = '${dbMap['rcModel']}'
                , rcOwnerSr = ${dbMap['rcOwnerSr']}
                , vhDesc = '${dbMap['vhDesc']}'
                , vhBrand = '${dbMap['vhBrand']}'
                , vhModel = '${dbMap['vhModel']}'
                , vhEngineNo = '${dbMap['vhEngineNo']}'
                , vhChassisNo = '${dbMap['vhChassisNo']}'
                , vhFuelType = '${dbMap['vhFuelType']}'
                , vhUnladenWeight = '${dbMap['vhUnladenWeight']}'
                , vhFinancer = '${dbMap['vhFinancer']}'
                , vhInsuranceNo = '${dbMap['vhInsuranceNo']}'
                , vhInsuranceCompany = '${dbMap['vhInsuranceCompany']}'
                , puccUpto = '${dbMap['puccUpto']}'
                , insuranceUpto = '${dbMap['insuranceUpto']}'
                , taxUpto = '${dbMap['taxUpto']}'
                , fitnessUpto = '${dbMap['fitnessUpto']}'
                , updatedAt = '${dbMap['updatedAt']}'
              WHERE id = ${dbMap['id']};
            ''';
          int success = await _databaseService.updateData(strUpdateQuery);
          GlobalService.dismissProgress();
          if (success > 0) {
            TruckModel model = TruckModel.fromDB(dbMap);
            return model;
          }
          return null;
        case 401:
          GlobalService.dismissProgress();
          GlobalService.showAppToast(message: apiRes.message);
          return null;
        default:
          GlobalService.dismissProgress();
          GlobalService.showAppToast(message: 'Failed to delete truck.');
          return null;
      }
    }
  }

  static Future<TruckModel?> setTruckImage({
    TruckModel? oldTruck,
    required List<File> imageFile,
  }) async {
    if (oldTruck == null || !await DeviceInfoService.hasInternet()) return null;
    GlobalService.showProgress();
    Map<String, dynamic> bodyObj = {
      "regd_number": oldTruck.regdNumber,
    };
    ApiResponse apiRes = await _dioService.upload(
      ApiEndPoint.apiSetTruckImage,
      imageFile,
      fileField: 'truck_image',
      body: bodyObj,
    );

    switch (apiRes.statusCode) {
      case 200:
        oldTruck.truckImage = apiRes.data['truck_image'];
        String strUpdateQuery = ''' UPDATE $tblTrucks SET image = '${oldTruck.truckImage}' WHERE vhNumber = ?''';
        int updateTruck = await _databaseService.updateData(strUpdateQuery, argument: [
          {oldTruck.regdNumber}
        ]);
        GlobalService.dismissProgress();
        if (updateTruck <= 0) return null;
        GlobalService.showSnackBar(
          status: AlertStatus.success,
          desc: apiRes.message,
        );
        return oldTruck;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.failure,
          desc: apiRes.message,
        );
        return null;
      default:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.failure,
          desc: 'Failed to set truck image.',
        );
        return null;
    }
  }

  static Future<int> assignDriver({
    required String vhNumber,
    required UserModel driver,
  }) async {
    if (!await DeviceInfoService.hasInternet()) return 0;
    GlobalService.showProgress();
    Map<String, dynamic> bodyObj = {
      'driver_uuid': driver.profile?.driverUuid,
    };
    ApiResponse apiResponse = await _dioService.post(
      '${ApiEndPoint.apiAssignDriver}/$vhNumber',
      body: bodyObj,
    );

    GlobalService.printHandler(apiResponse.message);

    switch (apiResponse.statusCode) {
      case 200:
        String queryUpdate = ''' UPDATE $tblTrucks SET
          driverId = ${driver.id}
        , driverImage = ${driver.profile?.image != null ? "'${driver.profile?.image}'" : 'NULL'}
        , driverUuid = ${driver.profile?.driverUuid != null ? "'${driver.profile?.driverUuid}'" : 'NULL'}
        , driverName = ${driver.profile?.name != null ? "'${driver.profile?.name}'" : 'NULL'}
        , driverMobileNumber = ${driver.profile?.mobileNumber != null ? "'${driver.profile?.mobileNumber}'" : 'NULL'}
        WHERE vhNumber = ?
         ''';
        int updateSuccess = await _databaseService.updateData(
          queryUpdate,
          argument: [vhNumber],
        );
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.success,
          title: 'Truck',
          desc: apiResponse.message,
        );
        return updateSuccess;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: apiResponse.message);
        return 0;
      default:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(status: AlertStatus.failure, desc: 'Failed to assign driver.');
        return 0;
    }
  }

  static Future<int> removeDriver({required TruckModel oldTruck}) async {
    if (!await DeviceInfoService.hasInternet()) return 0;

    GlobalService.showProgress();
    ApiResponse serviceResponse = await _dioService.post('${ApiEndPoint.apiRemoveDriver}/${oldTruck.regdNumber}');

    switch (serviceResponse.statusCode) {
      case 200:
        String queryUpdate = ''' UPDATE $tblTrucks SET
          driverId = NULL
        , driverImage = NULL
        , driverUuid = NULL
        , driverName = NULL
        , driverMobileNumber = NULL
        WHERE vhNumber = ?
         ''';
        int updateSuccess = await _databaseService.updateData(
          queryUpdate,
          argument: ['${oldTruck.regdNumber}'],
        );
        GlobalService.dismissProgress();
        if (updateSuccess > 0) {
          GlobalService.showSnackBar(status: AlertStatus.success, desc: serviceResponse.message);
        }
        return updateSuccess;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(status: AlertStatus.info, desc: serviceResponse.message);
        return 0;
      default:
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: 'Failed to remove driver.');
        return 0;
    }
  }

  static Future<int> insertTruck({required Map<String, dynamic> dbMap}) async {
    String strInsertQuery = '''
    INSERT INTO $tblTrucks (
        id
      , isFav
      , image
      , vhNumber
      , driverId
      , driverUuid
      , driverName
      , driverMobileNumber
      , registrationPlace
      , registrationDate
      , rcStatus
      , rcModel
      , rcOwnerSr
      , vhDesc
      , vhBrand
      , vhModel
      , vhEngineNo
      , vhChassisNo
      , vhFuelType
      , vhUnladenWeight
      , vhFinancer
      , vhInsuranceNo
      , vhInsuranceCompany
      , insuranceUpto
      , taxUpto
      , puccUpto
      , fitnessUpto
      , updatedAt
      , createdAt
    ) VALUES (
      ${dbMap['id']}
    , ${dbMap['isFav'] ?? 0}
    , '${dbMap['image']}'
    , '${dbMap['vhNumber']}'
    ,  ${dbMap['driverId'] ?? 'NULL'}
    ,  ${dbMap['driverUuid'] ?? 'NULL'}
    ,  ${dbMap['driverName'] ?? 'NULL'}
    ,  ${dbMap['driverMobileNumber'] ?? 'NULL'}
    , '${dbMap['registrationPlace']}'
    , '${dbMap['registrationDate']}'
    , '${dbMap['rcStatus']}'
    , '${dbMap['rcModel']}'
    ,  ${dbMap['rcOwnerSr']}
    , '${dbMap['vhDesc']}'
    , '${dbMap['vhBrand']}'
    , '${dbMap['vhModel']}'
    , '${dbMap['vhEngineNo']}'
    , '${dbMap['vhChassisNo']}'
    , '${dbMap['vhFuelType']}'
    , '${dbMap['vhUnladenWeight']}'
    , '${dbMap['vhFinancer']}'
    , '${dbMap['vhInsuranceNo']}'
    , '${dbMap['vhInsuranceCompany']}'
    , '${dbMap['puccUpto']}'
    , '${dbMap['insuranceUpto']}'
    , '${dbMap['taxUpto']}'
    , '${dbMap['fitnessUpto']}'
    , '${dbMap['updatedAt']}'
    , '${dbMap['createdAt']}'
    )''';

    int insertTruck = await _databaseService.insertData(strInsertQuery);
    return insertTruck;
  }

  static Future<int> deleteTruck({required int truckId}) async {
    if (!await DeviceInfoService.hasInternet()) return 0;
    GlobalService.showProgress();
    String deleteQuery = '''DELETE FROM $tblTrucks WHERE id = $truckId;''';
    int dbDeleted = await _databaseService.delete(deleteQuery);

    if (dbDeleted > 0) {
      ApiResponse serviceResponse = await _dioService.delete("${ApiEndPoint.apiTrucks}/$truckId");
      switch (serviceResponse.statusCode) {
        case 200:
          ProfileModel? profile = await ProfileService.getProfile();
          if (profile != null && profile.trucks != null && profile.trucks! > 0) {
            profile.trucks = profile.trucks! - 1;
          }
          int profileUpdated = await ProfileService.updateTruckNo(deleteTruck: true);
          if (profileUpdated > 0) {
            // Update Profile
          }
          GlobalService.dismissProgress();
          GlobalService.showSnackBar(
            status: AlertStatus.success,
            title: 'Truck',
            desc: serviceResponse.message,
          );

          return 1;
        case 401:
          GlobalService.dismissProgress();
          GlobalService.showSnackBar(
            status: AlertStatus.warning,
            title: 'Truck',
            desc: serviceResponse.message,
          );
          return 0;
        default:
          GlobalService.dismissProgress();
          GlobalService.showSnackBar(
            status: AlertStatus.success,
            title: 'Truck',
            desc: 'Failed to add truck',
          );
          return 0;
      }
    } else {
      GlobalService.dismissProgress();
      GlobalService.showAppToast(message: 'Failed to delete truck.');
      return 0;
    }
  }

  static Future<int> insertAll(List<Map<String, dynamic>> listTruck) async {
    int insert = await _databaseService.insertAllData(tblTrucks, listTruck);
    return insert;
  }

  static Future<int> clearAllTrucks() async {
    String strDeleteQuery = ''' DELETE FROM $tblTrucks ''';
    int deleteSuccess = await _databaseService.delete(strDeleteQuery);
    if (deleteSuccess > 0) {
      GlobalService.printHandler('TABLE TRUCK CLEARED');
    }
    return deleteSuccess;
  }
}
