import 'package:bohiba/dist/app_enums.dart';

import '/model/open_driver_model.dart';
import '/model/driver_model.dart';
import '/model/mines_model.dart';
import '/model/news_model.dart';
import '/model/profile_model.dart';
import '/model/trip_model.dart';
import '/model/truck_model.dart';
import '/model/user_fav_model.dart';

import '/services/profile_service.dart';
import '/services/device_info_service.dart';
import '/services/db_service.dart';
import '/services/global_service.dart';
import '/services/dio_serivce.dart';
import '/services/pref_utils.dart';
import '/services/api_end_point.dart';

import 'package:get/get.dart';

class MasterController extends GetxController {
  // final InitController _initController = Get.find<InitController>();
  // final AuthController _authController = Get.find<AuthController>();
  final PrefUtils _prefUtils = PrefUtils();
  final DioService _dio = DioService();
  final DBService _dbService = DBService();
  final RxList<UserFavouriteModel> arrFavList = <UserFavouriteModel>[].obs;
  final RxList<Map<dynamic, dynamic>> arrOngoingTrip =
      <Map<dynamic, dynamic>>[].obs;
  final RxList arrTruck = [].obs;
  final RxList arrMines = [].obs;
  final RxList arrTopTruck = [].obs;
  // final RxList arrNews = [].obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await _prefUtils.init();
    });
  }

  Future<void> mainApi() async {
    if (!await DeviceInfoService.hasInternet()) {
      return;
    }
    GlobalService.showProgress();
    // await _dbService.resetAndReInitDB();
    ApiResponse serviceResponse =
        await _dio.handleApiWithRetry(() => _dio.get(ApiEndPoint.apiMain));
    GlobalService.dismissProgress();
    switch (serviceResponse.statusCode) {
      case 401:
        GlobalService.showAppToast(message: serviceResponse.message);
        break;
      case 200:
        if (serviceResponse.data == null) return;
        Map<String, dynamic> mainObj = serviceResponse.data ?? {};
        List mainFavList = [];
        if (mainObj.containsKey('favList')) {
          mainFavList.clear();
          mainFavList.addAll(mainObj['favList']);
          arrFavList.value = mainFavList
              .map((toElement) => UserFavouriteModel.fromJson(toElement))
              .toList();

          Map<String, UserFavouriteModel> favMap = {
            for (UserFavouriteModel fv in arrFavList) '${fv.id}': fv
          };

          int dbSuccess = await _dbService.putAllData<UserFavouriteModel>(
              tblUserFav, favMap);
          GlobalService.printHandler("Favourite Added in DB: $dbSuccess");
        }

        List mainTrucks = [];
        if (mainObj.containsKey('trucks')) {
          mainTrucks.clear();
          mainTrucks.addAll(mainObj['trucks']);

          List<TruckModel> arrTruckModel =
              TruckModel.listFromJson(mainObj['trucks'], favList: arrFavList);
          final Map<String, TruckModel> truckMap = {
            for (var tm in arrTruckModel) '${tm.id}': tm,
          };

          int insertSucess =
              await _dbService.putAllData<TruckModel>(tblTrucks, truckMap);
          GlobalService.printHandler('Truck insert $insertSucess');
        }

        List mainDrivers = [];
        if (mainObj.containsKey('drivers')) {
          mainDrivers.clear();
          mainDrivers.addAll(mainObj['drivers']);

          List<DriverModel> driverList =
              DriverModel.listFromJson(mainObj['drivers'], favList: arrFavList);
          final Map<String, DriverModel> driverMap = {
            for (DriverModel dm in driverList) '${dm.id}': dm,
          };

          int dBSuccess =
              await _dbService.putAllData<DriverModel>(tblDriver, driverMap);
          GlobalService.printHandler("Driver Added in DB: $dBSuccess");
        }

        List mainTrips = [];
        if (mainObj.containsKey('trips')) {
          mainTrips.clear();
          mainTrips.addAll(mainObj['trips']);
          final List<TripModel> tripList = TripModel.listFromJson(mainTrips);
          Map<String, TripModel> tripMap = {
            for (TripModel trip in tripList) '${trip.id}': trip,
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

        // List lookingJob = [];
        if (mainObj.containsKey('looking_job')) {
          final List<OpenDriverModel> openToDriverList =
              OpenDriverModel.listFromJson(mainObj['looking_job']);
          Map<String, OpenDriverModel> openDriverObj = {
            for (OpenDriverModel odj in openToDriverList) "${odj.id}": odj
          };
          int dBJob = await _dbService.putAllData(tblOpenDriver, openDriverObj);
          GlobalService.printHandler("Open to Job Driver Added in DB: $dBJob");
        }

        List mainMines = [];
        if (mainObj.containsKey('mines')) {
          mainMines.clear();
          mainMines.addAll(mainObj['mines']);

          final List<MinesModel> minesList =
              MinesModel.listFromJson(mainObj['mines'], favList: arrFavList);

          Map<String, MinesModel> mineListObj = {
            for (MinesModel m in minesList) "${m.id}": m
          };
          int dBFav =
              await _dbService.putAllData<MinesModel>(tblMines, mineListObj);
          GlobalService.printHandler("Mines Added in DB: $dBFav");
        }

        List mainNews = [];
        if (mainObj.containsKey('news')) {
          mainNews.clear();
          mainNews.addAll(mainObj['news']);

          final List<NewsModel> newsList =
              NewsModel.listFromJson(mainObj['news']);

          Map<String, NewsModel> newsMap = {
            for (NewsModel news in newsList) "${news.id}": news
          };
          int dbSuccess =
              await _dbService.putAllData<NewsModel>(tblNews, newsMap);
          GlobalService.printHandler("News Added in DB: $dbSuccess");
        }

        // Show Truck
        arrTopTruck.addAll(mainTrucks);

        // Show Company
        arrMines.addAll(mainMines);
        GlobalService.dismissProgress();
      default:
        GlobalService.dismissProgress();
        break;
    }
  }

  Future<ProfileModel?> profileApi({required MethodType methodType}) async {
    return await ProfileService.getProfile(type: methodType);
  }
}
