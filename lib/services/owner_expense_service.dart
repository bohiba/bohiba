import 'package:bohiba/dist/app_enums.dart';
import 'package:bohiba/model/owner_expenses.dart';
import 'package:bohiba/model/truck_model.dart';
import 'package:bohiba/services/api_end_point.dart';
import 'package:bohiba/services/db2_service.dart';
import 'package:bohiba/services/device_info_service.dart';
import 'package:bohiba/services/dio_serivce.dart';
import 'package:bohiba/services/global_service.dart';
import 'package:flutter/material.dart';

class OwnerExpenseService {
  // static final DBService _dBService = DBService();
  static final DioService _dioService = DioService();
  static final DatabaseService _databaseService = DatabaseService();
  static int _currentPage = 1;
  static int _lastPage = 1;
  // static int _currentPage = 1;
  // static int _lastPage = 1;

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

  static Future<List<OwnerExpense>> getOwnerExpenseList({
    bool reset = false,
    bool showProgress = false,
    MethodType type = MethodType.local,
  }) async {
    if (type == MethodType.local) {
      if (showProgress) GlobalService.showProgress();
      String strQueryOwnerExpenseList =
          ''' SELECT * FROM $tblOwnerExpense ORDER BY updatedAt DESC ''';
      List<Map<String, dynamic>> ownerExpenseList =
          await _databaseService.getAllData(strQueryOwnerExpenseList) ?? [];
      if (showProgress) GlobalService.dismissProgress();
      if (ownerExpenseList.isNotEmpty) {
        List<OwnerExpense> arrOwnerExpenseModel = ownerExpenseList.map((db) {
          return OwnerExpense.fromJson(db);
        }).toList();
        return arrOwnerExpenseModel;
      }
      return [];
    } else {
      if (!await DeviceInfoService.hasInternet()) return [];

      if (reset) {
        await clearAllExpenses();
        _currentPage = 1;
        _lastPage = 1;
      }
      if (_currentPage > _lastPage) {
        return [];
      }
      if (showProgress) GlobalService.showProgress();
      ApiResponse res = await _dioService
          .get('${ApiEndPoint.allOwnerExpense}?page=$_currentPage');
      switch (res.statusCode) {
        case 200:
          debugPrint('Owner Expense List: ${res.data}');
          List<dynamic> expenseList = res.data as List;
          List<Map<String, dynamic>> dbOwnerExpList = expenseList.map((json) {
            return OwnerExpense.toDB(json);
          }).toList();

          int insertTruck = await OwnerExpenseService.insertAll(dbOwnerExpList);
          if (insertTruck > 0) {
            List<OwnerExpense> arrOwnerExpenseModel = dbOwnerExpList.map((json) {
              return OwnerExpense.fromDB(json);
            }).toList();
            return arrOwnerExpenseModel;
          }
          if (showProgress) GlobalService.dismissProgress();
          return [];
        case 401:
          if (showProgress) GlobalService.dismissProgress();
          GlobalService.showSnackBar(
            status: AlertStatus.warning,
            title: 'Expense',
            desc: res.message,
          );
          return [];
        default:
          if (showProgress) GlobalService.dismissProgress();
          GlobalService.showSnackBar(
            status: AlertStatus.warning,
            title: 'Expense',
            desc: 'Failed to get trucks',
          );
          return [];
      }
    }
  }
  static Future<int> insertAll(List<Map<String, dynamic>> listExpense) async {
    int insert = await _databaseService.insertAllData(tblOwnerExpense, listExpense);
    return insert;
  }

  static Future<int> clearAllExpenses() async {
    String strDeleteQuery = ''' DELETE FROM $tblOwnerExpense ''';
    int deleteSuccess = await _databaseService.delete(strDeleteQuery);
    if (deleteSuccess > 0) {
      GlobalService.printHandler('TABLE TRUCK CLEARED');
    }
    return deleteSuccess;
  }
}
