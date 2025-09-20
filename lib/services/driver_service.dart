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
  static final DioService dioService = DioService();
  static final DBService dBService = DBService();

  static Future<DriverModel?> createDriver() async {
    if (await DeviceInfoService.hasInternet()) return null;
    GlobalService.showProgress();
    ApiResponse response = await dioService.post(ApiEndPoint.apiAddDriver);
    switch (response.statusCode) {
      case 201:
        List<UserFavouriteModel> arrFav = await FavService.localFavList();
        DriverModel driver =
            DriverModel.fromJson(response.data, favList: arrFav);
        int dBSuccess = await dBService.putData<DriverModel>(
          tblDriver,
          '${driver.id}',
          driver,
        );
        ProfileModel? profile = await ProfileService.retrieveProfile();
        if (profile != null) {
          profile.drivers =
              profile.drivers == null ? 1 : (profile.drivers! + 1);
        }
        int profileUpdated =
            await ProfileService.updateProfile(profile: profile!);
        if (profileUpdated <= 0) return null;
        GlobalService.dismissProgress();
        if (dBSuccess <= 0) return null;
        GlobalService.showAppToast(message: response.message);
        return driver;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: response.message);
        return null;
      default:
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: "Failed to create truck");
        return null;
    }
  }

  static Future<List<DriverModel>?> retriveAllDriver(
      {String? pageNo, bool isInitial = false}) async {
    if (!await DeviceInfoService.hasInternet()) return null;
    GlobalService.showProgress();
    ApiResponse response =
        await dioService.get('${ApiEndPoint.apiAllDriver}?pageNo=$pageNo');

    if (isInitial) {
      await localDeleteAll();
    }

    switch (response.statusCode) {
      case 200:
        List<UserFavouriteModel> arrFavList =
            await dBService.getAllData(tblUserFav);
        List<DriverModel> arrDriverModel =
            DriverModel.listFromJson(response.data, favList: arrFavList);
        Map<String, DriverModel> driverMap = {
          for (DriverModel dm in arrDriverModel) "${dm.id}": dm
        };
        int insertDriver = await dBService.putAllData(tblDriver, driverMap);
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

  static Future<DriverModel?> retriveDriver({required String id}) async {
    if (!await DeviceInfoService.hasInternet()) return null;
    GlobalService.showProgress();
    ApiResponse response =
        await dioService.get('${ApiEndPoint.apiGetDriver}/$id');

    switch (response.statusCode) {
      case 200:
        DriverModel updatedriver = DriverModel.fromJson(response.data);
        int dbSuccess =
            await dBService.putData<DriverModel>(tblDriver, id, updatedriver);
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

  // Future<void> updateDriver() async {}

  static Future<bool> deleteDriver(
      {required int driverId, required bool isMarkedFav}) async {
    if (await DeviceInfoService.hasInternet()) return false;

    GlobalService.showProgress();
    ApiResponse serviceResponse =
        await dioService.delete("${ApiEndPoint.apiDeleteDriver}/$driverId");
    switch (serviceResponse.statusCode) {
      case 200:
        if (isMarkedFav) {
          bool isFavDeleted =
              await FavService.findDeleteFav(driverId, "drivers");
          GlobalService.printHandler('DB Delete Fav: $isFavDeleted');
        }
        int dbDeleted = await dBService.deleteData<DriverModel>(
            tblDriver, driverId.toString());

        ProfileModel? profile = await ProfileService.retrieveProfile();
        if (profile != null &&
            profile.drivers != null &&
            profile.drivers! > 0) {
          profile.drivers = profile.drivers! - 1;
        }
        int profileUpdated =
            await ProfileService.updateProfile(profile: profile!);
        GlobalService.dismissProgress();
        if (dbDeleted <= 0) return false;
        if (profileUpdated <= 0) return false;
        GlobalService.showAppToast(message: serviceResponse.message);
        return true;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: serviceResponse.message);
        return false;
      default:
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: 'Failed driverete driver.');
        return false;
    }
  }

  static Future<void> localDeleteAll() async {
    await dBService.clearBox<DriverModel>(tblDriver);
  }
}
