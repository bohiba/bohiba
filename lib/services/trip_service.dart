import '/dist/app_enums.dart';
import '/model/truck_model.dart';

import '/model/trip_model.dart';
import '/services/api_end_point.dart';
import '/services/db_service.dart';
import '/services/device_info_service.dart';
import '/services/dio_serivce.dart';
import '/services/global_service.dart';

class TripService {
  static final DBService _dBService = DBService();
  static final DioService _dioService = DioService();

  static Future<int> addTrip(
      {required Map<String, dynamic> bodyMap,
      required TruckModel truckModel}) async {
    if (!await DeviceInfoService.hasInternet()) return 0;
    GlobalService.showProgress();
    ApiResponse apiResponse =
        await _dioService.post(ApiEndPoint.apiAddTrip, body: bodyMap);
    switch (apiResponse.statusCode) {
      case 201:
        TripModel tripModel = TripModel.fromJson(apiResponse.data);
        tripModel.driver = TripDriver(
          id: truckModel.driver?.id,
          uuid: truckModel.driver?.uuid,
          name: truckModel.driver?.name,
          mobile: truckModel.driver?.mobileNumber,
        );
        tripModel.truck = TripTruck(
          id: truckModel.id,
          regdNumber: truckModel.regdNumber,
          model: truckModel.specs?.model,
          rcVhClassDesc: truckModel.registration?.rcVhClassDesc,
        );

        int insertDb = await _dBService.putData<TripModel>(
            tblTrips, '${tripModel.id}', tripModel);
        GlobalService.dismissProgress();
        if (insertDb > 0) {
          GlobalService.showAppToast(message: apiResponse.message);
        }
        GlobalService.printHandler(apiResponse.message);
        return insertDb;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.printHandler(apiResponse.message);
        return 0;
      default:
        GlobalService.dismissProgress();
        GlobalService.printHandler(apiResponse.message);
        GlobalService.printHandler('Failed to add trip');
        return 0;
    }
  }

  static Future<List<TripModel>> retriveAllTrip(
      {int? pageNo, bool showProgress = false}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return [];
    }

    if (showProgress) {
      GlobalService.showProgress();
    }

    ApiResponse apiResponse =
        await _dioService.get('${ApiEndPoint.apiAllTrip}?page=$pageNo');

    if (showProgress) {
      GlobalService.dismissProgress();
    }

    switch (apiResponse.statusCode) {
      case 200:
        return TripModel.listFromJson(apiResponse.data);
      case 401:
        return [];
      default:
        GlobalService.printHandler('Failed to fetch trip');
        break;
    }
    return [];
  }

  static Future<int> updateTrip({
    required Map<String, dynamic> bodyMap,
    required int tripId,
  }) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    ApiResponse apiResponse = await _dioService
        .post('${ApiEndPoint.apiEditTrip}/$tripId', body: bodyMap);
    GlobalService.dismissProgress();
    switch (apiResponse.statusCode) {
      case 200:
        GlobalService.showAppToast(message: apiResponse.message);
        return 1;
      case 401:
        GlobalService.printHandler(apiResponse.message);
        return 0;
      default:
        GlobalService.printHandler('Failed to update trip');
        return 0;
    }
  }

  static Future<int> deleteTrip({required int tripId}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    int deleteSucess =
        await _dBService.deleteData<TripModel>(tblTrips, "$tripId");
    if (deleteSucess > 0) {
      ApiResponse apiResponse =
          await _dioService.delete('${ApiEndPoint.apiDeleteTrip}/$tripId');
      switch (apiResponse.statusCode) {
        case 200:
          GlobalService.showAppToast(message: apiResponse.message);
        case 401:
          GlobalService.printHandler(apiResponse.message);
        default:
          GlobalService.printHandler('Failed to delete trip');
      }
      GlobalService.dismissProgress();
      return deleteSucess;
    } else {
      GlobalService.dismissProgress();
      GlobalService.printHandler('Failed to delete trip');
      return 0;
    }
  }

  static Future<int> addPayment({
    required Map<String, dynamic> bodyMap,
    required TripModel tripModel,
  }) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }

    GlobalService.showProgress();
    ApiResponse apiResponse =
        await _dioService.post(ApiEndPoint.apiAddTripPayment, body: bodyMap);

    switch (apiResponse.statusCode) {
      case 201:
        TripPayment tripPayment = TripPayment.fromJson(apiResponse.data);
        TripPayment newPayment = TripPayment(
          id: tripPayment.id,
          payerType: tripPayment.payerType,
          paymentMode: tripPayment.paymentMode,
          amount: tripPayment.amount,
          paidBy: tripPayment.paidBy,
          receivedBy: tripPayment.receivedBy,
          paymentTime: tripPayment.paymentTime,
        );
        tripModel.payments ??= [];

        tripModel.payments?.add(newPayment);
        int updateTrip = await _dBService.putData<TripModel>(
            tblTrips, '${tripModel.id}', tripModel);
        if (updateTrip > 0) {
          GlobalService.showAppToast(message: 'Payment added successfully');
        }
        GlobalService.dismissProgress();
        return updateTrip;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: apiResponse.message);
        return 0;
      default:
        GlobalService.dismissProgress();
        GlobalService.printHandler(apiResponse.message);
        return 0;
    }
  }

  static Future<int> editPayment({
    required int paymentId,
    required Map<String, dynamic> bodyMap,
  }) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    ApiResponse apiResponse = await _dioService
        .post('${ApiEndPoint.apiEditTripPayment}/$paymentId', body: bodyMap);
    GlobalService.dismissProgress();
    switch (apiResponse.statusCode) {
      case 200:
        GlobalService.showAppToast(message: 'Payment updated successfully');
        return 1;
      case 401:
        GlobalService.printHandler(apiResponse.message);
        return 0;
      default:
        GlobalService.printHandler('Failed to update trip');
        return 0;
    }
  }

  static Future<List<TripModel>> localAllTrip({String? truckNo}) async {
    List<TripModel> tripList = await _dBService.getAllData<TripModel>(tblTrips);
    List<TripModel> filterTrip = [];
    if (truckNo != null && truckNo.isNotEmpty) {
      filterTrip.addAll(
          tripList.where((truck) => truck.truck?.regdNumber == truckNo));
    } else {
      filterTrip.addAll(tripList);
    }
    return filterTrip;
  }

  static Future<TripModel?> getTrip(
      {required MethodType method, required TripModel trip}) async {
    if (method == MethodType.local) {
      return await _dBService.getData<TripModel>(
              tblTrips, trip.id.toString()) ??
          TripModel();
    } else if (method == MethodType.server) {
      if (!await DeviceInfoService.hasInternet()) {
        return null;
      }

      GlobalService.showProgress();
      ApiResponse apiResponse =
          await _dioService.get('${ApiEndPoint.apiGetTrip}/${trip.id}');

      switch (apiResponse.statusCode) {
        case 200:
          TripModel newTripModel = TripModel.fromJson(apiResponse.data);
          int insertTrip = await _dBService.putData<TripModel>(
              tblTrips, '${trip.id}', newTripModel);

          GlobalService.dismissProgress();
          if (insertTrip > 0) {
            // GlobalService.showAppToast(message: apiResponse.message);
            return newTripModel;
          }
          return null;
        case 401:
          GlobalService.dismissProgress();
          GlobalService.printHandler(apiResponse.message);
          GlobalService.showAppToast(message: apiResponse.message);
          return null;
        default:
          GlobalService.dismissProgress();
          GlobalService.showAppToast(message: 'Something went wrong');
          return null;
      }
    } else {
      return null;
    }
  }

  static Future<int> deletePayment({
    required TripModel trip,
    required int paymentId,
  }) async {
    GlobalService.showProgress();
    int deletePayment = await _dBService.deleteFromList<TripPayment>(
      hiveObject: trip,
      list: trip.payments,
      condition: (TripPayment item) => item.id == paymentId,
    );

    if (deletePayment > 0) {
      ApiResponse apiResponse = await _dioService
          .delete('${ApiEndPoint.apiDeleteTripPayment}/$paymentId');
      GlobalService.dismissProgress();
      switch (apiResponse.statusCode) {
        case 200:
          GlobalService.showAppToast(message: apiResponse.message);
          return deletePayment;
        case 401:
          GlobalService.printHandler(apiResponse.message);
          break;
        default:
          GlobalService.showAppToast(message: 'Something went wrong');
          break;
      }
      return 0;
    } else {
      GlobalService.showAppToast(message: 'Something went wrong');
      return 0;
    }
  }

  static Future<int> addExpense(
      {required Map<String, dynamic> bodyObj, required TripModel trip}) async {
    GlobalService.showProgress();
    ApiResponse apiResponse =
        await _dioService.post(ApiEndPoint.apiAddTripExpense, body: bodyObj);
    switch (apiResponse.statusCode) {
      case 201:
        TripExpense tripExpense = TripExpense.fromJson(apiResponse.data);
        TripExpense newExpense = TripExpense(
          id: tripExpense.id,
          addedByUuid: tripExpense.addedByUuid,
          expenseDate: tripExpense.expenseDate,
          expenseType: tripExpense.expenseType,
          paid: tripExpense.paid?.toDouble(),
          paymentMode: tripExpense.paymentMode,
          paidTo: tripExpense.paidTo,
          remarks: tripExpense.remarks,
        );
        trip.expenses ??= [];

        trip.expenses?.add(newExpense);
        int updateTrip =
            await _dBService.putData<TripModel>(tblTrips, '${trip.id}', trip);
        if (updateTrip > 0) {
          GlobalService.showAppToast(message: 'Expenses added successfully');
        }
        GlobalService.dismissProgress();
        return updateTrip;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: apiResponse.message);
        return 0;
      default:
        GlobalService.dismissProgress();
        GlobalService.printHandler(apiResponse.message);
        return 0;
    }
  }

  static Future<int> editExpense({
    required int expenseId,
    required Map<String, dynamic> bodyMap,
  }) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    ApiResponse apiResponse = await _dioService
        .post('${ApiEndPoint.apiEditTripExpense}/$expenseId', body: bodyMap);
    GlobalService.dismissProgress();
    switch (apiResponse.statusCode) {
      case 200:
        GlobalService.showAppToast(message: 'Expense updated successfully');
        return 1;
      case 401:
        GlobalService.printHandler(apiResponse.message);
        return 0;
      default:
        GlobalService.printHandler('Failed to update trip');
        return 0;
    }
  }

  static Future<int> deleteExpense({
    required TripModel trip,
    required int expenseId,
  }) async {
    GlobalService.showProgress();
    int deletePayment = await _dBService.deleteFromList<TripPayment>(
      hiveObject: trip,
      list: trip.payments,
      condition: (TripPayment item) => item.id == expenseId,
    );
    if (deletePayment > 0) {
      ApiResponse apiResponse = await _dioService
          .delete('${ApiEndPoint.apiDeleteTripExpense}/$expenseId');
      GlobalService.dismissProgress();
      switch (apiResponse.statusCode) {
        case 200:
          GlobalService.showAppToast(message: apiResponse.message);
          return deletePayment;
        case 401:
          GlobalService.printHandler(apiResponse.message);
          break;
        default:
          GlobalService.showAppToast(message: 'Something went wrong');
          break;
      }
      return 0;
    } else {
      GlobalService.showAppToast(message: 'Something went wrong');
      return 0;
    }
  }

  static Future<int> addReassignment(
      {required Map<String, dynamic> bodyObj, required TripModel trip}) async {
    GlobalService.showProgress();
    ApiResponse apiResponse =
        await _dioService.post(ApiEndPoint.apiAddTripReassign, body: bodyObj);

    switch (apiResponse.statusCode) {
      case 201:
        Reassignment reassignment = Reassignment.fromJson(apiResponse.data);
        Reassignment newReassignment = Reassignment(
          id: reassignment.id,
          regdNumber: reassignment.regdNumber,
          reason: reassignment.reason,
          date: reassignment.date,
        );
        trip.reassignment ??= [];
        trip.reassignment?.add(newReassignment);
        int updateTrip =
            await _dBService.putData<TripModel>(tblTrips, '${trip.id}', trip);
        if (updateTrip > 0) {
          GlobalService.showAppToast(message: apiResponse.message);
        }
        GlobalService.dismissProgress();
        return updateTrip;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showAppToast(message: apiResponse.message);
        return 0;
      default:
        GlobalService.dismissProgress();
        GlobalService.printHandler(apiResponse.message);
        return 0;
    }
  }

  static Future<int> editReassign({
    required int reassignId,
    required Map<String, dynamic> bodyMap,
  }) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    ApiResponse apiResponse = await _dioService
        .post('${ApiEndPoint.apiEditTripReassign}/$reassignId', body: bodyMap);
    GlobalService.dismissProgress();
    switch (apiResponse.statusCode) {
      case 200:
        GlobalService.showAppToast(message: 'Expense updated successfully');
        return 1;
      case 401:
        GlobalService.printHandler(apiResponse.message);
        return 0;
      default:
        GlobalService.printHandler('Failed to update trip');
        return 0;
    }
  }

  static Future<int> deleteReassign({
    required TripModel trip,
    required int expenseId,
  }) async {
    GlobalService.showProgress();
    int deleteReassign = await _dBService.deleteFromList<Reassignment>(
      hiveObject: trip,
      list: trip.reassignment,
      condition: (Reassignment item) => item.id == expenseId,
    );
    if (deleteReassign > 0) {
      ApiResponse apiResponse = await _dioService
          .delete('${ApiEndPoint.apiDeleteTripExpense}/$expenseId');
      GlobalService.dismissProgress();
      switch (apiResponse.statusCode) {
        case 200:
          GlobalService.showAppToast(message: apiResponse.message);
          return deleteReassign;
        case 401:
          GlobalService.printHandler(apiResponse.message);
          break;
        default:
          GlobalService.showAppToast(message: 'Something went wrong');
          break;
      }
      return 0;
    } else {
      GlobalService.showAppToast(message: 'Something went wrong');
      return 0;
    }
  }
}
