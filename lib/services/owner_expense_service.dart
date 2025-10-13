import 'package:bohiba/model/truck_model.dart';
import 'package:bohiba/services/api_end_point.dart';
import 'package:bohiba/services/db_service.dart';
import 'package:bohiba/services/device_info_service.dart';
import 'package:bohiba/services/dio_serivce.dart';
import 'package:bohiba/services/global_service.dart';
import 'package:flutter/material.dart';

class OwnerExpenseService {
  static final DBService _dBService = DBService();
  static final DioService _dioService = DioService();
 
  static int _currentPage = 1;
  static int _lastPage = 1;

  static Future<int> addOwnerExpense(
      {required Map<String, dynamic> bodyMap,
      required TruckModel truckModel}) async {
        debugPrint('Owner Expense Body Map: $bodyMap');
    if (!await DeviceInfoService.hasInternet()) return 0;
    GlobalService.showProgress();
    ApiResponse apiResponse =
        await _dioService.post(ApiEndPoint.addOwnerExpense, body: bodyMap);
    switch (apiResponse.statusCode) {
      case 201:
      debugPrint('Owner Expense Body Map: ${apiResponse.data}');
        GlobalService.dismissProgress();
        GlobalService.printHandler(apiResponse.message);
        return 1; 
      case 401:
       debugPrint('Owner Expense Body Map 401: ${apiResponse.statusCode}');
        GlobalService.dismissProgress();
        GlobalService.printHandler(apiResponse.message);
        return 0;
      default:
       debugPrint('Owner Expense Body Map: ${apiResponse.statusCode}');
        GlobalService.dismissProgress();
        GlobalService.printHandler(apiResponse.message);
        GlobalService.showAppToast(message: 'Failed to add trip');
        return 0;
    }
  }
}