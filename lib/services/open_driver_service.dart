import 'dio_serivce.dart';
import 'db2_service.dart';
import 'api_end_point.dart';
import 'global_service.dart';
import 'device_info_service.dart';
import '/dist/app_enums.dart';
import '/model/driver_model.dart';

class OpenDriverService {
  static int _currentPage = 1;
  static int _lastPage = 1;
  static final DioService _dioService = DioService();
  static final DatabaseService _databaseService = DatabaseService();

  static Future<List<DriverModel>?> getSentReqList(
      {bool showProgress = true}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return null;
    }
    if (showProgress) GlobalService.showProgress();
    ApiResponse response = await _dioService.get(ApiEndPoint.apiAllReq);
    if (showProgress) GlobalService.dismissProgress();
    switch (response.statusCode) {
      case 200:
        List<DriverModel> arrOpenDriver = [];
        if (response.data is List<dynamic>) {
          arrOpenDriver = DriverModel.listFromJson(response.data);
        }
        GlobalService.showSnackBar(
          status: AlertStatus.success,
          title: 'Connection',
          desc: response.message,
        );
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

  static Future<DriverModel?> getOpenDriverPrfl({required int driverId}) async {
    /*if (type == MethodType.local) {
      String strGetQuery =
          ''' SELECT * FROM $tblOpenDriver WHERE id = $driverId ''';

      List<Map<String, dynamic>>? openDriverList =
          await _databaseService.getAllData(strGetQuery);

      if (openDriverList != null && openDriverList.isNotEmpty) {
        DriverModel driverModel = DriverModel.fromDB(openDriverList.first);
        return driverModel;
      }
      return null;
    }*/

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
        /*String strUpdateQuery = '''UPDATE $tblOpenDriver SET
          isSynced = ${openDriver.isSynced ?? 0}
        , image = '${openDriver.profile?.image ?? 'NULL'}'
        , uuid = '${openDriver.profile?.driverUuid ?? 'NULL'}'
        , name = '${openDriver.profile?.name ?? 'NULL'}'
        , email = '${openDriver.profile?.email ?? 'NULL'}'
        , mobileNumber = '${openDriver.profile?.mobileNumber ?? 'NULL'}'
        , dob = '${openDriver.profile?.dob ?? 'NULL'}'
        , roleId = ${openDriver.profile?.roleId ?? 8}
        , isActive = '${openDriver.profile?.isActive ?? 'inactive'}'
        , connect = '${openDriver.profile?.connect ?? 'NULL'}'
        , verified = '${openDriver.address?.verified ?? 'unverified'}'
        , houseNo = '${openDriver.address?.houseNo ?? 'NULL'}'
        , locality = '${openDriver.address?.locality ?? 'NULL'}'
        , street = '${openDriver.address?.street ?? 'NULL'}'
        , city = '${openDriver.address?.city ?? 'NULL'}'
        , district = '${openDriver.address?.district ?? 'NULL'}'
        , state = '${openDriver.address?.state ?? 'NULL'}'
        , country = '${openDriver.address?.country ?? 'NULL'}'
        , pinCode = '${openDriver.address?.pinCode ?? 'NULL'}'
        , licenseNumber = '${openDriver.licenseDetail?.licenseNumber ?? 'NULL'}'
        , dlStatus = '${openDriver.licenseDetail?.status ?? 'NULL'}'
        , cov = '${openDriver.licenseDetail?.cov ?? 'NULL'}'
        , rto = '${openDriver.licenseDetail?.rto ?? 'NULL'}'
        , validFrom = '${openDriver.licenseDetail?.validityFrom ?? 'NULL'}'
        , validTill = '${openDriver.licenseDetail?.validityTill ?? 'NULL'}'
        , updatedAt = '${openDriver.updatedAt ?? 'NULL'}'
        WHERE uuid = '${openDriver.profile!.driverUuid}';
        ''';
        int success = await _databaseService.updateData(strUpdateQuery);
        if (success > 0) {
          return openDriver;
        } else {
          return null;
        }*/
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

  static Future<List<DriverModel>?> getAllOpenDriver({
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
        List<DriverModel> arrOpenDriverModel = arrOpenDriver.map((driver) {
          return DriverModel.fromJson(driver);
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

  static Future<DriverModel?> connectDriver(
      {required DriverModel driverInfo}) async {
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
        driverInfo.profile!.connect = 'pending';
        // TODO: UPDATE CONNECT STATUS
        int success = 1;
        GlobalService.dismissProgress();
        if (success > 0) {
          GlobalService.showAppToast(message: 'Request sent successfully');
          return await getOpenDriverPrfl(driverId: driverInfo.id!);
        } else {
          GlobalService.showAppToast(message: 'Something went wrong');
          return null;
        }

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

  static Future<int> insertAll(
      List<Map<String, dynamic>> listOpenDriver) async {
    int insert =
        await _databaseService.insertAllData(tblOpenDriver, listOpenDriver);
    return insert;
  }

  static Future<int> clearAll() async {
    String strDeleteQuery = ''' DELETE FROM $tblOpenDriver ''';
    int deleteSuccess = await _databaseService.delete(strDeleteQuery);
    if (deleteSuccess > 0) {
      GlobalService.printHandler('TABLE OPEN DRIVER CLEARED');
    }
    return deleteSuccess;
  }
}
