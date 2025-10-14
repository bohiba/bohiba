import '/dist/app_enums.dart';

import '/model/profile_model.dart';

import '/model/driver_model.dart';
import '/model/user_fav_model.dart';

import 'api_end_point.dart';
import 'device_info_service.dart';
import 'dio_serivce.dart';
import 'db_service.dart';
import 'fav_service.dart';
import 'global_service.dart';
import 'profile_service.dart';

class DriverService {
  static final DioService _dioService = DioService();
  static final DBService _dbService = DBService();

  static Future<DriverModel?> createDriver() async {
    if (await DeviceInfoService.hasInternet()) return null;
    GlobalService.showProgress();
    ApiResponse response = await _dioService.post(ApiEndPoint.apiAddDriver);
    switch (response.statusCode) {
      case 201:
        List<UserFavouriteModel> arrFav =
            await FavService.retriveAllFav() ?? [];
        DriverModel driver =
            DriverModel.fromJson(response.data, favList: arrFav);
        int dBSuccess = await _dbService.putData<DriverModel>(
          tblDriver,
          '${driver.id}',
          driver,
        );
        ProfileModel? profile = await ProfileService.getProfile();
        if (profile != null) {
          profile.drivers =
              profile.drivers == null ? 1 : (profile.drivers! + 1);
        }
        int profileUpdated =
            await ProfileService.updatelocalProfile(profile: profile!);
        if (profileUpdated <= 0) return null;
        GlobalService.dismissProgress();
        if (dBSuccess <= 0) return null;
        GlobalService.appSnackBar(
          status: AlertStatus.success,
          title: 'Driver',
          desc: response.message,
        );
        return driver;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.appSnackBar(
          status: AlertStatus.warning,
          title: 'Driver',
          desc: response.message,
        );
        return null;
      default:
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: "Failed to create truck");
        return null;
    }
  }

  static Future<List<DriverModel>?> getAllDriver({
    int pageNo = 1,
    MethodType methodType = MethodType.local,
  }) async {
    if (methodType == MethodType.local) {
      List<DriverModel> driverList = await _dbService.getAllData(tblDriver);
      return driverList;
    } else {
      if (!await DeviceInfoService.hasInternet()) return null;
      GlobalService.showProgress();
      ApiResponse response =
          await _dioService.get('${ApiEndPoint.apiAllDriver}?pageNo=$pageNo');

      switch (response.statusCode) {
        case 200:
          List<UserFavouriteModel> arrFavList =
              await _dbService.getAllData(tblUserFav);
          List<DriverModel> arrDriverModel =
              DriverModel.listFromJson(response.data, favList: arrFavList);
          Map<String, DriverModel> driverMap = {
            for (DriverModel dm in arrDriverModel) "${dm.id}": dm
          };
          int insertDriver = await _dbService.putAllData(tblDriver, driverMap);
          GlobalService.dismissProgress();
          GlobalService.showAppToast(message: response.message);
          GlobalService.printHandler('Driver insert $insertDriver');
          return arrDriverModel;
        case 401:
          GlobalService.dismissProgress();
          GlobalService.showAppToast(message: response.message);
          return null;
        default:
          GlobalService.dismissProgress();
          GlobalService.showAppToast(message: 'Failed to get trucks.');
          return null;
      }
    }
  }

  static Future<DriverModel?> getDriver(
      {required String id, MethodType type = MethodType.local}) async {
    if (type == MethodType.local) {
      DriverModel? driver =
          await _dbService.getData<DriverModel>(tblDriver, id);
      return driver;
    } else {
      if (!await DeviceInfoService.hasInternet()) return null;
      GlobalService.showProgress();
      ApiResponse response =
          await _dioService.get('${ApiEndPoint.apiGetDriver}/$id');

      switch (response.statusCode) {
        case 200:
          DriverModel updatedriver = DriverModel.fromJson(response.data);
          int dbSuccess = await _dbService.putData<DriverModel>(
              tblDriver, id, updatedriver);
          GlobalService.dismissProgress();
          if (dbSuccess <= 0) return null;
          GlobalService.showAppToast(message: response.message);
          return updatedriver;
        case 401:
          GlobalService.dismissProgress();
          GlobalService.showAppToast(message: response.message);
          return null;
        default:
          GlobalService.dismissProgress();
          GlobalService.showAppToast(
              message: 'Failed to retrive driver information');
          return null;
      }
    }
  }

  static Future<bool> deleteDriver(
      {required int driverId, required bool isMarkedFav}) async {
    if (await DeviceInfoService.hasInternet()) return false;

    GlobalService.showProgress();
    ApiResponse serviceResponse =
        await _dioService.delete("${ApiEndPoint.apiDeleteDriver}/$driverId");
    switch (serviceResponse.statusCode) {
      case 200:
        if (isMarkedFav) {
          bool isFavDeleted =
              await FavService.findDeleteFav(driverId, "drivers");
          GlobalService.printHandler('DB Delete Fav: $isFavDeleted');
        }
        int dbDeleted = await _dbService.deleteData<DriverModel>(
            tblDriver, driverId.toString());

        ProfileModel? profile = await ProfileService.getProfile();
        if (profile != null &&
            profile.drivers != null &&
            profile.drivers! > 0) {
          profile.drivers = profile.drivers! - 1;
        }
        int profileUpdated =
            await ProfileService.updatelocalProfile(profile: profile!);
        GlobalService.dismissProgress();
        if (dbDeleted <= 0) return false;
        if (profileUpdated <= 0) return false;
        GlobalService.appSnackBar(
          status: AlertStatus.success,
          title: 'Driver',
          desc: serviceResponse.message,
        );
        return true;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.appSnackBar(
          status: AlertStatus.warning,
          title: 'Driver',
          desc: serviceResponse.message,
        );
        return false;
      default:
        GlobalService.dismissProgress();
        GlobalService.appSnackBar(
          status: AlertStatus.failure,
          title: 'Driver',
          desc: 'Failed driverete driver.',
        );
        return false;
    }
  }

  static Future<void> localDeleteAll() async {
    await _dbService.clearBox<DriverModel>(tblDriver);
  }
}
