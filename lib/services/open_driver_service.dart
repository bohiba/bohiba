import 'package:bohiba/dist/app_enums.dart';

import '/services/api_end_point.dart';
import '/services/device_info_service.dart';
import '/services/global_service.dart';

import 'db_service.dart';
import 'dio_serivce.dart';

import '/model/driver_model.dart';

class OpenDriverService {
  static final DBService _dbService = DBService();
  static final DioService _dioService = DioService();

  static Future<List<DriverModel>> getSentReqList() async {
    if (!await DeviceInfoService.hasInternet()) {
      return [];
    }
    GlobalService.showProgress();
    ApiResponse response = await _dioService.get(ApiEndPoint.apiAllReq);
    GlobalService.dismissProgress();
    switch (response.statusCode) {
      case 200:
        List<DriverModel> arrOpenDriver = [];
        if (response.data is List<dynamic>) {
          arrOpenDriver = DriverModel.listFromJson(response.data);
        }
        return arrOpenDriver;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: response.message);
        return [];
      default:
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: 'Something went wrong');
        return [];
    }
  }

  static Future<DriverModel?> getOpenDriverPrfl({
    required int driverId,
    MethodType type = MethodType.local,
  }) async {
    if (type == MethodType.local) {
      return await _dbService.getData<DriverModel>(tblOpenDriver, '$driverId');
    }

    if (!await DeviceInfoService.hasInternet()) {
      return null;
    }
    GlobalService.showProgress();
    ApiResponse response = await _dioService.get(
      '${ApiEndPoint.apiViewDriver}/$driverId',
    );
    GlobalService.dismissProgress();
    switch (response.statusCode) {
      case 200:
        DriverModel openDriver = DriverModel.fromJson(response.data);
        int success = await _dbService.putData<DriverModel>(
            tblOpenDriver, "${openDriver.id}", openDriver);
        if (success > 0) {
          return openDriver;
        } else {
          return null;
        }

      case 401:
        GlobalService.showAppToast(message: response.message);
        return null;
      default:
        GlobalService.showAppToast(message: 'Something went wrong');
        return null;
    }
  }

  static Future<List<DriverModel>> getAllOpenDriver() async {
    return await _dbService.getAllData<DriverModel>(tblOpenDriver);
  }

  static Future<int> connectDriver(
      {required Map<String, dynamic> bodyMap}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    ApiResponse response = await _dioService.post(
      ApiEndPoint.apiSendConnectReq,
      body: bodyMap,
    );
    switch (response.statusCode) {
      case 200:
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: 'Request sent successfully');
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
}
