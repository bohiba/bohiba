import 'dart:io';

import 'api_end_point.dart';
import 'device_info_service.dart';
import 'dio_serivce.dart';
import 'global_service.dart';
import 'db2_service.dart';

import '../dist/enums/app_enums.dart';
import '/model/truck_model.dart';
import '/model/trip_model.dart';
import '/extensions/bohiba_extension.dart';

class TripService {
  static final DatabaseService _databaseService = DatabaseService();
  static final DioService _dioService = DioService();

  static int _currentPage = 1;
  static int _lastPage = 1;

  static Future<int> addTrip({required Map<String, dynamic> bodyMap, required TruckModel truckModel}) async {
    if (!await DeviceInfoService.hasInternet()) return 0;
    GlobalService.showProgress();
    ApiResponse apiResponse = await _dioService.post(ApiEndPoint.apiTrips, body: bodyMap);
    switch (apiResponse.statusCode) {
      case 201:
        GlobalService.dismissProgress();
        Map<String, dynamic> tripMap = TripModel.toDB(apiResponse.data);
        TripModel tripModel = TripModel.fromDb(tripMap);
        int sucessInsert = await insertTrip(trip: tripModel);
        if (sucessInsert > 0) {
          GlobalService.showSnackBar(
            status: AlertStatus.success,
            title: 'Trip',
            desc: apiResponse.message,
          );
        }
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
          desc: "Failed to add trip",
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
      String strQueryList = ''' SELECT 
        id
      , tripCode
      , tripStatus
      , originName
      , originNameCode
      , destinationName
      , destinationNameCode
      , vhNumber
      , dvName
      , startedAt
      , endedAt
       FROM $tblTrips ORDER BY startedAt DESC''';
      /*String strQueryList = '''
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

          FROM $tblTrips t
          LEFT JOIN $tblReassignment r ON t.id = r.tripId
          LEFT JOIN $tblTripExpense e ON t.id = e.tripId
          LEFT JOIN $tblTripPayment p ON t.id = p.tripId
          LEFT JOIN $tblDocument d ON t.id = d.tripId
          ORDER BY t.startedAt DESC;
        ''';*/
      if (showProgress) GlobalService.showProgress();

      List<Map<String, dynamic>>? arrTrip = await _databaseService.executeQuery(strQueryList);
      if (showProgress) GlobalService.dismissProgress();
      if (arrTrip != null) {
        List<TripModel> tripList = arrTrip.map((trip) {
          return TripModel.fromDb(trip);
        }).toList();
        return tripList;
      }
      return null;
    } else {
      if (!await DeviceInfoService.hasInternet()) return null;

      if (reset) {
        await clearAll();
        _currentPage = 1;
        _lastPage = 1;
      }

      if (_currentPage > _lastPage) {
        // No More Data
        return [];
      }

      if (showProgress) GlobalService.showProgress();
      ApiResponse res = await _dioService.get('${ApiEndPoint.apiTrips}?page=$_currentPage');
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
            int successTripInsert = await TripService.insertTrip(trip: tripModel);
            GlobalService.printHandler("Trip Added in DB: $successTripInsert");

            // Expense Insert
            if (trip.containsKey('expenses') && trip['expenses'] != null && (trip['expenses'] as List).isNotEmpty) {
              List tripExpense = trip['expenses'];
              List<Map<String, dynamic>> arrMapExpense = tripExpense.map((expense) {
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
                GlobalService.printHandler("Trip Expense in DB: $successExpense");
              }
            }

            if (trip.containsKey('payments') && trip['payments'] != null && (trip['payments'] as List).isNotEmpty) {
              List tripPayments = trip['payments'];
              List<Map<String, dynamic>> arrMapPayment = tripPayments.map((json) {
                return TripPayment.toDB(json);
              }).toList();

              int successPayment = await TripService.insertTripInfo(
                tblTripPayment,
                arrMapPayment,
              );

              if (successPayment > 0) {
                List<TripPayment> tripPaymentList = arrMapPayment.map((mapObj) {
                  return TripPayment.fromDb(mapObj);
                }).toList();

                tripModel.payments?.addAll(tripPaymentList);
                GlobalService.printHandler("Trip Payment in DB: $successPayment");
              }
            }

            if (trip.containsKey('documents') && trip['documents'] != null && (trip['documents'] as List).isNotEmpty) {
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

            if (trip.containsKey('reassignment') && trip['reassignment'] != null && (trip['reassignment'] as List).isNotEmpty) {
              List tripReassignment = trip['reassignment'];
              List<Map<String, dynamic>> arrMapReassign = tripReassignment.map((assign) {
                return Reassignment.toDB(assign);
              }).toList();

              int successReassign = await TripService.insertTripInfo(
                tblReassignment,
                arrMapReassign,
              );

              if (successReassign > 0) {
                List<Reassignment> tripReassignList = arrMapReassign.map((assign) {
                  return Reassignment.fromDb(assign);
                }).toList();

                tripModel.reassignment?.addAll(tripReassignList);
                GlobalService.printHandler("Trip Reassign in DB: $successReassign");
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
      String strGetQuery = ''' SELECT * FROM $tblTrips WHERE id = $tripId ''';
      List<Map<String, dynamic>>? arrTripList = await _databaseService.executeQuery(strGetQuery);
      if (arrTripList == null || arrTripList.isEmpty) {
        return null;
      }
      List<TripModel> tripList = arrTripList.map((trip) => TripModel.fromDb(trip)).toList();
      TripModel trip = tripList.first;

      final arrPayment = await _databaseService.executeQuery("SELECT * FROM $tblTripPayment WHERE tripId = $tripId");

      // PAYMENT
      trip.payments = arrPayment?.map((p) {
            return TripPayment(
              id: p['id'],
              tripId: p['tripId'],
              paymentType: p['payerType'],
              paymentMode: p['payementMode'],
              paidBy: p['paidBy'],
              receivedBy: p['receivedBy'],
              amount: p['amount'],
              paymentTime: p['paymentTime'],
            );
          }).toList() ??
          [];

      final List<Map<String, dynamic>>? arrExpense = await _databaseService.executeQuery("SELECT * FROM tblTripExpense WHERE tripId = $tripId");

      trip.expenses = arrExpense?.map((e) {
            return TripExpense(
              id: e['id'],
              tripId: e['tripId'],
              expenseType: e['expenseType'],
              paymentMode: e['paymentMode'],
              paid: e['paid'],
              paidTo: e['paidTo'],
              expenseDate: e['expenseDate'],
              remarks: e['remarks'],
            );
          }).toList() ??
          [];

      // REASSIGNMENT
      final List<Map<String, dynamic>>? arrReassignment = await _databaseService.executeQuery("SELECT * FROM $tblReassignment WHERE tripId = $tripId");
      trip.reassignment = arrReassignment?.map((r) {
            return Reassignment(
              id: r['id'],
              tripId: r['tripId'],
              regdNumber: r['vhNumber'],
              date: r['reassignmentAt'],
              reassignVehicle: r['reAssignVhNumber'],
              reason: r['reason'],
            );
          }).toList() ??
          [];

      // TRIP-DOCUMENT
      final List<Map<String, dynamic>>? arrTripDoc = await _databaseService.executeQuery("SELECT * FROM $tblDocument WHERE tripId = $tripId");
      trip.documents = arrTripDoc?.map((d) {
            return TripDocument(
              id: d['id'],
              tripId: d['tripId'],
              docType: d['docType'],
              image: d['image'],
              uploadedBy: d['uploadedBy'],
              updatedAt: d['uploadedAt'],
            );
          }).toList() ??
          [];
      return trip;
    } else if (method == MethodType.api) {
      if (!await DeviceInfoService.hasInternet()) {
        return null;
      }

      if (showProgress) GlobalService.showProgress();
      ApiResponse res = await _dioService.get('${ApiEndPoint.apiTrips}/$tripId');

      switch (res.statusCode) {
        case 200:
          if (showProgress) GlobalService.dismissProgress();
          Map tripObj = res.data;
          Map<String, dynamic> mapTrip = TripModel.toDB(tripObj);
          String strUpdateQuery = '''
              UPDATE $tblTrips SET
                isFav = ${mapTrip['isFav'] ?? 0},
                tripCode = ${sqlValue(mapTrip['trip_code'])},
                tripStatus = ${sqlValue(mapTrip['tripStatus'])},
                origin = ${sqlValue(mapTrip['origin'])},
                destination = ${sqlValue(mapTrip['destination'])},
                startedAt = ${sqlValue(mapTrip['startedAt'])},
                endedAt = ${sqlValue(mapTrip['endedAt'])},
                transporter = ${sqlValue(mapTrip['transporter'])},
                materialType = ${sqlValue(mapTrip['materialType'])},
                loadWeight = ${sqlValue(mapTrip['loadWeight'])},
                shortWeight = ${sqlValue(mapTrip['shortWeight'] ?? 0.0)},
                rate = ${sqlValue(mapTrip['rate'] ?? 0.0)},
                fnId = ${sqlValue(mapTrip['fnId'])},
                fnAmount = ${sqlValue(mapTrip['fnAmount'] ?? 0.0)},
                fnPayment = ${sqlValue(mapTrip['fnPayment'] ?? 0.0)},
                fnExpense = ${sqlValue(mapTrip['fnExpense'] ?? 0.0)},
                fnProfit = ${sqlValue(mapTrip['fnProfit'] ?? 0.0)},
                vhId = ${sqlValue(mapTrip['vhId'])},
                vhNumber = ${sqlValue(mapTrip['vhNumber'])},
                vhModel = ${sqlValue(mapTrip['vhModel'])},
                vhDesc = ${sqlValue(mapTrip['vhDesc'])},
                dvId = ${sqlValue(mapTrip['dvId'])},
                dvUuid = ${sqlValue(mapTrip['dvUuid'])},
                dvName = ${sqlValue(mapTrip['dvName'])},
                dvMobile = ${sqlValue(mapTrip['dvMobile'])},
                ownerId = ${sqlValue(mapTrip['ownerId'])},
                ownerUuid = ${sqlValue(mapTrip['ownerUuid'])},
                ownerName = ${sqlValue(mapTrip['ownerName'])},
                ownerMobileNumber = ${sqlValue(mapTrip['ownerMobileNumber'])},
                updatedAt = ${sqlValue(mapTrip['updatedAt'])}
              WHERE id = $tripId;
              ''';
          int successUpdate = await _databaseService.updateData(strUpdateQuery);
          if (successUpdate > 0) {
            TripModel tripModel = TripModel();
            tripModel = TripModel.fromDb(mapTrip);
            // UPDATE payment
            List<TripPayment> arrPayment = [];
            if (tripObj.containsKey('payments') && tripObj['payments'] != null && tripObj['payments'] is List && (tripObj['payments'] as List).isNotEmpty) {
              List tripPayment = tripObj['payments'];
              List<Map<String, dynamic>> arrMapPayment = tripPayment.map((payment) => TripPayment.toDB(payment)).toList();

              int upsertPayment = await _databaseService.insertAllData(tblTripPayment, arrMapPayment);
              if (upsertPayment > 0) {
                arrPayment = arrMapPayment.map((e) => TripPayment.fromDb(e)).toList();
              }
              tripModel.payments = List<TripPayment>.from(arrPayment);
            }

            // UPDATE reassignment
            List<Reassignment> arrReassigModel = [];
            if (tripObj.containsKey('reassignment') && tripObj['reassignment'] != null && tripObj['reassignment'] is List && (tripObj['reassignment'] as List).isNotEmpty) {
              List tripReassign = tripObj['reassignment'];
              List<Map<String, dynamic>> arrMapReassign = tripReassign.map((r) {
                return Reassignment.toDB(r);
              }).toList();

              int successReassign = await upsertTrip(tblReassignment, listData: arrMapReassign);
              if (successReassign > 0) {
                arrReassigModel = arrMapReassign.map((c) {
                  return Reassignment.fromDb(c);
                }).toList();
                tripModel.reassignment = [];
                tripModel.reassignment?.addAll(arrReassigModel);

                GlobalService.printHandler('Trip Reassignment Upsert $successReassign');
              }
            }

            // UPDATE expenses
            List<TripExpense> arrExpenseModel = [];
            if (tripObj.containsKey('expenses') && tripObj['expenses'] != null && tripObj['expenses'] is List && (tripObj['expenses'] as List).isNotEmpty) {
              List tripExpense = tripObj['expenses'];
              List<Map<String, dynamic>> arrMapExpense = tripExpense.map((expense) {
                return TripExpense.toDB(expense);
              }).toList();

              int successExpense = await upsertTrip(tblTripExpense, listData: arrMapExpense);
              if (successExpense > 0) {
                arrExpenseModel = arrMapExpense.map((e) {
                  return TripExpense.fromDb(e);
                }).toList();
                tripModel.expenses = [];
                tripModel.expenses?.addAll(arrExpenseModel);

                GlobalService.printHandler('Trip Expenses Upsert $successExpense');
              }
            }

            // UPDATE documents
            List<TripDocument> arrDocModel = [];
            if (tripObj.containsKey('documents') && tripObj['documents'] != null && tripObj['documents'] is List && (tripObj['documents'] as List).isNotEmpty) {
              List docList = tripObj['documents'];
              List<Map<String, dynamic>> arrMapDoc = docList.map((r) {
                return TripDocument.toDB(r);
              }).toList();

              int sucessDocInsert = await upsertTrip(tblDocument, listData: arrMapDoc);
              if (sucessDocInsert > 0) {
                arrDocModel = arrMapDoc.map((e) {
                  return TripDocument.fromDb(e);
                }).toList();
                tripModel.documents = [];
                tripModel.documents?.addAll(arrDocModel);
                GlobalService.printHandler('Trip Expenses Upsert $sucessDocInsert');
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
            desc: 'Failed to get trip',
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
      '${ApiEndPoint.apiTrips}/${trip.id}',
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
          , transporter = '${bodyMap['transporter']}'
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
          , updatedAt = '${trip.updatedAt}' WHERE id = ${trip.id}
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
    String strQueryDelete = ''' DELETE FROM $tblTrips WHERE id = $tripId; ''';
    int deleteSucess = await _databaseService.delete(strQueryDelete);
    if (deleteSucess > 0) {
      ApiResponse apiResponse = await _dioService.delete('${ApiEndPoint.apiTrips}/$tripId');
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
    ApiResponse apiResponse = await _dioService.post(ApiEndPoint.apiAddTripPayment, body: bodyMap);

    switch (apiResponse.statusCode) {
      case 201:
        TripPayment tripPayment = TripPayment.fromJson(apiResponse.data);
        String strQueryPayment = ''' INSERT INTO $tblTripPayment (
        id
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
        , '${tripPayment.paymentType}'
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
    ApiResponse apiResponse = await _dioService.post('${ApiEndPoint.apiEditTripPayment}/$paymentId', body: bodyMap);

    switch (apiResponse.statusCode) {
      case 200:
        TripPayment tripPayment = TripPayment.fromJson(apiResponse.data);
        String strUpdateQuery = '''
          UPDATE $tblTripPayment SET
            payerType = '${tripPayment.paymentType}'
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

  static Future<List<TripModel>?> filterTripWithTruckNo({String? truckNo}) async {
    List<TripModel>? tripList = await getAllTrip(methodType: MethodType.local);
    if (tripList != null) {
      List<TripModel> filterTrip = [];
      if (truckNo != null && truckNo.isNotEmpty) {
        filterTrip.addAll(tripList.where((truck) => truck.truck?.regdNumber == truckNo));
      } else {
        filterTrip.addAll(tripList);
      }
      return filterTrip;
    }
    return null;
  }

  static Future<int> deletePayment({required int paymentId}) async {
    GlobalService.showProgress();
    String strQueryDelete = ''' DELETE FROM $tblTripPayment WHERE id = $paymentId; ''';
    int deletePayment = await _databaseService.delete(strQueryDelete);
    if (deletePayment > 0) {
      ApiResponse apiResponse = await _dioService.delete('${ApiEndPoint.apiDeleteTripPayment}/$paymentId');
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
    ApiResponse apiResponse = await _dioService.post(ApiEndPoint.apiAddTripExpense, body: bodyObj);
    switch (apiResponse.statusCode) {
      case 201:
        TripExpense tripExpense = TripExpense.fromJson(apiResponse.data);
        String insertExpense = '''INSERT INTO $tblTripExpense (
            id
          , tripId  
          , expenseType
          , paymentMode
          , paid
          , paidTo
          , expenseDate
          , remarks
        ) VALUES (
          ${tripExpense.id}
        , ${sqlValue(tripExpense.tripId)}  
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
    ApiResponse apiResponse = await _dioService.post('${ApiEndPoint.apiEditTripExpense}/$expenseId', body: bodyMap);
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
    if (!await DeviceInfoService.hasInternet()) {
      return 0;
    }
    GlobalService.showProgress();
    String strQueryDelete = ''' DELETE FROM $tblTripExpense WHERE id = $expenseId; ''';
    int deletePayment = await _databaseService.delete(strQueryDelete);
    if (deletePayment > 0) {
      ApiResponse apiResponse = await _dioService.delete('${ApiEndPoint.apiDeleteTripExpense}/$expenseId');
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
    if (await DeviceInfoService.hasInternet()) return 0;

    GlobalService.showProgress();
    ApiResponse apiResponse = await _dioService.post(ApiEndPoint.apiAddTripReassign, body: bodyObj);

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
          ${sqlValue(reassignment.id)}
        , ${sqlValue(reassignment.tripId)}
        , ${sqlValue(reassignment.regdNumber)}
        , ${sqlValue(reassignment.date)}
        , ${sqlValue(reassignment.reassignVehicle)}
        , ${sqlValue(reassignment.reason)}
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
    ApiResponse apiResponse = await _dioService.post('${ApiEndPoint.apiEditTripReassign}/$reassignId', body: bodyMap);
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
        GlobalService.showSnackBar(status: AlertStatus.success, title: 'Reaasignment', desc: apiResponse.message);
        return updateTrip;
      case 401:
        GlobalService.showSnackBar(status: AlertStatus.warning, title: 'Reaasignment', desc: apiResponse.message);
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
    String strQueryDelete = ''' DELETE FROM $tblReassignment WHERE id = $expenseId; ''';
    int deleteReassign = await _databaseService.delete(strQueryDelete);
    if (deleteReassign > 0) {
      ApiResponse apiResponse = await _dioService.delete('${ApiEndPoint.apiDeleteTripExpense}/$expenseId');
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

  static Future<List<TripDocument>?> getAllDocument({required int tripId}) async {
    if (!await DeviceInfoService.hasInternet()) return null;
    GlobalService.showProgress();
    ApiResponse res = await _dioService.get('${ApiEndPoint.apiGetAllTripDoc}/$tripId');
    GlobalService.dismissProgress();
    switch (res.statusCode) {
      case 200:
        List<Map> tripDocList = List.from(res.data);
        List<Map<String, dynamic>> arrMapTripDoc = tripDocList.map((e) => TripDocument.toDB(e)).toList();
        await clearAllTripDoc(tripId: tripId);
        int successAdd = await _databaseService.insertAllData(tblDocument, arrMapTripDoc);
        if (successAdd > 0) {
          List<TripDocument> arrTripDoc = arrMapTripDoc.map((trip) => TripDocument.fromDb(trip)).toList();
          return arrTripDoc;
        }
        return null;
      case 401:
        GlobalService.showSnackBar(
          status: AlertStatus.failure,
          title: 'Trip',
          desc: res.data,
        );
        return null;
      default:
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Trip',
          desc: "Failed to add document",
        );
        return null;
    }
  }

  static Future<TripDocument?> getDocument({required int id, MethodType type = MethodType.local}) async {
    if (type == MethodType.local) {
      String strGetQuery = ''' SELECT * FROM $tblDocument WHERE id = $id''';
      List<Map<String, dynamic>>? arrDoc = await _databaseService.executeQuery(strGetQuery);
      if (arrDoc != null) {
        List<TripDocument> arrTripDoc = arrDoc.map((e) => TripDocument.fromDb(e)).toList();
        return arrTripDoc.first;
      }
      return null;
    } else {
      if (!await DeviceInfoService.hasInternet()) return null;
      GlobalService.showProgress();
      ApiResponse res = await _dioService.get('${ApiEndPoint.apiGetTripDoc}/$id');
      GlobalService.dismissProgress();
      switch (res.statusCode) {
        case 200:
          Map<String, dynamic> tripDocObj = TripDocument.toDB(res.data);
          TripDocument tripDocument = TripDocument.fromDb(tripDocObj);
          return tripDocument;
        case 401:
          GlobalService.showSnackBar(
            status: AlertStatus.failure,
            title: 'Trip',
            desc: res.data,
          );
          return null;
        default:
          GlobalService.showSnackBar(
            status: AlertStatus.warning,
            title: 'Trip',
            desc: "Failed to add document",
          );
          return null;
      }
    }
  }

  static Future<int> addDocument({
    required Map<String, dynamic> bodyObj,
    required List<File> imageList,
  }) async {
    if (!await DeviceInfoService.hasInternet()) return 0;

    GlobalService.showProgress();
    ApiResponse res = await _dioService.upload(ApiEndPoint.apiAddTripDoc, imageList, fileField: 'doc_image', body: bodyObj);
    GlobalService.dismissProgress();
    switch (res.statusCode) {
      case 200:
        Map<String, dynamic> docObj = TripDocument.toDB(res.data);
        String strQueryInsert = ''' INSERT INTO $tblDocument VALUES 
          id
        , tripId
        , docType
        , image
        , uploadedBy
        , uploadedAt VALUES (
           ${docObj['id']},
        ,  ${docObj['trip_id']}
        , '${docObj['doc_type']}'
        , '${docObj['doc_image']}' 
        , '${docObj['uploaded_by_uuid']}'
        , '${docObj['updated_at']}'
        ); ''';
        int successDoc = await _databaseService.insertData(strQueryInsert);
        return successDoc;
      case 401:
        GlobalService.showSnackBar(
          status: AlertStatus.failure,
          title: 'Trip',
          desc: res.data,
        );
        return 0;
      default:
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Trip',
          desc: "Failed to add document",
        );
        return 0;
    }
  }

  static Future<int> editDocument() async {
    return 0;
  }

  static Future<int> deleteDocument() async {
    return 0;
  }

  static Future<int> upsertTrip(String tblName, {required List<Map<String, dynamic>> listData}) async {
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
        , originId
        , originName
        , originNameCode
        , originLat
        , originLng
        , originType
        , originStatus
        , destinationId
        , destinationName
        , destinationNameCode
        , destinationLat
        , destinationLng
        , destinationType
        , destinationStatus
        , startedAt
        , endedAt
        , transporterId
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
          ${sqlValue(trip.id)}
        , ${sqlValue(trip.isFav)}
        , ${sqlValue(trip.tripCode)}
        , ${sqlValue(trip.tripStatus)}
        , ${sqlValue(trip.origin?.id)}
        , ${sqlValue(trip.origin?.name)}
        , ${sqlValue(trip.origin?.nameCode)}
        , ${sqlValue(trip.origin?.latitude)}
        , ${sqlValue(trip.origin?.longitude)}
        , ${sqlValue(trip.origin?.type)}
        , ${sqlValue(trip.origin?.status)}
        , ${sqlValue(trip.destination?.id)}
        , ${sqlValue(trip.destination?.name)}
        , ${sqlValue(trip.destination?.nameCode)}
        , ${sqlValue(trip.destination?.latitude)}
        , ${sqlValue(trip.destination?.longitude)}
        , ${sqlValue(trip.destination?.type)}
        , ${sqlValue(trip.destination?.status)}
        , ${sqlValue(trip.startDate)}
        , ${sqlValue(trip.endedDate)}
        , ${sqlValue(trip.transporterId)}
        , ${sqlValue(trip.loadDetail?.materialType)}
        , ${sqlValue(trip.loadDetail?.loadWeight)}
        , ${sqlValue(trip.loadDetail?.shortWeight)}
        , ${sqlValue(trip.loadDetail?.rate)}
        , ${sqlValue(trip.finance?.id)}
        , ${sqlValue(trip.finance?.amount)}
        , ${sqlValue(trip.finance?.tripPayment)}
        , ${sqlValue(trip.finance?.tripExpense)}
        , ${sqlValue(trip.finance?.tripProfit)}
        , ${sqlValue(trip.truck?.id)}
        , ${sqlValue(trip.truck?.regdNumber)}
        , ${sqlValue(trip.truck?.model)}
        , ${sqlValue(trip.truck?.rcVhClassDesc)}
        , ${sqlValue(trip.driver?.id)}
        , ${sqlValue(trip.driver?.uuid)}
        , ${sqlValue(trip.driver?.name)}
        , ${sqlValue(trip.driver?.mobile)}
        , ${sqlValue(trip.owner?.id)}
        , ${sqlValue(trip.owner?.uuid)}
        , ${sqlValue(trip.owner?.name)}
        , ${sqlValue(trip.owner?.mobile)}
        , ${sqlValue(trip.updatedAt)}
        );''';
    int insertTrip = await _databaseService.insertData(strInsertTrip);
    return insertTrip;
  }

  static Future<int> clearAllTripDoc({required int tripId}) async {
    String strDeleteQuery = ''' DELETE FROM $tblDocument WHERE trip_id = $tripId ''';
    int deleteSuccess = await _databaseService.delete(strDeleteQuery);
    if (deleteSuccess > 0) {
      GlobalService.printHandler('DELETED TRIP ALL DOC');
    }
    return deleteSuccess;
  }

  static Future<int> clearAll() async {
    String strDeleteQuery = ''' DELETE FROM $tblTrips ''';
    String strTblPayment = ''' DELETE FROM $tblTripPayment ''';
    String strTblExpense = ''' DELETE FROM $tblTripExpense ''';
    String strTblDoc = ''' DELETE FROM $tblDocument ''';
    String strTblReassignment = ''' DELETE FROM $tblReassignment ''';
    int deleteSuccess = await _databaseService.delete(strDeleteQuery);
    int delete2 = await _databaseService.delete(strTblPayment);
    int delete3 = await _databaseService.delete(strTblExpense);
    int delete4 = await _databaseService.delete(strTblDoc);
    int delete5 = await _databaseService.delete(strTblReassignment);

    if (deleteSuccess > 0 && delete2 > 0 && delete3 > 0 && delete4 > 0 && delete5 > 0) {
      GlobalService.printHandler('DELETED ALL TRIPS');
    }
    return deleteSuccess;
  }
}
