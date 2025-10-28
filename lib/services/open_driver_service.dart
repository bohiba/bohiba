import 'dio_serivce.dart';
import 'api_end_point.dart';
import 'global_service.dart';
import 'device_info_service.dart';
import '/dist/app_enums.dart';
import '/model/driver_model.dart';

class OpenDriverService {
  static int _currentPage = 1;
  static int _lastPage = 1;
  static final DioService _dioService = DioService();

  static Future<List<UserModel>?> getSentReqList(
      {bool showProgress = true}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return null;
    }
    if (showProgress) GlobalService.showProgress();
    ApiResponse response = await _dioService.get(ApiEndPoint.apiAllSentReq);
    if (showProgress) GlobalService.dismissProgress();
    switch (response.statusCode) {
      case 200:
        List<UserModel> arrOpenDriver = [];
        if (response.data is List<dynamic>) {
          arrOpenDriver = UserModel.listFromJson(response.data);
        }
        return arrOpenDriver;
      case 401:
        GlobalService.showSnackBar(
          status: AlertStatus.failure,
          title: 'Connection',
          desc: response.message,
        );
        return null;
      default:
        GlobalService.showSnackBar(
          status: AlertStatus.failure,
          title: 'Connection',
          desc: 'Failed to get connection',
        );
        return null;
    }
  }

  static Future<UserModel?> getOpenDriverPrfl({required int driverId}) async {
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
        UserModel openDriver = UserModel.fromJson(response.data);
        return openDriver;
      case 401:
        GlobalService.showSnackBar(
          status: AlertStatus.failure,
          title: 'Connection',
          desc: response.message,
        );
        return null;
      default:
        GlobalService.showSnackBar(
          status: AlertStatus.failure,
          title: 'Connection',
          desc: 'Failed to get connection',
        );
        return null;
    }
  }

  static Future<List<UserModel>?> getAllOpenDriver({
    bool showProgress = true,
    bool reset = false,
  }) async {
    if (!await DeviceInfoService.hasInternet()) {
      return null;
    }
    if (reset) {
      _currentPage = 1;
      _lastPage = 1;
    }

    if (_currentPage > _lastPage) {
      return null;
    }

    if (showProgress) GlobalService.showProgress();
    ApiResponse res = await _dioService.get(ApiEndPoint.apiOpenDriver);
    if (showProgress) GlobalService.dismissProgress();
    switch (res.statusCode) {
      case 200:
        List<dynamic> arrOpenDriver = res.data;
        /*
        List<Map<String, dynamic>> arrMapOpenDriver = arrOpenDriver.map((json) {
          return DriverModel.toDB(json, isOpenDriver: true);
        }).toList();

        List<DriverModel> arrOpenDriverModel = arrMapOpenDriver.map((json) {
          return DriverModel.fromDB(json);
        }).toList();
        
        int successInsert =
            await OpenDriverService.insertAll(arrMapOpenDriver);
        if (successInsert > 0) {
        }
        */
        List<UserModel> arrOpenDriverModel = arrOpenDriver.map((driver) {
          return UserModel.fromJson(driver);
        }).toList();

        return arrOpenDriverModel;
      case 404:
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Trip',
          desc: res.message,
        );
        return null;
      default:
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Trip',
          desc: 'Failed to get jobs',
        );
        return null;
    }
  }

  static Future<UserModel?> connectDriver({
    required UserModel driverInfo,
  }) async {
    if (!await DeviceInfoService.hasInternet()) {
      return null;
    }
    GlobalService.showProgress();
    String? driverUUID = driverInfo.profile!.driverUuid ?? '';
    ApiResponse response = await _dioService.post(
      "${ApiEndPoint.apiSendConnectReq}/$driverUUID",
    );
    switch (response.statusCode) {
      case 200:
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: 'Request sent successfully');
        return await getOpenDriverPrfl(driverId: driverInfo.id!);
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: response.message);
        return null;
      default:
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: 'Something went wrong');
        return null;
    }
  }
}
