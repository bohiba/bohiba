import '/dist/enums/api_status_code.dart';

import '/core/network/dio_serivce.dart';
import '/dist/enums/app_enums.dart';
import '/model/user_fav_model.dart';
import '/model/news_model.dart';
import '/model/truck_model.dart';
import '/model/user_model.dart';
import '/model/company_model.dart';
import '/model/trip_model.dart';
import '/model/rating_model.dart';
import '/model/owner_expenses_model.dart';

import 'db2_service.dart';
import 'driver_service.dart';
import 'favourite_service.dart';
import 'company_service.dart';
import 'minerals_service.dart';
import 'news_service.dart';
import 'trip_service.dart';
import 'truck_service.dart';
import 'api_end_point.dart';
import 'device_info_service.dart';
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
      List<CompanyModel> mainMines = await CompanyService.getMinesList() ?? [];
      List<UserModel> mainDrivers = await DriverService.getAllDriver() ?? [];
      // List<UserModel> openToDriverList = await OpenDriverService.getAllOpenDriver(showProgress: false) ?? [];
      List<NewsModel> mainNews = await NewsService.getAllNews() ?? [];
      List<FavouriteModel> mainFavourites =
          await FavouriteService.getFavouriteList();
      if (showProgress) GlobalService.dismissProgress();
      return {
        "trips": mainTrips,
        "trucks": mainTrucks,
        "drivers": mainDrivers,
        "companies": mainMines,
        "owner_expense": [],
        "looking_jobs": [],
        "favourites": mainFavourites,
        "promotion": [],
        "news": mainNews,
      };
    } else {
      if (!await DeviceInfoService.hasInternet()) return null;

      if (showProgress) GlobalService.showProgress();
      ApiResponse serviceResponse = await _dioService
          .handleApiWithRetry(() => _dioService.get(ApiEndPoint.apiMain));

      StatusCode statusCode = StatusCode.fromCode(serviceResponse.statusCode);

      switch (statusCode) {
        case StatusCode.unauthorized:
          if (showProgress) GlobalService.dismissProgress();
          GlobalService.showAppToast(message: serviceResponse.message);
          return null;
        case StatusCode.ok:
          if (serviceResponse.data == null) return null;
          Map<String, dynamic> mainObj = serviceResponse.data ?? {};

          List<TruckModel> arrTruckModel = [];
          if (mainObj.containsKey('trucks') &&
              mainObj['trucks'] != null &&
              (mainObj['trucks'] is List)) {
            arrTruckModel = await syncTrucksLocally(mainObj['trucks'] as List);
          }

          List<UserModel> arrDriverModel = [];
          if (mainObj.containsKey('drivers') &&
              mainObj['drivers'] != null &&
              (mainObj['drivers'] is List)) {
            arrDriverModel =
                await syncDriversLocally(mainObj['drivers'] as List);
          }

          List<FavouriteModel> arrFavourites = [];
          if (mainObj.containsKey('favourites') &&
              mainObj['favourites'] != null &&
              (mainObj['favourites'] is List)) {
            arrFavourites =
                await syncFavouriteLocally(mainObj['favourites'] as List);
          }

          List<TripModel> arrTripModel = [];
          if (mainObj.containsKey('trips') &&
              mainObj['trips'] != null &&
              mainObj['trips'] is List) {
            arrTripModel = await syncTripLocally(mainObj['trips'] as List);
          }

          List<OwnerExpense> arrOwnerExpenseModel = [];
          if (mainObj.containsKey('owner_expense') &&
              mainObj['owner_expense'] != null &&
              mainObj['owner_expense'] is List) {
            arrOwnerExpenseModel =
                await syncOwnerExpenseLocally(mainObj['owner_expense'] as List);
          }

          List<UserModel> arrOpenDriverModel = [];
          if (mainObj.containsKey('looking_jobs') &&
              mainObj['looking_jobs'] != null &&
              (mainObj['looking_jobs'] is List)) {
            arrOpenDriverModel =
                await syncOpenDriverLocally(mainObj['looking_jobs'] as List);
          }

          List<CompanyModel> arrCompanyModel = [];
          if (mainObj.containsKey('companies') &&
              mainObj['companies'] != null &&
              mainObj['companies'] is List) {
            arrCompanyModel =
                await syncCompanyLocally(mainObj['companies'] as List);
          }

          /*List<Map<String, dynamic>> arrPromotionDB = [];
          if (mainObj.containsKey('promotion')) {
            // arrPromotionDB = mainObj['promotion'];
            ///TODO: Insert promotion into Local DB
          }*/

          if (mainObj.containsKey('minerals') &&
              mainObj['minerals'] != null &&
              (mainObj['minerals'] is List)) {
            await syncMineralsLocally(mainObj['minerals'] as List);
          }

          List<NewsModel> arrNewsModel = [];
          if (mainObj.containsKey('news') &&
              mainObj['news'] != null &&
              mainObj['news'] is List) {
            arrNewsModel = await syncNewsLocally(mainObj['news'] as List);
          }
          if (showProgress) GlobalService.dismissProgress();
          return {
            "trips": arrTripModel,
            "trucks": arrTruckModel,
            "drivers": arrDriverModel,
            "mines": arrCompanyModel,
            "owner_expense": arrOwnerExpenseModel,
            "looking_jobs": arrOpenDriverModel,
            "favourites": arrFavourites,
            "promotion": [],
            "news": arrNewsModel,
          };
        default:
          if (showProgress) GlobalService.dismissProgress();
          return null;
      }
    }
  }

  static Future<List<NewsModel>> syncNewsLocally(List<dynamic> newsList) async {
    List<NewsModel> arrNewsModel = [];
    await NewsService.clearAllNews();
    List<Map<String, dynamic>> dbNewsList = newsList.map((n) {
      return NewsModel.toDB(n);
    }).toList();
    int successNewsInsert = await NewsService.insertAll(dbNewsList);
    if (successNewsInsert > 0) {
      arrNewsModel = dbNewsList.map((news) {
        return NewsModel.fromDB(news);
      }).toList();
      GlobalService.printHandler("News Added in DB: $successNewsInsert");
    }
    return arrNewsModel;
  }

  static Future<List<OwnerExpense>> syncOwnerExpenseLocally(
      List<dynamic> expenseList) async {
    List<OwnerExpense> arrOwnerExpenseModel = [];
    List<Map<String, dynamic>> arrMapOwnerExpense =
        expenseList.map((e) => OwnerExpense.toDB(e)).toList();
    await OwnerExpenseService.clearAll();
    int insertOwnerExpense =
        await OwnerExpenseService.insertAll(arrMapOwnerExpense);
    if (insertOwnerExpense > 0) {
      arrOwnerExpenseModel =
          arrMapOwnerExpense.map((e) => OwnerExpense.fromDB(e)).toList();
    }
    GlobalService.printHandler(
        "Onwer Expense Added in DB: $insertOwnerExpense");

    return arrOwnerExpenseModel;
  }

  static Future<List<TripModel>> syncTripLocally(List<dynamic> tripList) async {
    List<TripModel> arrTripModel = [];
    TripService.clearAll();
    for (Map trip in tripList) {
      Map<String, dynamic> mapTrip = TripModel.toDB(trip);
      TripModel tripModel = TripModel.fromDb(mapTrip);
      int successTripInsert = await TripService.insertTrip(trip: tripModel);
      GlobalService.printHandler("Trip Added in DB: $successTripInsert");

      // Expense Insert
      if (trip.containsKey('expenses') &&
          trip['expenses'] != null &&
          (trip['expenses'] as List).isNotEmpty) {
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

      if (trip.containsKey('payments') &&
          trip['payments'] != null &&
          (trip['payments'] as List).isNotEmpty) {
        List tripPayments = trip['payments'];
        List<Map<String, dynamic>> arrMapPayment = tripPayments.map((payment) {
          return TripPayment.toDB(payment);
        }).toList();

        int successPayment = await TripService.insertTripInfo(
          tblTripPayment,
          arrMapPayment,
        );

        if (successPayment > 0) {
          List<TripPayment> tripPaymentList = arrMapPayment.map((payment) {
            return TripPayment.fromDb(payment);
          }).toList();

          tripModel.payments?.addAll(tripPaymentList);
          GlobalService.printHandler("Trip Payment in DB: $successPayment");
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
          List<Reassignment> tripReassignList = arrMapReassign.map((assign) {
            return Reassignment.fromDb(assign);
          }).toList();

          tripModel.reassignment?.addAll(tripReassignList);
          GlobalService.printHandler("Trip Reassign in DB: $successReassign");
        }
      }
      arrTripModel.add(tripModel);
    }

    return arrTripModel;
  }

  static Future<List<UserModel>> syncOpenDriverLocally(
      List<dynamic> arrOpenDriver) async {
    List<Map<String, dynamic>> arrMapOpenDriver = arrOpenDriver.map((json) {
      return UserModel.toDB(json, isOpenDriver: true);
    }).toList();
    return arrMapOpenDriver.map((json) {
      return UserModel.fromDB(json);
    }).toList();
  }

  static Future<List<MineralModel>> syncMineralsLocally(
      List<dynamic> mineralsList) async {
    List<MineralModel> arrMineralsModel = [];
    MineralsService.clearAll();
    List<Map<String, dynamic>> arrMapMinerals = mineralsList.map((minerals) {
      return MineralModel.toDB(minerals);
    }).toList();

    int successMineralsInsert = await MineralsService.insertAll(arrMapMinerals);
    if (successMineralsInsert > 0) {
      arrMineralsModel = arrMapMinerals.map((minerals) {
        return MineralModel.fromDB(minerals);
      }).toList();
    }

    return arrMineralsModel;
  }

  static Future<List<CompanyModel>> syncCompanyLocally(
      List<dynamic> arrMines) async {
    List<CompanyModel> arrMinesModel = [];
    CompanyService.clearAll();
    List<Map<String, dynamic>> arrMapCompanies = arrMines.map((mines) {
      return CompanyModel.toDB(mines);
    }).toList();

    int successCompaniesInsert =
        await CompanyService.insertAll(arrMapCompanies);
    if (successCompaniesInsert > 0) {
      arrMinesModel = arrMapCompanies.map((company) {
        return CompanyModel.fromDB(company);
      }).toList();
    }

    return arrMinesModel;
  }

  static Future<List<FavouriteModel>> syncFavouriteLocally(
      List<dynamic> favList) async {
    await FavouriteService.clearAllData();
    List<FavouriteModel> arrFavourites = [];
    for (Map fav in favList) {
      Map<String, dynamic> favMap = FavouriteModel.toDB(fav);

      int successFavInsert = await FavouriteService.addFavourite(favMap);

      if (successFavInsert > 0) {
        arrFavourites.add(FavouriteModel.fromDB(favMap));
        GlobalService.printHandler("Favourite Added in DB: $successFavInsert");
      }
    }
    return arrFavourites;
  }

  static Future<List<UserModel>> syncDriversLocally(
      List<dynamic> driverList) async {
    await DriverService.clearAllDriver();
    await RatingService.clearAllRating();

    List<Map<String, dynamic>> arrMapDriver = driverList.map((json) {
      return UserModel.toDB(json);
    }).toList();

    for (Map driver in driverList) {
      if (driver.containsKey('rating')) {
        List<dynamic> ratingList = driver['rating'];
        List<Map<String, dynamic>> arrRatingObj = ratingList.map((rating) {
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
    int insertDriver = await DriverService.insertAllDriver(arrMapDriver);

    if (insertDriver > 0) {
      return arrMapDriver.map((json) {
        return UserModel.fromDB(json);
      }).toList();
    }
    GlobalService.printHandler("Driver Added in DB: $insertDriver");
    return [];
  }

  static Future<List<TruckModel>> syncTrucksLocally(
      List<dynamic> truckList) async {
    await TruckService.clearAllTrucks();
    List<TruckModel> truckModelList = [];
    List<Map<String, dynamic>> arrMapTruck = truckList.map((json) {
      return TruckModel.toDB(json);
    }).toList();

    int insertTruck = await TruckService.insertAll(arrMapTruck);
    if (insertTruck > 0) {
      truckModelList = arrMapTruck.map((json) {
        return TruckModel.fromDB(json);
      }).toList();
    }
    GlobalService.printHandler("Truck Added in DB: $insertTruck");
    return truckModelList;
  }
}
