import 'package:bohiba/services/api_end_point.dart';
import 'package:bohiba/services/device_info_service.dart';
import 'package:bohiba/services/global_service.dart';

import 'db_service.dart';
import 'dio_serivce.dart';

import '/model/open_driver_model.dart';

class OpenDriverService {
  static final DBService _dbService = DBService();
  static final DioService _dioService = DioService();

  static Future<List<OpenDriverModel>> getOpenDriver() async {
    return await _dbService.getAllData<OpenDriverModel>(tblOpenDriver);
  }

  static Future<int> expressInternet(
      {required Map<String, dynamic> bodyMap}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    ApiResponse response = await _dioService.post(
      ApiEndPoint.apiExpressIntreset,
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
