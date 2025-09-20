import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '/model/driver_model.dart';
import '/model/mines_model.dart';
import '/model/news_model.dart';
import '/model/trip_model.dart';
import '/model/truck_model.dart';
import '/model/user_fav_model.dart';
import '/services/db_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  RxList arrNews = [].obs;
  RxList arrMines = [].obs;
  RxList arrFav = [].obs;
  RxList arrOngoingTrip = [].obs;
  RxList<TruckModel> arrTrucks = <TruckModel>[].obs;
  RxList<DriverModel> arrDriver = <DriverModel>[].obs;
  RxList<TripModel> arrAllTrips = <TripModel>[].obs;
  final DBService _dbService = DBService();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await getTruckList();
      // await _getOngoingTripList();
      await _getNewsList();
      await _getMinesList();
      await getDriverList();
      await getUserFavList();
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
    List<UserFavouriteModel> arrFavList =
        await _dbService.getAllData<UserFavouriteModel>(tblUserFav);
    List<dynamic> favList = _getFavListDetail(
      favList: arrFavList,
      trucks: arrTrucks,
      drivers: arrDriver,
      trips: arrAllTrips,
    );
    arrFav.clear();
    arrFav.addAll(favList);
    return favList;
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
    arrTrucks.clear();
    arrTrucks.addAll(truckList);
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
            final status = trip.status;
            final dateStr = trip.startDate;
            if (status != 'ongoing' || dateStr == null) return false;
            final String tripDate = dateStr;
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
