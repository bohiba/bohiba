import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '/controllers/role_controller.dart';
import '/model/driver_model.dart';
import '/model/mines_model.dart';
import '/model/news_model.dart';
import '/model/trip_model.dart';
import '/model/truck_model.dart';
import '/model/user_fav_model.dart';
import '/services/db_service.dart';
import '/services/main_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RoleService initContorller = RoleService();
  final DBService _dbService = DBService();

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  // RxList arrFav = [].obs;
  final RxList<dynamic> arrFavList = <dynamic>[].obs;
  final RxList<TripModel> arrTrip = <TripModel>[].obs;
  final RxList<TruckModel> arrTruck = <TruckModel>[].obs;
  final RxList<MinesModel> arrMines = <MinesModel>[].obs;
  final RxList<DriverModel> arrDriver = <DriverModel>[].obs;
  final RxList arrOwnerExpense = [].obs;
  final RxList arrLookingJob = [].obs;
  final RxList arrPromotion = [].obs;
  final RxList<NewsModel> arrNews = <NewsModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await mainApi();
    });
  }

  Future<void> onRefreshPage() async {
    await getTruckList();
    // await _getOngoingTripList();
    await _getNewsList();
    await _getMinesList();
    await getDriverList();
    await getUserFavList();
    refreshController.refreshCompleted();
  }

  Future<List<dynamic>> getUserFavList() async {
    List<UserFavouriteModel> favList =
        await _dbService.getAllData<UserFavouriteModel>(tblUserFav);
    List<dynamic> favourite = _getFavListDetail(
      favList: favList,
      trucks: arrTruck,
      drivers: arrDriver,
      trips: arrTrip,
    );
    arrFavList.clear();
    arrFavList.addAll(favourite);
    return favourite;
  }

  Future<List<DriverModel>> getDriverList() async {
    List<DriverModel> arrTucks =
        await _dbService.getAllData<DriverModel>(tblDriver);
    arrDriver.clear();
    arrDriver.addAll(arrTucks);
    return arrTucks;
  }

  Future<List<TruckModel>> getTruckList() async {
    List<TruckModel> truckList =
        await _dbService.getAllData<TruckModel>(tblTrucks);
    arrTruck.clear();
    arrTruck.addAll(truckList);
    return truckList;
  }

  /*Future<List<TripModel>> _getOngoingTripList() async {
    List<TripModel> allTripList =
        await _dbService.getAllData<TripModel>(tblTrips);
    // Filter Onging Trip within last 7 days
    final now = DateTime.now();
    final oneWeekAgo = now.subtract(Duration(days: 7));
    List<TripModel> filterTrips = allTripList
        .where(
          (trip) {
            final status = trip.tripStatus;
            final dateStr = trip.startDate;
            if (status != 'ongoing' || dateStr == null) return false;
            final DateTime tripDate = dateStr;
            return tripDate.isAfter(oneWeekAgo) &&
                tripDate.isBefore(
                  now.add(
                    Duration(days: 1),
                  ),
                );
          },
        )
        .cast<TripModel>()
        .toList();
    arrAllTrips.clear();
    arrAllTrips.addAll(allTripList);
    arrOngoingTrip.clear();
    arrOngoingTrip.addAll(filterTrips);
    return allTripList;
  }*/

  Future<List<MinesModel>> _getMinesList() async {
    List<MinesModel> minesList =
        await _dbService.getAllData<MinesModel>(tblMines);
    arrMines.clear();
    arrMines.addAll(minesList);
    return minesList;
  }

  Future<List<NewsModel>> _getNewsList() async {
    List<NewsModel> newsList = await _dbService.getAllData<NewsModel>(tblNews);
    arrNews.clear();
    arrNews.addAll(newsList);
    return newsList;
  }

  Future<void> mainApi() async {
    Map<String, dynamic>? mainObj = await MainService.mainApi();
    if (mainObj != null) {
      if (mainObj.containsKey('trips')) {
        arrTrip.addAll(mainObj['trips']);
      }

      if (mainObj.containsKey('trucks')) {
        arrTruck.addAll(mainObj['trucks']);
      }

      if (mainObj.containsKey('drivers')) {
        arrDriver.addAll(mainObj['drivers']);
      }

      if (mainObj.containsKey('mines')) {
        arrMines.addAll(mainObj['mines']);
      }

      if (mainObj.containsKey('owner_expense')) {
        arrOwnerExpense.addAll(mainObj['owner_expense']);
      }

      if (mainObj.containsKey('looking_jobs')) {
        arrLookingJob.addAll(mainObj['looking_jobs']);
      }

      if (mainObj.containsKey('favList')) {
        arrFavList.value = List.from(
          _getFavListDetail(
            favList: mainObj['favList'],
            trucks: mainObj['trucks'],
            drivers: mainObj['drivers'],
            trips: mainObj['trips'],
          ),
        );
      }

      if (mainObj.containsKey('promotion')) {
        arrPromotion.addAll(mainObj['promotion']);
      }

      if (mainObj.containsKey('news')) {
        arrNews.addAll(mainObj['news']);
      }
    }
  }

  List<dynamic> _getFavListDetail({
    required List<UserFavouriteModel> favList,
    required List<TruckModel> trucks,
    required List<DriverModel> drivers,
    required List<TripModel> trips,
  }) {
    List<Map<String, dynamic>> result = [];

    for (var fav in favList) {
      final assetType = fav.assetType;
      final assetId = fav.assetId;

      if (assetType == 'trucks') {
        final TruckModel truck = trucks.firstWhere(
          (truck) => truck.id!.toString() == assetId.toString(),
          orElse: () => TruckModel(),
        );
        if (truck.id != null) {
          result.add(truck.toJson());
        }
      }

      if (assetType == 'drivers') {
        final DriverModel driver = drivers.firstWhere(
          (driver) => driver.id!.toString() == assetId.toString(),
          orElse: () => DriverModel(),
        );
        if (driver.id != null) {
          result.add(driver.toJson());
        }
      }

      if (assetType == 'trips') {
        final TripModel trip = trips.firstWhere(
            (trip) => trip.id!.toString() == assetId.toString(),
            orElse: () => TripModel());
        if (trip.id != null) {
          result.add(trip.toJson());
        }
      }
    }

    return result;
  }
}
