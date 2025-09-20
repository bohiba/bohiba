import 'dart:io';

import 'package:bohiba/dist/app_enums.dart';

import '/model/driver_model.dart';
import '/model/profile_model.dart';
import '/model/user_fav_model.dart';
import '/model/truck_model.dart';
import '/services/profile_service.dart';

import 'api_end_point.dart';
import 'device_info_service.dart';
import 'dio_serivce.dart';
import 'db_service.dart';
import 'fav_service.dart';
import 'global_service.dart';

class TruckService {
  static final DioService dioService = DioService();
  static final DBService dBService = DBService();

  static Future<TruckModel?> createTruck(
      {required String vehicleNumber}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return null;
    }
    Map<String, dynamic> bodyObj = {'registration_number': vehicleNumber};

    GlobalService.showProgress();
    ApiResponse serviceResponse = await dioService.post(
      ApiEndPoint.apiAddTruck,
      body: bodyObj,
    );
    GlobalService.dismissProgress();

    switch (serviceResponse.statusCode) {
      case 201:
        List<UserFavouriteModel> arrFav = await FavService.localFavList();
        TruckModel truckModel =
            TruckModel.fromJson(serviceResponse.data, favList: arrFav);
        int insertSucess = await dBService.putData<TruckModel>(
          tblTrucks,
          "${truckModel.id}",
          truckModel,
        );
        ProfileModel? profile = await ProfileService.retrieveProfile();
        if (profile != null) {
          profile.trucks = profile.trucks == null ? 1 : (profile.trucks! + 1);
        }
        int profileUpdated =
            await ProfileService.updateProfile(profile: profile!);
        if (profileUpdated <= 0) return null;
        if (insertSucess <= 0) false;
        GlobalService.showAppToast(message: serviceResponse.message);
        return truckModel;
      case 401:
        GlobalService.showAppToast(message: serviceResponse.message);
        return null;

      default:
        GlobalService.showAppToast(message: "Failed to create truck");
        return null;
    }
  }

  static Future<List<TruckModel>?> retriveAllTruck({
    String? pageNo,
    bool isInitial = false,
    MethodType method = MethodType.local,
  }) async {
    if (method == MethodType.local) {
      List<TruckModel> truckList = await dBService.getAllData(tblTrucks);
      return truckList;
    } else {
      if (!await DeviceInfoService.hasInternet()) return null;
      GlobalService.showProgress();

      if (isInitial) {
        await localDeleteAll();
        GlobalService.dismissProgress();
      }
      ApiResponse apiRes =
          await dioService.get('${ApiEndPoint.apiAllTruck}?page=$pageNo');
      switch (apiRes.statusCode) {
        case 200:
          List<TruckModel> arrTruckModel = TruckModel.listFromJson(apiRes.data);
          final Map<String, TruckModel> truckMap = {
            for (var tm in arrTruckModel) '${tm.id}': tm,
          };
          int insertSucess =
              await dBService.putAllData<TruckModel>(tblTrucks, truckMap);
          GlobalService.printHandler('Truck insert $insertSucess');
          ProfileModel? profile = await ProfileService.retrieveProfile();
          if (profile != null && profile.drivers != null) {
            profile.drivers = arrTruckModel.length;
          }
          int profileUpdated =
              await ProfileService.updateProfile(profile: profile!);
          GlobalService.dismissProgress();
          if (profileUpdated <= 0) return null;
          GlobalService.showAppToast(message: apiRes.message);
          return arrTruckModel;
        case 401:
          GlobalService.dismissProgress();
          GlobalService.showAppToast(message: apiRes.message);
          return null;
        default:
          GlobalService.dismissProgress();
          GlobalService.showAppToast(message: 'Failed to get trucks.');
          return null;
      }
    }
  }

  static Future<TruckModel?> getTruck({
    required int truckId,
    int type = 1,
    MethodType methodType = MethodType.local,
  }) async {
    if (methodType == MethodType.local) {
      GlobalService.showProgress();
      TruckModel? truck =
          await dBService.getData<TruckModel>(tblTrucks, "$truckId");
      GlobalService.dismissProgress();
      return truck;
    } else {
      if (!await DeviceInfoService.hasInternet()) return null;
      GlobalService.showProgress();
      ApiResponse apiRes = await dioService
          .delete("${ApiEndPoint.apiGetTruck}?value=$truckId&&type=$type");

      switch (apiRes.statusCode) {
        case 200:
          Map<String, dynamic> truckObj = apiRes.data as Map<String, dynamic>;
          List<UserFavouriteModel> arrFav = await FavService.localFavList();
          TruckModel truckModel =
              TruckModel.fromJson(truckObj, favList: arrFav);
          int insertTruck = await dBService.putData<TruckModel>(
            tblTrucks,
            "${truckModel.id}",
            truckModel,
          );
          GlobalService.dismissProgress();
          if (insertTruck <= 0) return null;
          return truckModel;
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

  static Future<TruckModel?> setTruckImage(
      {TruckModel? oldTruck, required String imgPath}) async {
    if (oldTruck == null || !await DeviceInfoService.hasInternet()) return null;
    GlobalService.showProgress();
    Map<String, dynamic> bodyObj = {
      'regd_number': oldTruck.regdNumber,
    };
    ApiResponse apiRes = await dioService
        .upload(ApiEndPoint.apiSetTruckImage, bodyObj, [File(imgPath)]);

    switch (apiRes.statusCode) {
      case 200:
        oldTruck.truckImage = apiRes.data['truck_image'];
        int updateTruck = await dBService.putData<TruckModel>(
            tblTrucks, '${oldTruck.id}', oldTruck);
        GlobalService.dismissProgress();
        if (updateTruck <= 0) return null;
        GlobalService.showAppToast(message: apiRes.message);
        return oldTruck;
      case 401:
        GlobalService.showAppToast(message: apiRes.message);
        return null;
      default:
        GlobalService.showAppToast(message: 'Failed to set truck image.');
        return null;
    }
  }

  static Future<void> assignDriver(
      {required TruckModel oldTruck, required DriverModel driver}) async {
    if (!await DeviceInfoService.hasInternet()) return;
    GlobalService.showProgress();
    Map<String, dynamic> bodyObj = {
      'driver_uuid': driver.profile?.driverUuid,
    };
    ApiResponse apiResponse = await dioService.post(
      '${ApiEndPoint.apiAssignDriver}/${oldTruck.regdNumber}',
      body: bodyObj,
    );
    GlobalService.dismissProgress();

    switch (apiResponse.statusCode) {
      case 200:
        TruckModel truckModel = oldTruck;
        truckModel.driver = TruckDriverModel(
          id: driver.id,
          uuid: driver.profile?.driverUuid,
          name: driver.profile?.name,
          mobileNumber: driver.profile?.mobileNumber,
        );
        int updateTruck = await dBService.putData<TruckModel>(
            tblTrucks, '${truckModel.id}', truckModel);
        if (updateTruck <= 0) return;
        GlobalService.showAppToast(message: apiResponse.message);
        break;
      case 401:
        GlobalService.showAppToast(message: apiResponse.message);
        return;
      default:
        GlobalService.showAppToast(message: 'Failed to assign driver.');
        return;
    }
  }

  static Future<void> removeDriver({required TruckModel oldTruck}) async {
    if (!await DeviceInfoService.hasInternet()) return;

    GlobalService.showProgress();
    ApiResponse serviceResponse = await dioService
        .delete("${ApiEndPoint.apiDeleteTruck}/${oldTruck.regdNumber}");
    GlobalService.dismissProgress();
    switch (serviceResponse.statusCode) {
      case 200:
        oldTruck.driver = null;
        int updateTruck = await dBService.putData<TruckModel>(
            tblTrucks, '${oldTruck.id}', oldTruck);
        if (updateTruck <= 0) return;
        GlobalService.showAppToast(message: serviceResponse.message);
        return;
      case 401:
        GlobalService.showAppToast(message: serviceResponse.message);
        return;
      default:
        GlobalService.showAppToast(message: 'Failed to remove driver.');
        return;
    }
  }

  static Future<bool> deleteTruck(
      {required int truckId, required bool isMarkedFav}) async {
    if (!await DeviceInfoService.hasInternet()) return false;

    GlobalService.showProgress();
    ApiResponse serviceResponse =
        await dioService.delete("${ApiEndPoint.apiDeleteTruck}/$truckId");
    switch (serviceResponse.statusCode) {
      case 200:
        if (isMarkedFav) {
          bool isFavDeleted = await FavService.findDeleteFav(truckId, "trucks");
          GlobalService.printHandler('DB Delete Fav: $isFavDeleted');
        }
        int dbDeleted =
            await dBService.deleteData<TruckModel>(tblTrucks, '$truckId');
        if (dbDeleted <= 0) return false;
        ProfileModel? profile = await ProfileService.retrieveProfile();
        if (profile != null && profile.trucks != null && profile.trucks! > 0) {
          profile.trucks = profile.trucks! - 1;
        }
        int profileUpdated =
            await ProfileService.updateProfile(profile: profile!);
        GlobalService.dismissProgress();
        if (profileUpdated <= 0) return false;
        GlobalService.showAppToast(message: serviceResponse.message);
        return true;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: serviceResponse.message);
        return false;
      default:
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: 'Failed to delete truck.');
        return false;
    }
  }

  static Future<int> localDeleteTruck(int id) async {
    return await dBService.deleteData(tblTrucks, "$id");
  }

  static Future<void> localDeleteAll() async {
    await dBService.clearBox<TruckModel>(tblTrucks);
  }
}
