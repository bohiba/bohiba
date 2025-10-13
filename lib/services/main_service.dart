import '/dist/app_enums.dart';
import '/services/driver_service.dart';
import '/services/fav_service.dart';
import '/services/mines_service.dart';
import '/services/news_service.dart';
import '/services/open_driver_service.dart';
import '/services/trip_service.dart';
import '/services/truck_service.dart';

import '/model/driver_model.dart';
import '/model/mines_model.dart';
import '/model/news_model.dart';
import '/model/trip_model.dart';
import '/model/truck_model.dart';
import '/model/user_fav_model.dart';

import '/services/api_end_point.dart';
import '/services/db_service.dart';
import '/services/device_info_service.dart';
import '/services/dio_serivce.dart';
import '/services/global_service.dart';

class MainService {
  static final DioService _dioService = DioService();
  static final DBService _dbService = DBService();

  static Future<Map<String, dynamic>?> mainApi(
      {MethodType type = MethodType.local}) async {
    if (type == MethodType.local) {
      List<TripModel> mainTrips = await TripService.getAllTrip();
      List<TruckModel> mainTrucks = await TruckService.retriveAllTruck();
      List<MinesModel> mainMines = await MinesService.getMinesList();
      List<DriverModel> mainDrivers = await DriverService.getAllDriver() ?? [];
      List<DriverModel> openToDriverList =
          await OpenDriverService.getAllOpenDriver();
      List<UserFavouriteModel> mainFavList =
          await FavService.retriveAllFav() ?? [];
      List<NewsModel> mainNews = await NewsService.getAllNews();
      return {
        "trips": mainTrips,
        "trucks": mainTrucks,
        "drivers": mainDrivers,
        "mines": mainMines,
        "owner_expense": [],
        "looking_jobs": openToDriverList,
        "favList": mainFavList,
        "promotion": [],
        "news": mainNews,
      };
    } else {
      if (!await DeviceInfoService.hasInternet()) {
        return null;
      }
      GlobalService.showProgress();
      ApiResponse serviceResponse = await _dioService
          .handleApiWithRetry(() => _dioService.get(ApiEndPoint.apiMain));
      GlobalService.dismissProgress();
      switch (serviceResponse.statusCode) {
        case 401:
          GlobalService.showAppToast(message: serviceResponse.message);
          return null;
        case 200:
          if (serviceResponse.data == null) return null;
          Map<String, dynamic> mainObj = serviceResponse.data ?? {};
          List<UserFavouriteModel> mainFavList = [];

          if (mainObj.containsKey('favList')) {
            List userFavModel = [];
            userFavModel.addAll(mainObj['favList']);
            // arrFavList.value = ;
            mainFavList = userFavModel
                .map((toElement) => UserFavouriteModel.fromJson(toElement))
                .toList();

            Map<String, UserFavouriteModel> favMap = {
              for (UserFavouriteModel fv in mainFavList) '${fv.id}': fv
            };

            int dbSuccess = await _dbService.putAllData<UserFavouriteModel>(
                tblUserFav, favMap);
            GlobalService.printHandler("Favourite Added in DB: $dbSuccess");
          }

          List<TruckModel> mainTrucks = [];
          if (mainObj.containsKey('trucks')) {
            mainTrucks = TruckModel.listFromJson(mainObj['trucks'],
                favList: mainFavList);
            final Map<String, TruckModel> truckMap = {
              for (var tm in mainTrucks) '${tm.id}': tm,
            };

            int insertSucess =
                await _dbService.putAllData<TruckModel>(tblTrucks, truckMap);
            GlobalService.printHandler('Truck insert $insertSucess');
          }

          List<DriverModel> mainDrivers = [];
          if (mainObj.containsKey('drivers')) {
            mainDrivers = DriverModel.listFromJson(mainObj['drivers'],
                favList: mainFavList);
            final Map<String, DriverModel> driverMap = {
              for (DriverModel dm in mainDrivers) '${dm.id}': dm,
            };

            int dBSuccess =
                await _dbService.putAllData<DriverModel>(tblDriver, driverMap);
            GlobalService.printHandler("Driver Added in DB: $dBSuccess");
          }

          List<TripModel> mainTrips = <TripModel>[];
          if (mainObj.containsKey('trips')) {
            mainTrips = TripModel.listFromJson(mainObj['trips']);
            Map<String, TripModel> tripMap = {
              for (TripModel trip in mainTrips) '${trip.id}': trip,
            };
            int tripInsert = await _dbService.putAllData<TripModel>(
              tblTrips,
              tripMap,
            );
            GlobalService.printHandler("Trip Added in DB: $tripInsert");
          }

          List mainOwnerExpense = [];
          if (mainObj.containsKey('owner_expense')) {
            mainOwnerExpense.clear();
            mainOwnerExpense.addAll(mainObj['owner_expense']);
          }

          List<DriverModel> openToDriverList = [];
          if (mainObj.containsKey('looking_jobs')) {
            openToDriverList =
                DriverModel.listFromJson(mainObj['looking_jobs']);
            Map<String, DriverModel> openDriverObj = {
              for (DriverModel odj in openToDriverList) "${odj.id}": odj
            };
            int dBJob = await _dbService.putAllData<DriverModel>(
                tblOpenDriver, openDriverObj);
            GlobalService.printHandler(
                "Open to Job Driver Added in DB: $dBJob");
          }

          List<MinesModel> mainMines = [];
          if (mainObj.containsKey('mines')) {
            mainMines =
                MinesModel.listFromJson(mainObj['mines'], favList: mainFavList);

            Map<String, MinesModel> mineListObj = {
              for (MinesModel m in mainMines) "${m.id}": m
            };
            int dBFav =
                await _dbService.putAllData<MinesModel>(tblMines, mineListObj);
            GlobalService.printHandler("Mines Added in DB: $dBFav");
          }

          List<dynamic> mainPromotion = [];
          if (mainObj.containsKey('promotion')) {
            mainPromotion.clear();
            mainPromotion.addAll(mainObj['promotion']);
          }

          List<NewsModel> mainNews = [];
          if (mainObj.containsKey('news')) {
            mainNews = NewsModel.listFromJson(mainObj['news']);
            Map<String, NewsModel> newsMap = {
              for (NewsModel news in mainNews) "${news.id}": news
            };
            int dbSuccess =
                await _dbService.putAllData<NewsModel>(tblNews, newsMap);
            GlobalService.printHandler("News Added in DB: $dbSuccess");
          }

          // Show Truck
          // arrTopTruck.addAll(mainTrucks);

          // Show Company
          // arrMines.addAll(mainMines);
          GlobalService.dismissProgress();
          return {
            "trips": mainTrips,
            "trucks": mainTrucks,
            "drivers": mainDrivers,
            "mines": mainMines,
            "owner_expense": mainOwnerExpense,
            "looking_jobs": openToDriverList,
            "favList": mainFavList,
            "promotion": mainPromotion,
            "news": mainNews,
          };
        default:
          GlobalService.dismissProgress();
          return null;
      }
    }
  }
}
