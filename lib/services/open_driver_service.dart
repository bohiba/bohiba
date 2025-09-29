import 'package:bohiba/services/api_end_point.dart';
import 'package:bohiba/services/device_info_service.dart';
import 'package:bohiba/services/global_service.dart';

import 'db_service.dart';
import 'dio_serivce.dart';

import '/model/open_driver_model.dart';

class OpenDriverService {
  static final DBService _dbService = DBService();
  static final DioService _dioService = DioService();

  static Future<List<OpenDriverModel>> getSentReqList() async {
    if (!await DeviceInfoService.hasInternet()) {
      return [];
    }
    GlobalService.showProgress();
    ApiResponse response = await _dioService.get(ApiEndPoint.apiAllReq);
    GlobalService.dismissProgress();
    switch (response.statusCode) {
      case 200:
        List<OpenDriverModel> arrOpenDriver = [];
        if (response.data is List<dynamic>) {
          arrOpenDriver = OpenDriverModel.listFromJson(response.data);
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

  static Future<Map<dynamic, dynamic>?> getOpenDriverPrfl() async {
    if (!await DeviceInfoService.hasInternet()) {
      return null;
    }
    GlobalService.showProgress();
    ApiResponse response = await _dioService.post(
      ApiEndPoint.apiSendConnectReq,
    );
    GlobalService.dismissProgress();
    switch (response.statusCode) {
      case 200:
        Map<dynamic, dynamic> result = response.data;
        return result;
      case 401:
        GlobalService.showAppToast(message: response.message);
        return null;
      default:
        GlobalService.showAppToast(message: 'Something went wrong');
        return null;
    }
  }

  static Future<List<OpenDriverModel>> getOpenDriver() async {
    return await _dbService.getAllData<OpenDriverModel>(tblOpenDriver);
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
