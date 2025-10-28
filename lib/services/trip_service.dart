import 'api_end_point.dart';
import 'device_info_service.dart';
import 'dio_serivce.dart';
import 'global_service.dart';
import 'db2_service.dart';

import '/dist/app_enums.dart';
import '/model/truck_model.dart';
import '/model/trip_model.dart';
import '/extensions/bohiba_extension.dart';

class TripService {
  static final DatabaseService _databaseService = DatabaseService();
  static final DioService _dioService = DioService();

  static int _currentPage = 1;
  static int _lastPage = 1;

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
        int sucessInsert = await insertTrip(trip: tripModel);
        GlobalService.dismissProgress();
        if (sucessInsert > 0) {
          GlobalService.showSnackBar(
            status: AlertStatus.success,
            title: 'Trip',
            desc: apiResponse.message,
          );
        }
        GlobalService.printHandler(apiResponse.message);
        return sucessInsert;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Trip',
          desc: apiResponse.message,
        );
        return 0;
      default:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.failure,
          title: 'Trip',
          desc: apiResponse.message,
        );
        return 0;
    }
  }

  static Future<List<TripModel>?> getAllTrip({
    bool reset = false,
    bool showProgress = false,
    MethodType methodType = MethodType.local,
  }) async {
    if (methodType == MethodType.local) {
      String strQueryList = '''
          SELECT 
            t.*, 

            -- Reassignments
            r.id AS reassignment_id,
            r.vhNumber AS reassignment_vhNumber,
            r.reassignmentAt AS reassignment_at,
            r.reAssignVhNumber AS reassignment_newVhNumber,
            r.reason AS reassignment_reason,

            -- Expenses
            e.id AS expense_id,
            e.expenseType AS expense_type,
            e.paymentMode AS expense_paymentMode,
            e.paid AS expense_paid,
            e.paidTo AS expense_paidTo,
            e.expenseDate AS expense_date,
            e.remarks AS expense_remarks,

            -- Payments
            p.id AS payment_id,
            p.payerType AS payment_payerType,
            p.payementMode AS payment_mode,
            p.amount AS payment_amount,
            p.paidBy AS payment_paidBy,
            p.receivedBy AS payment_receivedBy,
            p.paymentTime AS payment_time,

            -- Documents
            d.id AS document_id,
            d.docType AS document_type,
            d.image AS document_image,
            d.uploadedAt AS document_uploadedAt

          FROM tblTrips t
          LEFT JOIN tblReassignment r ON t.id = r.tripId
          LEFT JOIN tblTripExpense e ON t.id = e.tripId
          LEFT JOIN tblTripPayment p ON t.id = p.tripId
          LEFT JOIN tblDocument d ON t.id = d.tripId
          ORDER BY t.id DESC;
        ''';

      List<Map<String, dynamic>>? arrTrip =
          await _databaseService.getAllData(strQueryList);
      if (arrTrip != null) {
        List<TripModel> tripList = arrTrip.map((trip) {
          return TripModel.fromDb(trip);
        }).toList();
        return tripList;
      }
      return null;
    } else {
      if (!await DeviceInfoService.hasInternet()) {
        return [];
      }

      if (reset) {
        _currentPage = 1;
        _lastPage = 1;
      }

      if (_currentPage > _lastPage) {
        // No More Data
        return [];
      }

      if (showProgress) GlobalService.showProgress();
      ApiResponse res =
          await _dioService.get('${ApiEndPoint.apiAllTrip}?page=$_currentPage');
      if (showProgress) GlobalService.dismissProgress();

      switch (res.statusCode) {
        case 200:
          if (res.pagination != null) {
            Map<dynamic, dynamic> paginate = res.pagination!;
            _currentPage = paginate['current_page'] + 1;
            _lastPage = paginate['last_page'];
          }
          List<dynamic> tripList = res.data as List;
          List<TripModel> arrTripModel = [];
          for (Map trip in tripList) {
            Map<String, dynamic> mapTrip = TripModel.toDB(trip);

            TripModel tripModel = TripModel.fromDb(mapTrip);
            int successTripInsert =
                await TripService.insertTrip(trip: tripModel);
            GlobalService.printHandler("Trip Added in DB: $successTripInsert");

            // Expense Insert
            if (trip.containsKey('expenses') &&
                trip['expenses'] != null &&
                (trip['expenses'] as List).isNotEmpty) {
              List tripExpense = trip['expenses'];
              List<Map<String, dynamic>> arrMapExpense =
                  tripExpense.map((expense) {
                return TripExpense.toDB(expense);
              }).toList();

              int successExpense = await TripService.insertTripInfo(
                tblTripExpense,
                arrMapExpense,
              );
              if (successExpense > 0) {
                List<TripExpense> tripExpenseList = arrMapExpense.map((map) {
                  return TripExpense.fromDb(map);
                }).toList();

                tripModel.expenses?.addAll(tripExpenseList);
                GlobalService.printHandler(
                    "Trip Expense in DB: $successExpense");
              }
            }

            if (trip.containsKey('payments') &&
                trip['payments'] != null &&
                (trip['payments'] as List).isNotEmpty) {
              List tripPayments = trip['payments'];
              List<Map<String, dynamic>> arrMapPayment =
                  tripPayments.map((payment) {
                return TripPayment.toDB(payment);
              }).toList();

              int successPayment = await TripService.insertTripInfo(
                tblTripPayment,
                arrMapPayment,
              );

              if (successPayment > 0) {
                List<TripPayment> tripPaymentList =
                    arrMapPayment.map((payment) {
                  return TripPayment.fromDb(payment);
                }).toList();

                tripModel.payments?.addAll(tripPaymentList);
                GlobalService.printHandler(
                    "Trip Payment in DB: $successPayment");
              }
            }

            if (trip.containsKey('documents') &&
                trip['documents'] != null &&
                (trip['documents'] as List).isNotEmpty) {
              List tripDocuments = trip['documents'];
              List<Map<String, dynamic>> arrMapDoc = tripDocuments.map((doc) {
                return TripDocument.toDB(doc);
              }).toList();

              int successDoc = await TripService.insertTripInfo(
                tblDocument,
                arrMapDoc,
              );

              if (successDoc > 0) {
                List<TripDocument> tripDocList = arrMapDoc.map((doc) {
                  return TripDocument.fromDb(doc);
                }).toList();

                tripModel.documents?.addAll(tripDocList);
                GlobalService.printHandler("Trip Doc in DB: $successDoc");
              }
            }

            if (trip.containsKey('reassignment') &&
                trip['reassignment'] != null &&
                (trip['reassignment'] as List).isNotEmpty) {
              List tripReassignment = trip['reassignment'];
              List<Map<String, dynamic>> arrMapReassign =
                  tripReassignment.map((assign) {
                return Reassignment.toDB(assign);
              }).toList();

              int successReassign = await TripService.insertTripInfo(
                tblReassignment,
                arrMapReassign,
              );

              if (successReassign > 0) {
                List<Reassignment> tripReassignList =
                    arrMapReassign.map((assign) {
                  return Reassignment.fromDb(assign);
                }).toList();

                tripModel.reassignment?.addAll(tripReassignList);
                GlobalService.printHandler(
                    "Trip Reassign in DB: $successReassign");
              }
            }

            arrTripModel.add(tripModel);
          }

          GlobalService.printHandler("Trip Added in DB: 1");
          return arrTripModel;
        case 401:
          return [];
        default:
          GlobalService.printHandler('Failed to fetch trip');
          break;
      }
      return [];
    }
  }

  static Future<TripModel?> getTrip({
    MethodType method = MethodType.local,
    bool showProgress = true,
    required int tripId,
  }) async {
    if (method == MethodType.local) {
      String strGetQuery = ''' SELECT 
        t.*,
        r.id AS reassignment_id,
        r.vhNumber AS reassignment_vhNumber,
        r.reassignmentAt AS reassignment_at,
        r.reAssignVhNumber AS reassignment_newVhNumber,
        r.reason AS reassignment_reason,
        
        e.id AS expense_id,
        e.expenseType AS expense_type,
        e.paymentMode AS expense_paymentMode,
        e.paid AS expense_paid,
        e.paidTo AS expense_paidTo,
        e.expenseDate AS expense_date,
        e.remarks AS expense_remarks,

        p.id AS payment_id,
        p.payerType AS payment_payerType,
        p.payementMode AS payment_mode,
        p.amount AS payment_amount,
        p.paidBy AS payment_paidBy,
        p.receivedBy AS payment_receivedBy,
        p.paymentTime AS payment_time,

        d.id AS document_id,
        d.docType AS document_type,
        d.image AS document_image,
        d.uploadedAt AS document_uploadedAt

        FROM tblTrips t
        LEFT JOIN tblReassignment r ON t.id = r.tripId
        LEFT JOIN tblTripExpense e ON t.id = e.tripId
        LEFT JOIN tblTripPayment p ON t.id = p.tripId
        LEFT JOIN tblDocument d ON t.id = d.tripId
        WHERE t.id = $tripId;''';

      List<Map<String, dynamic>>? arrTripList =
          await _databaseService.getAllData(strGetQuery);
      List<TripModel> tripList = [];
      if (arrTripList != null || arrTripList!.isEmpty) {
        tripList = arrTripList.map((trip) {
          return TripModel.fromDb(trip);
        }).toList();
        TripModel tripInfo = tripList.first;
        tripInfo.reassignment = arrTripList
            .where((r) =>
                r['reassignment_id'] != null ||
                r['reassignment_id'].toString().isEmpty)
            .map((r) => Reassignment(
                  id: r['reassignment_id'],
                  tripId: r['id'],
                  regdNumber: r['reassignment_vhNumber'],
                  date: r['reassignment_at'],
                  reassignVehicle: r['reassignment_newVhNumber'],
                  reason: r['reassignment_reason'],
                ))
            .toList();

        tripInfo.expenses = arrTripList
            .where((e) =>
                e['expense_id'] != null || e['expense_id'].toString().isEmpty)
            .map((expense) {
          return TripExpense(
            id: expense['expense_id'],
            tripId: expense['id'],
            expenseType: expense['expense_type'],
            paymentMode: expense['expense_paymentMode'],
            paid: expense['expense_paid'],
            paidTo: expense['expense_paidTo'],
            expenseDate: expense['expense_date'],
            remarks: expense['expense_remarks'],
          );
        }).toList();

        tripInfo.payments = arrTripList
            .where((payment) =>
                payment['payment_id'] != null ||
                payment['payment_id'].toString().isEmpty)
            .map((payment) {
          return TripPayment(
            id: payment['payment_id'],
            tripId: payment['id'],
            payerType: payment['payment_payerType'],
            paymentMode: payment['payment_mode'],
            paidBy: payment['payment_paidBy'],
            receivedBy: payment['payment_receivedBy'],
            amount: payment['payment_amount'],
            paymentTime: payment['payment_time'],
          );
        }).toList();

        tripInfo.documents = arrTripList
            .where((doc) =>
                doc['document_id'] != null ||
                doc['document_id'].toString().isEmpty)
            .map((doc) {
          return TripDocument(
              id: doc['document_id'],
              tripId: doc['id'],
              docType: doc['document_type'],
              image: doc['document_image'],
              updatedAt: doc['document_uploadedAt']);
        }).toList();

        return tripInfo;
      }
      return null;
    } else if (method == MethodType.api) {
      if (!await DeviceInfoService.hasInternet()) {
        return null;
      }

      if (showProgress) GlobalService.showProgress();
      ApiResponse res =
          await _dioService.get('${ApiEndPoint.apiGetTrip}/$tripId');

      switch (res.statusCode) {
        case 200:
          if (showProgress) GlobalService.dismissProgress();
          Map tripObj = res.data;
          Map<String, dynamic> mapTrip = TripModel.toDB(tripObj);
          String strUpdateQuery = '''
              UPDATE $tblTrips SET
                isFav = ${mapTrip['isFav'] ?? 0},
                tripCode = ${mapTrip['tripCode'] != null ? "'${mapTrip['tripCode']}'" : 'NULL'},
                tripStatus = ${mapTrip['tripStatus'] != null ? "'${mapTrip['tripStatus']}'" : 'NULL'},
                origin = ${mapTrip['origin'] != null ? "'${mapTrip['origin']}'" : 'NULL'},
                destination = ${mapTrip['destination'] != null ? "'${mapTrip['destination']}'" : 'NULL'},
                startedAt = ${mapTrip['startedAt'] != null ? "'${mapTrip['startedAt']}'" : 'NULL'},
                endedAt = ${mapTrip['endedAt'] != null ? "'${mapTrip['endedAt']}'" : 'NULL'},
                materialType = ${mapTrip['materialType'] != null ? "'${mapTrip['materialType']}'" : 'NULL'},
                loadWeight = ${mapTrip['loadWeight'] ?? 0.0},
                shortWeight = ${mapTrip['shortWeight'] ?? 0.0},
                rate = ${mapTrip['rate'] ?? 0.0},
                fnId = ${mapTrip['fnId'] ?? 'NULL'},
                fnAmount = ${mapTrip['fnAmount'] ?? 0.0},
                fnPayment = ${mapTrip['fnPayment'] ?? 0.0},
                fnExpense = ${mapTrip['fnExpense'] ?? 0.0},
                fnProfit = ${mapTrip['fnProfit'] ?? 0.0},
                vhId = ${mapTrip['vhId'] ?? 'NULL'},
                vhNumber = ${mapTrip['vhNumber'] != null ? "'${mapTrip['vhNumber']}'" : 'NULL'},
                vhModel = ${mapTrip['vhModel'] != null ? "'${mapTrip['vhModel']}'" : 'NULL'},
                vhDesc = ${mapTrip['vhDesc'] != null ? "'${mapTrip['vhDesc']}'" : 'NULL'},
                dvId = ${mapTrip['dvId'] ?? 'NULL'},
                dvUuid = ${mapTrip['dvUuid'] != null ? "'${mapTrip['dvUuid']}'" : 'NULL'},
                dvName = ${mapTrip['dvName'] != null ? "'${mapTrip['dvName']}'" : 'NULL'},
                dvMobile = ${mapTrip['dvMobile'] != null ? "'${mapTrip['dvMobile']}'" : 'NULL'},
                ownerId = ${mapTrip['ownerId'] ?? 'NULL'},
                ownerUuid = ${mapTrip['ownerUuid'] != null ? "'${mapTrip['ownerUuid']}'" : 'NULL'},
                ownerName = ${mapTrip['ownerName'] != null ? "'${mapTrip['ownerName']}'" : 'NULL'},
                ownerMobileNumber = ${mapTrip['ownerMobileNumber'] != null ? "'${mapTrip['ownerMobileNumber']}'" : 'NULL'},
                updatedAt = ${mapTrip['updatedAt'] != null ? "'${mapTrip['updatedAt']}'" : 'NULL'}
              WHERE id = $tripId;
              ''';
          int successUpdate = await _databaseService.updateData(strUpdateQuery);
          if (successUpdate > 0) {
            TripModel tripModel = TripModel();
            tripModel = TripModel.fromDb(mapTrip);
            // UPDATE payment

            // UPDATE reassignment
            List<Reassignment> arrReassigModel = [];
            if (tripObj.containsKey('reassignment') &&
                tripObj['reassignment'] != null &&
                tripObj['reassignment'] is List &&
                (tripObj['reassignment'] as List).isNotEmpty) {
              List tripReassign = tripObj['reassignment'];
              List<Map<String, dynamic>> arrMapReassign = tripReassign.map((r) {
                return Reassignment.toDB(r);
              }).toList();

              int successReassign =
                  await upsertTrip(tblReassignment, listData: arrMapReassign);
              if (successReassign > 0) {
                arrReassigModel = arrMapReassign.map((c) {
                  return Reassignment.fromDb(c);
                }).toList();
                tripModel.reassignment = [];
                tripModel.reassignment?.addAll(arrReassigModel);

                GlobalService.printHandler(
                    'Trip Reassignment Upsert $successReassign');
              }
            }

            // UPDATE expenses
            List<TripExpense> arrExpenseModel = [];
            if (tripObj.containsKey('expenses') &&
                tripObj['expenses'] != null &&
                tripObj['expenses'] is List &&
                (tripObj['expenses'] as List).isNotEmpty) {
              List tripExpense = tripObj['expenses'];
              List<Map<String, dynamic>> arrMapExpense =
                  tripExpense.map((expense) {
                return TripExpense.toDB(expense);
              }).toList();

              int successExpense =
                  await upsertTrip(tblTripExpense, listData: arrMapExpense);
              if (successExpense > 0) {
                arrExpenseModel = arrMapExpense.map((e) {
                  return TripExpense.fromDb(e);
                }).toList();
                tripModel.expenses = [];
                tripModel.expenses?.addAll(arrExpenseModel);

                GlobalService.printHandler(
                    'Trip Expenses Upsert $successExpense');
              }
            }

            // UPDATE documents
            List<TripDocument> arrDocModel = [];
            if (tripObj.containsKey('documents') &&
                tripObj['documents'] != null &&
                tripObj['documents'] is List &&
                (tripObj['documents'] as List).isNotEmpty) {
              List docList = tripObj['documents'];
              List<Map<String, dynamic>> arrMapDoc = docList.map((r) {
                return TripDocument.toDB(r);
              }).toList();

              int sucessDocInsert =
                  await upsertTrip(tblDocument, listData: arrMapDoc);
              if (sucessDocInsert > 0) {
                arrDocModel = arrMapDoc.map((e) {
                  return TripDocument.fromDb(e);
                }).toList();
                tripModel.documents = [];
                tripModel.documents?.addAll(arrDocModel);
                GlobalService.printHandler(
                    'Trip Expenses Upsert $sucessDocInsert');
              }
            }

            return tripModel;
          }
          return null;
        case 401:
          if (showProgress) GlobalService.dismissProgress();
          GlobalService.showSnackBar(
            status: AlertStatus.failure,
            title: 'Trip',
            desc: res.message,
          );
          return null;
        default:
          if (showProgress) GlobalService.dismissProgress();
          GlobalService.showSnackBar(
            status: AlertStatus.failure,
            title: 'Trip',
            desc: 'Something went wrong',
          );
          return null;
      }
    } else {
      return null;
    }
  }

  static Future<int> updateTrip({
    required Map<String, dynamic> bodyMap,
    required TripModel trip,
  }) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    ApiResponse apiResponse = await _dioService.post(
      '${ApiEndPoint.apiEditTrip}/${trip.id}',
      body: bodyMap,
    );
    switch (apiResponse.statusCode) {
      case 200:
        String strUpdateQuery = '''UPDATE $tblTrips SET 
            tripCode = '${bodyMap['trip_code']}'
          , tripStatus = '${bodyMap['trip_status']}'
          , origin = '${bodyMap['origin']}'
          , destination = '${bodyMap['destination']}'
          , startedAt = '${bodyMap['started_at']}'
          , endedAt = '${bodyMap['ended_at']}'
          , materialType = '${bodyMap['material_type']}'
          , loadWeight = ${bodyMap['load_weight'].toString().toDouble()}
          , shortWeight = ${bodyMap['short_weight'].toString().toDouble()}
          , rate = ${bodyMap['rate'].toString().toDouble()}
          , vhId = '${trip.truck?.id}'
          , vhNumber = '${trip.truck?.regdNumber}'
          , vhModel = '${trip.truck?.model}'
          , vhDesc = '${trip.truck?.rcVhClassDesc}'
          , dvId = '${trip.driver?.id}'
          , dvUuid = '${trip.driver?.uuid}'
          , dvName = '${trip.driver?.name}'
          , dvMobile = '${trip.driver?.mobile}'
          , updatedAt = '${trip.updatedAt}'
        ''';
        int updateTrip = await _databaseService.updateData(strUpdateQuery);
        GlobalService.dismissProgress();
        if (updateTrip > 0) {
          GlobalService.showSnackBar(
            status: AlertStatus.success,
            title: 'Trip',
            desc: apiResponse.message,
          );
        }
        return updateTrip;
      case 401:
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Trip',
          desc: apiResponse.message,
        );
        return 0;
      default:
        GlobalService.showSnackBar(
          status: AlertStatus.failure,
          title: 'Trip',
          desc: 'Failed to updated trip',
        );
        return 0;
    }
  }

  static Future<int> deleteTrip({required int tripId}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    String strQueryDelete =
        ''' DELETE FROM $tblReassignment WHERE id = $tripId; ''';
    int deleteSucess = await _databaseService.delete(strQueryDelete);
    if (deleteSucess > 0) {
      ApiResponse apiResponse =
          await _dioService.delete('${ApiEndPoint.apiDeleteTrip}/$tripId');
      GlobalService.dismissProgress();
      switch (apiResponse.statusCode) {
        case 200:
          GlobalService.showSnackBar(
            status: AlertStatus.success,
            title: 'Trip',
            desc: apiResponse.message,
          );
        case 401:
          GlobalService.showSnackBar(
            status: AlertStatus.warning,
            title: 'Trip',
            desc: apiResponse.message,
          );
        default:
          GlobalService.showSnackBar(
            status: AlertStatus.failure,
            title: 'Trip',
            desc: 'Failed to delete trip',
          );
      }
      return deleteSucess;
    } else {
      GlobalService.dismissProgress();
      GlobalService.showSnackBar(
        status: AlertStatus.failure,
        title: 'Trip',
        desc: 'Failed to delete trip',
      );
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
        String strQueryPayment = ''' INSERT INTO $tblTripPayment (
        , id
        , tripId
        , payerType
        , payementMode
        , amount
        , paidBy
        , receivedBy
        , paymentTime
        ) VALUES (
          ${tripPayment.id}
        , ${tripPayment.tripId}  
        , '${tripPayment.payerType}'
        , '${tripPayment.paymentMode}'
        , '${tripPayment.amount}'
        , '${tripPayment.paidBy}'
        , '${tripPayment.receivedBy}'
        , ${tripPayment.paymentTime}
        )''';
        int insertPayment = await _databaseService.insertData(strQueryPayment);
        GlobalService.dismissProgress();
        if (insertPayment > 0) {
          GlobalService.showSnackBar(
            status: AlertStatus.success,
            title: 'Payment',
            desc: 'Payment added successfully',
          );
        }
        return insertPayment;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.success,
          title: 'Payment',
          desc: apiResponse.message,
        );
        return 0;
      default:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.success,
          title: 'Payment',
          desc: 'Failed to add payment',
        );
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

    switch (apiResponse.statusCode) {
      case 200:
        TripPayment tripPayment = TripPayment.fromJson(apiResponse.data);
        String strUpdateQuery = '''
          UPDATE $tblTripPayment SET
            payerType = '${tripPayment.payerType}'
          , payementMode = '${tripPayment.paymentMode}'
          , amount = ${tripPayment.amount ?? 0.0}
          , paidBy = '${tripPayment.paidBy}'
          , receivedBy = '${tripPayment.receivedBy}'
          , paymentTime = '${tripPayment.paymentTime}'
        WHERE id = ${tripPayment.id}
        ''';
        int updatePayment = await _databaseService.updateData(strUpdateQuery);
        GlobalService.dismissProgress();
        if (updatePayment > 0) {
          GlobalService.showSnackBar(
            status: AlertStatus.success,
            title: 'Payment',
            desc: 'Payment updated successfully',
          );
        }
        return updatePayment;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Payment',
          desc: apiResponse.message,
        );
        return 0;
      default:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.failure,
          title: 'Payment',
          desc: apiResponse.message,
        );
        return 0;
    }
  }

  static Future<List<TripModel>?> filterTripWithTruckNo(
      {String? truckNo}) async {
    List<TripModel>? tripList = await getAllTrip(methodType: MethodType.local);
    if (tripList != null) {
      List<TripModel> filterTrip = [];
      if (truckNo != null && truckNo.isNotEmpty) {
        filterTrip.addAll(
            tripList.where((truck) => truck.truck?.regdNumber == truckNo));
      } else {
        filterTrip.addAll(tripList);
      }
      return filterTrip;
    }
    return null;
  }

  static Future<int> deletePayment({required int paymentId}) async {
    GlobalService.showProgress();
    String strQueryDelete =
        ''' DELETE FROM $tblTripExpense WHERE id = $paymentId; ''';
    int deletePayment = await _databaseService.delete(strQueryDelete);
    if (deletePayment > 0) {
      ApiResponse apiResponse = await _dioService
          .delete('${ApiEndPoint.apiDeleteTripPayment}/$paymentId');
      GlobalService.dismissProgress();
      switch (apiResponse.statusCode) {
        case 200:
          GlobalService.showSnackBar(
            status: AlertStatus.success,
            title: 'Payment',
            desc: apiResponse.message,
          );
          return deletePayment;
        case 401:
          GlobalService.showSnackBar(
            status: AlertStatus.warning,
            title: 'Payment',
            desc: apiResponse.message,
          );
          return 0;
        default:
          GlobalService.showSnackBar(
            status: AlertStatus.failure,
            title: 'Payment',
            desc: 'Failed to delete payment',
          );
          return 0;
      }
    } else {
      GlobalService.dismissProgress();
      GlobalService.showSnackBar(
        status: AlertStatus.failure,
        title: 'Payment',
        desc: 'Failed to delete payment',
      );
      return 0;
    }
  }

  static Future<int> addExpense({
    required Map<String, dynamic> bodyObj,
    required TripModel trip,
  }) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    ApiResponse apiResponse =
        await _dioService.post(ApiEndPoint.apiAddTripExpense, body: bodyObj);
    switch (apiResponse.statusCode) {
      case 201:
        TripExpense tripExpense = TripExpense.fromJson(apiResponse.data);
        String insertExpense = '''INSERT INTO $tblTripExpense (
            id
          , expenseType
          , paymentMode
          , paid
          , paidTo
          , expenseDate
          , remarks
        ) VALUES (
          ${tripExpense.id}
        , '${tripExpense.expenseType}'
        , '${tripExpense.paymentMode}'
        , '${tripExpense.paid}'
        , '${tripExpense.paidTo}'
        , '${tripExpense.expenseDate}'
        , '${tripExpense.remarks}'
        ); ''';
        int updateTrip = await _databaseService.insertData(insertExpense);
        GlobalService.dismissProgress();
        if (updateTrip > 0) {
          GlobalService.showSnackBar(
            status: AlertStatus.success,
            title: 'Expense',
            desc: 'Expenses added successfully',
          );
        }
        return updateTrip;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Expense',
          desc: apiResponse.message,
        );
        return 0;
      default:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.failure,
          title: 'Expense',
          desc: 'Failed to add expense',
        );
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
    switch (apiResponse.statusCode) {
      case 200:
        TripExpense tripExpense = TripExpense.fromJson(apiResponse.data);
        String strUpdateExpense = ''' UPDATE $tblTripExpense SET 
          expenseType = '${tripExpense.expenseType}
        , paymentMode = '${tripExpense.paymentMode}' 
        , paid = '${tripExpense.paid}'
        , paidTo = '${tripExpense.paidTo}'
        , expenseDate = '${tripExpense.expenseDate}'
        , remarks = '${tripExpense.remarks}' WHERE id = $expenseId AND tripId = ${tripExpense.tripId};
        ''';
        int updated = await _databaseService.updateData(strUpdateExpense);
        GlobalService.dismissProgress();
        if (updated > 0) {
          GlobalService.showSnackBar(
            status: AlertStatus.success,
            title: 'Expense',
            desc: apiResponse.message,
          );
        }
        return updated;
      case 401:
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Expense',
          desc: apiResponse.message,
        );
        GlobalService.dismissProgress();
        return 0;
      default:
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Expense',
          desc: 'Failed to edit payment',
        );
        GlobalService.dismissProgress();
        return 0;
    }
  }

  static Future<int> deleteExpense({required int expenseId}) async {
    if (await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    String strQueryDelete =
        ''' DELETE FROM $tblTripExpense WHERE id = $expenseId; ''';
    int deletePayment = await _databaseService.delete(strQueryDelete);
    if (deletePayment > 0) {
      ApiResponse apiResponse = await _dioService
          .delete('${ApiEndPoint.apiDeleteTripExpense}/$expenseId');
      GlobalService.dismissProgress();
      switch (apiResponse.statusCode) {
        case 200:
          GlobalService.showSnackBar(
            status: AlertStatus.success,
            title: 'Expense',
            desc: apiResponse.message,
          );
          return deletePayment;
        case 401:
          GlobalService.showSnackBar(
            status: AlertStatus.warning,
            title: 'Expense',
            desc: apiResponse.message,
          );
          return 0;
        default:
          GlobalService.showSnackBar(
            status: AlertStatus.failure,
            title: 'Expense',
            desc: 'Failed to delete expense',
          );
          return 0;
      }
    } else {
      GlobalService.dismissProgress();
      GlobalService.showSnackBar(
        status: AlertStatus.failure,
        title: 'Expense',
        desc: 'Failed to delete expense',
      );
      return 0;
    }
  }

  static Future<int> addReassignment({
    required Map<String, dynamic> bodyObj,
  }) async {
    if (await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    ApiResponse apiResponse =
        await _dioService.post(ApiEndPoint.apiAddTripReassign, body: bodyObj);

    switch (apiResponse.statusCode) {
      case 201:
        Reassignment reassignment = Reassignment.fromJson(apiResponse.data);
        String strReassignQuery = ''' INSERT INTO $tblReassignment (
          id
        , tripId  
        , vhNumber
        , reassignmentAt
        , reAssignVhNumber
        , reason
        ) VALUE (
           ${reassignment.id}
        ,  ${reassignment.tripId}
        , '${reassignment.regdNumber}'
        , '${reassignment.date}'
        , '${reassignment.reassignVehicle}'
        , '${reassignment.reason}'
        );''';
        int updateTrip = await _databaseService.insertData(strReassignQuery);
        GlobalService.dismissProgress();
        if (updateTrip > 0) {
          GlobalService.showSnackBar(
            status: AlertStatus.success,
            title: 'Reaasignment',
            desc: apiResponse.message,
          );
        }
        return updateTrip;
      case 401:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Reaasignment',
          desc: apiResponse.message,
        );
        return 0;
      default:
        GlobalService.dismissProgress();
        GlobalService.showSnackBar(
          status: AlertStatus.failure,
          title: 'Reaasignment',
          desc: 'Failed to add reassignment',
        );
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
        TripDocument tripDocument = TripDocument.fromJson(apiResponse.data);
        String strQuery = '''
        UPDATE $tblDocument SET 
          docType = '${tripDocument.docType}'
        WHERE id = ${tripDocument.id} AND tripId = ${tripDocument.tripId};
        ''';
        int updateTrip = await _databaseService.updateData(strQuery);
        GlobalService.showSnackBar(
            status: AlertStatus.success,
            title: 'Reaasignment',
            desc: apiResponse.message);
        return updateTrip;
      case 401:
        GlobalService.showSnackBar(
            status: AlertStatus.warning,
            title: 'Reaasignment',
            desc: apiResponse.message);
        return 0;
      default:
        GlobalService.showSnackBar(
          status: AlertStatus.failure,
          title: 'Reaasignment',
          desc: 'Failed to edit reassignment',
        );
        return 0;
    }
  }

  static Future<int> deleteReassign({required int expenseId}) async {
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    String strQueryDelete =
        ''' DELETE FROM $tblReassignment WHERE id = $expenseId; ''';
    int deleteReassign = await _databaseService.delete(strQueryDelete);
    if (deleteReassign > 0) {
      ApiResponse apiResponse = await _dioService
          .delete('${ApiEndPoint.apiDeleteTripExpense}/$expenseId');
      GlobalService.dismissProgress();
      switch (apiResponse.statusCode) {
        case 200:
          GlobalService.showSnackBar(
            status: AlertStatus.success,
            title: 'Reassignment',
            desc: apiResponse.message,
          );
          return deleteReassign;
        case 401:
          GlobalService.showSnackBar(
            status: AlertStatus.warning,
            title: 'Reassignment',
            desc: apiResponse.message,
          );
          break;
        default:
          GlobalService.showSnackBar(
            status: AlertStatus.failure,
            title: 'Reassignment',
            desc: 'Failed to delete reassignment',
          );
          break;
      }
      return 0;
    } else {
      GlobalService.dismissProgress();
      GlobalService.showSnackBar(
        status: AlertStatus.failure,
        title: 'Reassignment',
        desc: 'Failed to delete reassignment',
      );
      return 0;
    }
  }

  static Future<int> upsertTrip(String tblName,
      {required List<Map<String, dynamic>> listData}) async {
    for (Map<String, dynamic> item in listData) {
      return await _databaseService.upsertData(
        tableName: tblName,
        data: item,
      );
    }
    return 0;
  }

  static Future<int> insertTripInfo(
    String tblName,
    List<Map<String, dynamic>> listTrip,
  ) async {
    int insertSuccess = await _databaseService.insertAllData(tblName, listTrip);
    return insertSuccess;
  }

  static Future<int> insertTrip({required TripModel trip}) async {
    String strInsertTrip = ''' INSERT INTO $tblTrips (
          id
        , isFav
        , tripCode
        , tripStatus
        , origin
        , destination
        , startedAt
        , endedAt
        , materialType
        , loadWeight
        , shortWeight
        , rate
        , fnId
        , fnAmount
        , fnPayment
        , fnExpense
        , fnProfit
        , vhId
        , vhNumber
        , vhModel
        , vhDesc
        , dvId
        , dvUuid
        , dvName
        , dvMobile
        , ownerId
        , ownerUuid
        , ownerName
        , ownerMobileNumber
        , updatedAt
        ) VALUES (
          ${trip.id}
        , ${trip.isFav}
        , '${trip.tripCode}'
        , '${trip.tripStatus}'
        , '${trip.origin}'
        , '${trip.destination}'                
        , '${trip.startDate}'
        , '${trip.endedDate}'
        , '${trip.loadDetail?.materialType}'
        ,  ${trip.loadDetail?.loadWeight}
        ,  ${trip.loadDetail?.shortWeight}
        ,  ${trip.loadDetail?.rate}
        ,  ${trip.finance?.id}
        ,  ${trip.finance?.amount}
        ,  ${trip.finance?.tripPayment}
        ,  ${trip.finance?.tripExpense}
        ,  ${trip.finance?.tripProfit}
        ,  ${trip.truck?.id}
        , '${trip.truck?.regdNumber}'
        , '${trip.truck?.model}'
        , '${trip.truck?.rcVhClassDesc}'
        ,  ${trip.driver?.id}
        , '${trip.driver?.uuid}'
        , '${trip.driver?.name}'
        , '${trip.driver?.mobile}'
        ,  ${trip.owner?.id}
        , '${trip.owner?.uuid}'
        , '${trip.owner?.name}'
        , '${trip.owner?.mobile}'
        , '${trip.updatedAt}'
        );''';
    int insertTrip = await _databaseService.insertData(strInsertTrip);
    return insertTrip;
  }

  static Future<int> clearAll() async {
    String strDeleteQuery = ''' DELETE FROM $tblTrips ''';
    int deleteSuccess = await _databaseService.delete(strDeleteQuery);

    if (deleteSuccess > 0) {
      GlobalService.printHandler('DELETED ALL TRIPS');
    }
    return deleteSuccess;
  }
}
