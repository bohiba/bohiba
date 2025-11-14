import '/dist/app_enums.dart';
import '/model/news_model.dart';
import '/model/truck_model.dart';
import '/model/driver_model.dart';
import '/model/mines_model.dart';
import '/model/trip_model.dart';
import '/model/rating_model.dart';
import '/model/owner_expenses_model.dart';

import 'db2_service.dart';
import 'driver_service.dart';
import 'mines_service.dart';
import 'news_service.dart';
import 'open_driver_service.dart';
import 'trip_service.dart';
import 'truck_service.dart';
import 'api_end_point.dart';
import 'device_info_service.dart';
import 'dio_serivce.dart';
import 'global_service.dart';
import 'owner_expense_service.dart';
import 'rating_service.dart';

class MainService {
  static final DioService _dioService = DioService();
  static Future<Map<String, dynamic>?> mainApi({
    MethodType type = MethodType.local,
    bool showProgress = false,
  }) async {
    if (type == MethodType.local) {
      if (showProgress) GlobalService.showProgress();
      List<TripModel> mainTrips = await TripService.getAllTrip() ?? [];
      List<TruckModel> mainTrucks = await TruckService.getTruckList() ?? [];
      List<MinesModel> mainMines = await MinesService.getMinesList() ?? [];
      List<UserModel> mainDrivers = await DriverService.getAllDriver() ?? [];
      List<UserModel> openToDriverList =
          await OpenDriverService.getAllOpenDriver(showProgress: false) ?? [];
      List<NewsModel> mainNews = await NewsService.getAllNews() ?? [];
      if (showProgress) GlobalService.dismissProgress();
      return {
        "trips": mainTrips,
        "trucks": mainTrucks,
        "drivers": mainDrivers,
        "mines": mainMines,
        "owner_expense": [],
        "looking_jobs": openToDriverList,
        "favList": [],
        "promotion": [],
        "news": mainNews,
      };
    } else {
      if (!await DeviceInfoService.hasInternet()) return null;

      if (showProgress) GlobalService.showProgress();
      ApiResponse serviceResponse = await _dioService
          .handleApiWithRetry(() => _dioService.get(ApiEndPoint.apiMain));

      switch (serviceResponse.statusCode) {
        case 401:
          if (showProgress) GlobalService.dismissProgress();
          GlobalService.showAppToast(message: serviceResponse.message);
          return null;
        case 200:
          if (serviceResponse.data == null) return null;
          Map<String, dynamic> mainObj = serviceResponse.data ?? {};

          List<TruckModel> arrTruckModel = [];
          if (mainObj.containsKey('trucks')) {
            await TruckService.clearAllTrucks();
            List<dynamic> truckList = mainObj['trucks'] as List;
            List<Map<String, dynamic>> arrMapTruck = truckList.map((json) {
              return TruckModel.toDB(json);
            }).toList();

            int insertTruck = await TruckService.insertAll(arrMapTruck);
            if (insertTruck > 0) {
              arrTruckModel = arrMapTruck.map((json) {
                return TruckModel.fromDB(json);
              }).toList();
            }
            GlobalService.printHandler("Truck Added in DB: $insertTruck");
          }

          List<UserModel> arrDriverModel = [];
          if (mainObj.containsKey('drivers')) {
            await DriverService.clearAllDriver();
            await RatingService.clearAllRating();
            List<dynamic> driverList = mainObj['drivers'] as List;
            List<Map<String, dynamic>> arrMapDriver = driverList.map((json) {
              return UserModel.toDB(json);
            }).toList();

            for (Map driver in driverList) {
              if (driver.containsKey('rating')) {
                List<dynamic> ratingList = driver['rating'];
                List<Map<String, dynamic>> arrRatingObj =
                    ratingList.map((rating) {
                  return RatingModel.toDB(rating);
                }).toList();

                int insertRating =
                    await RatingService.insertAll(ratingList: arrRatingObj);
                if (insertRating > 0) {
                  GlobalService.printHandler(
                    'Insert rating success: $insertRating',
                  );
                }
              }
            }
            int insertDriver =
                await DriverService.insertAllDriver(arrMapDriver);

            if (insertDriver > 0) {
              arrDriverModel = arrMapDriver.map((json) {
                return UserModel.fromDB(json);
              }).toList();
            }
            GlobalService.printHandler("Driver Added in DB: $insertDriver");
          }

          List<TripModel> arrTripModel = [];
          if (mainObj.containsKey('trips')) {
            await TripService.clearAll();
            List<dynamic> tripList = mainObj['trips'] as List;
            for (Map trip in tripList) {
              Map<String, dynamic> mapTrip = TripModel.toDB(trip);

              TripModel tripModel = TripModel.fromDb(mapTrip);
              int successTripInsert =
                  await TripService.insertTrip(trip: tripModel);
              GlobalService.printHandler(
                  "Trip Added in DB: $successTripInsert");

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
          }

          List<OwnerExpense> arrOwnerExpenseModel = [];
          if (mainObj.containsKey('owner_expense')) {
            List<dynamic> expenseList = mainObj['owner_expense'];
            List<Map<String, dynamic>> arrMapOwnerExpense =
                expenseList.map((e) => OwnerExpense.toDB(e)).toList();
            await OwnerExpenseService.clearAll();
            int insertOwnerExpense =
                await OwnerExpenseService.insertAll(arrMapOwnerExpense);
            if (insertOwnerExpense > 0) {
              arrOwnerExpenseModel = arrMapOwnerExpense
                  .map((e) => OwnerExpense.fromDB(e))
                  .toList();
            }
            GlobalService.printHandler(
                "Onwer Expense Added in DB: $insertOwnerExpense");
          }

          List<UserModel> arrOpenDriverModel = [];
          if (mainObj.containsKey('looking_jobs')) {
            List<dynamic> arrOpenDriver = mainObj['looking_jobs'];
            List<Map<String, dynamic>> arrMapOpenDriver =
                arrOpenDriver.map((json) {
              return UserModel.toDB(json, isOpenDriver: true);
            }).toList();
            arrOpenDriverModel = arrMapOpenDriver.map((json) {
              return UserModel.fromDB(json);
            }).toList();
          }

          List<MinesModel> arrMinesModel = [];
          if (mainObj.containsKey('mines')) {
            MinesService.clearAll();
            List<dynamic> arrMines = mainObj['mines'];
            List<Map<String, dynamic>> arrMapMines = arrMines.map((mines) {
              return MinesModel.toDB(mines);
            }).toList();

            int successMinesInsert = await MinesService.insertAll(arrMapMines);
            if (successMinesInsert > 0) {
              arrMinesModel = arrMapMines.map((mines) {
                return MinesModel.fromDB(mines);
              }).toList();
            }
          }

          /*List<Map<String, dynamic>> arrPromotionDB = [];
          if (mainObj.containsKey('promotion')) {
            // arrPromotionDB = mainObj['promotion'];
            ///TODO: Insert promotion into Local DB
          }*/

          List<NewsModel> arrNewsModel = [];
          if (mainObj.containsKey('news')) {
            await NewsService.clearAllNews();
            List newsList = mainObj['news'];
            List<Map<String, dynamic>> dbNewsList = newsList.map((n) {
              return NewsModel.toDB(n);
            }).toList();
            int successNewsInsert = await NewsService.insertAll(dbNewsList);
            if (successNewsInsert > 0) {
              arrNewsModel = dbNewsList.map((news) {
                return NewsModel.fromDB(news);
              }).toList();
              GlobalService.printHandler(
                  "News Added in DB: $successNewsInsert");
            }
          }
          if (showProgress) GlobalService.dismissProgress();
          return {
            "trips": arrTripModel,
            "trucks": arrTruckModel,
            "drivers": arrDriverModel,
            "mines": arrMinesModel,
            "owner_expense": arrOwnerExpenseModel,
            "looking_jobs": arrOpenDriverModel,
            "favList": [],
            "promotion": [],
            "news": arrNewsModel,
          };
        default:
          if (showProgress) GlobalService.dismissProgress();
          return null;
      }
    }
  }
}
