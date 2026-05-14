import 'package:intl/intl.dart';

import '../dist/enums/app_enums.dart';
import '/model/owner_expenses_model.dart';
import 'api_end_point.dart';
import 'db2_service.dart';
import 'device_info_service.dart';
import '../core/network/dio_serivce.dart';
import 'global_service.dart';

class OwnerExpenseService {
  // static final DBService _dBService = DBService();
  static final DioService _dioService = DioService();
  static final DatabaseService _databaseService = DatabaseService();
  static int _currentPage = 1;
  static int _lastPage = 1;
  // static int _currentPage = 1;
  // static int _lastPage = 1;

  static Future<OwnerExpense?> getExpense(
      {required int id, MethodType type = MethodType.local, bool showProgress = true}) async {
    if (type == MethodType.local) {
      String strGetQuery = ''' SELECT * FROM $tblOwnerExpense WHERE id = $id; ''';

      List<Map>? dbList = await _databaseService.executeQuery(strGetQuery);
      if (dbList == null) {
        return null;
      }
      List<OwnerExpense> arrModel = dbList.map((e) => OwnerExpense.fromDB(e)).toList();
      return arrModel.first;
    } else {
      if (showProgress) GlobalService.showProgress();
      GlobalService.showProgress();
      ApiResponse res = await _dioService.get("${ApiEndPoint.apiGetOwnerExpense}/$id");

      switch (res.statusCode) {
        case 200:
          Map resObj = res.data;
          String strUpdateQuery = ''' UPDATE $tblOwnerExpense SET 
            vhNumber = '${resObj['truck_regd']}'
            , expenseType = '${resObj['expense_type']}'
            , amount = ${resObj['amount']}
            , date = '${resObj['expense_date']}'
            , description = '${resObj['description']}'
            , severity = '${resObj['severity']}'
            , updatedAt = '${resObj['updated_at']}'
            , createdAt = '${resObj['created_at']}' WHERE id = $id ''';

          int sucess = await _databaseService.updateData(strUpdateQuery);
          if (sucess > 0) {
            OwnerExpense model = OwnerExpense.fromJson(resObj);
            return model;
          }
        case 401:
          if (showProgress) GlobalService.dismissProgress();
          GlobalService.showSnackBar(
            status: AlertStatus.failure,
            title: 'Expense',
            desc: res.message,
          );

        default:
          if (showProgress) GlobalService.dismissProgress();
          GlobalService.showSnackBar(
            status: AlertStatus.warning,
            title: 'Expense',
            desc: 'Failed to get expense',
          );
      }

      return null;
    }
  }

  static Future<int> addOwnerExpense({required Map<String, dynamic> bodyMap}) async {
    if (!await DeviceInfoService.hasInternet()) return 0;
    GlobalService.showProgress();
    ApiResponse apiResponse = await _dioService.post(ApiEndPoint.addOwnerExpense, body: bodyMap);
    switch (apiResponse.statusCode) {
      case 201:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(status: AlertStatus.success, desc: apiResponse.message);
        return 1;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(status: AlertStatus.warning, desc: apiResponse.message);
        return 0;
      default:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(status: AlertStatus.failure, desc: 'Failed to add trip');
        return 0;
    }
  }

  static Future<List<OwnerExpense>?> getOwnerExpenseList({
    bool reset = false,
    bool showProgress = true,
    MethodType type = MethodType.local,
  }) async {
    if (type == MethodType.local) {
      if (showProgress) GlobalService.showProgress();
      String strQueryOwnerExpenseList = ''' SELECT * FROM $tblOwnerExpense ORDER BY date DESC ''';
      List<Map<String, dynamic>>? ownerExpenseList = await _databaseService.executeQuery(strQueryOwnerExpenseList);
      if (showProgress) GlobalService.dismissProgress();
      if (ownerExpenseList != null || ownerExpenseList!.isNotEmpty) {
        List<OwnerExpense> arrOwnerExpenseModel = ownerExpenseList.map((db) {
          return OwnerExpense.fromDB(db);
        }).toList();
        return arrOwnerExpenseModel;
      }
      return null;
    } else {
      if (!await DeviceInfoService.hasInternet()) return [];

      if (reset) {
        await clearAll();
        _currentPage = 1;
        _lastPage = 1;
      }
      if (_currentPage > _lastPage) {
        return null;
      }
      if (showProgress) GlobalService.showProgress();
      ApiResponse res = await _dioService.get('${ApiEndPoint.allOwnerExpense}?page=$_currentPage');
      switch (res.statusCode) {
        case 200:
          List<dynamic> expenseList = res.data as List;
          List<Map<String, dynamic>> dbOwnerExpList = expenseList.map((json) {
            return OwnerExpense.toDB(json);
          }).toList();

          int insertTruck = await OwnerExpenseService.insertAll(dbOwnerExpList);
          if (showProgress) GlobalService.dismissProgress();
          if (insertTruck > 0) {
            List<OwnerExpense> arrOwnerExpenseModel = dbOwnerExpList.map((json) {
              return OwnerExpense.fromDB(json);
            }).toList();
            arrOwnerExpenseModel.sort((a, b) {
              final dateA = DateFormat('dd-MM-yyyy').parse(a.expenseDate!);
              final dateB = DateFormat('dd-MM-yyyy').parse(b.expenseDate!);
              return dateB.compareTo(dateA);
            });
            return arrOwnerExpenseModel;
          }

          return null;
        case 401:
          if (showProgress) GlobalService.dismissProgress();
          GlobalService.showSnackBar(
            status: AlertStatus.warning,
            title: 'Expense',
            desc: res.message,
          );
          return null;
        default:
          if (showProgress) GlobalService.dismissProgress();
          GlobalService.showSnackBar(
            status: AlertStatus.warning,
            title: 'Expense',
            desc: 'Failed to get trucks',
          );
          return null;
      }
    }
  }

  static Future<int> insertAll(List<Map<String, dynamic>> listExpense) async {
    int insert = await _databaseService.insertAllData(tblOwnerExpense, listExpense);
    return insert;
  }

  static Future<int> clearAll() async {
    String strDeleteQuery = ''' DELETE FROM $tblOwnerExpense ''';
    int deleteSuccess = await _databaseService.delete(strDeleteQuery);
    if (deleteSuccess > 0) {
      GlobalService.printHandler('TABLE OWNER EXPENSE CLEARED');
    }
    return deleteSuccess;
  }

  static Future<int> delete({required int id}) async {
    if (!await DeviceInfoService.hasInternet()) return 0;
    GlobalService.showProgress();
    String deleteQuery = '''DELETE FROM $tblOwnerExpense WHERE id = $id;''';
    int dbDeleted = await _databaseService.delete(deleteQuery);
    if (dbDeleted > 0) {
      ApiResponse serviceResponse = await _dioService.delete("${ApiEndPoint.deleteOwnerExpense}/$id");
      switch (serviceResponse.statusCode) {
        case 200:
          GlobalService.dismissProgress();
          GlobalService.showSnackBar(
            status: AlertStatus.success,
            title: 'Expense',
            desc: serviceResponse.message,
          );

          return dbDeleted;
        case 401:
          GlobalService.dismissProgress();
          GlobalService.showSnackBar(
            status: AlertStatus.warning,
            title: 'Expense',
            desc: serviceResponse.message,
          );
          return 0;
        default:
          GlobalService.dismissProgress();
          GlobalService.showSnackBar(
            status: AlertStatus.success,
            title: 'Expense',
            desc: 'Failed to add truck',
          );
          return 0;
      }
    } else {
      GlobalService.dismissProgress();
      GlobalService.showAppToast(message: 'Failed to delete expense.');
      return dbDeleted;
    }
  }

  static Future<int> updateExpense({int? id, required Map<String, dynamic> bodyMap}) async {
    if (!await DeviceInfoService.hasInternet()) return 0;
    GlobalService.showProgress();
    ApiResponse res = await _dioService.put(
      '${ApiEndPoint.editOwnerExpense}/$id',
      body: bodyMap,
    );
    GlobalService.printHandler(res.message.toString());

    switch (res.statusCode) {
      case 200:
        Map resObj = res.data;

        String strUpdateQuery = ''' UPDATE $tblOwnerExpense SET 
        vhNumber = '${resObj['truck_regd']}'
        , expenseType = '${resObj['expense_type']}'
        , amount = ${resObj['amount']}
        , date = '${resObj['expense_date']}'
        , description = '${resObj['description']}'
        , severity = '${resObj['severity']}'
        , updatedAt = '${resObj['updated_at']}'
        , createdAt = '${resObj['created_at']}' WHERE id = $id ''';

        int sucess = await _databaseService.updateData(strUpdateQuery);
        GlobalService.dismissProgress();
        if (sucess > 0) {
          GlobalService.showSnackBar(
            status: AlertStatus.success,
            title: 'Expense',
            desc: res.message,
          );
        }
        return sucess;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Expense',
          desc: res.message,
        );
        return 0;
      default:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.failure,
          title: 'Expense',
          desc: 'Failed to update Expense',
        );
        return 0;
    }
  }
}
