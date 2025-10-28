import '/controllers/role_controller.dart';
import '/model/driver_model.dart';
import '/model/mines_model.dart';
import '/model/news_model.dart';
import '/model/trip_model.dart';
import '/model/truck_model.dart';
import '/services/news_service.dart';
import '/services/main_service.dart';
import '/services/driver_service.dart';
import '/services/truck_service.dart';
import 'package:get/get.dart';

import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class HomeController extends GetxController {
  RoleService initContorller = RoleService();

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  // RxList arrFav = [].obs;
  final RxList<dynamic> arrFavList = <dynamic>[].obs;
  final RxList<TripModel> arrTrip = <TripModel>[].obs;
  final RxList<TruckModel> arrTruck = <TruckModel>[].obs;
  final RxList<MinesModel> arrMines = <MinesModel>[].obs;
  final RxList<UserModel> arrDriver = <UserModel>[].obs;
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
    // await _getMinesList();
    await getDriverList();
    // await getUserFavList();
    refreshController.refreshCompleted();
  }

  /*Future<List<dynamic>> getUserFavList() async {
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
  }*/

  Future<List<UserModel>> getDriverList() async {
    List<UserModel> arrTucks = await DriverService.getAllDriver() ?? [];
    arrDriver.clear();
    arrDriver.addAll(arrTucks);
    return arrTucks;
  }

  Future<List<TruckModel>> getTruckList() async {
    List<TruckModel> truckList = await TruckService.getTruckList();
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
  }

  Future<List<MinesModel>> _getMinesList() async {
    List<MinesModel> minesList =
        await _dbService.getAllData<MinesModel>(tblMines);
    arrMines.clear();
    arrMines.addAll(minesList);
    return minesList;
  }*/

  Future<List<NewsModel>?> _getNewsList() async {
    List<NewsModel>? newsList = await NewsService.getAllNews();
    if (newsList != null) {
      arrNews.clear();
      arrNews.addAll(newsList);
    }
    return newsList;
  }

  Future<void> mainApi() async {
    Map<String, dynamic>? mainObj = await MainService.mainApi();
    if (mainObj != null) {
      if (mainObj.containsKey('trips')) {
        arrTrip.clear();
        arrTrip.addAll(mainObj['trips']);
      }

      if (mainObj.containsKey('trucks')) {
        arrTruck.clear();
        arrTruck.addAll(mainObj['trucks']);
      }

      if (mainObj.containsKey('drivers')) {
        arrDriver.clear();
        arrDriver.addAll(mainObj['drivers']);
      }

      if (mainObj.containsKey('mines')) {
        arrMines.clear();
        arrMines.addAll(mainObj['mines']);
      }

      if (mainObj.containsKey('owner_expense')) {
        arrOwnerExpense.clear();
        arrOwnerExpense.addAll(mainObj['owner_expense']);
      }

      if (mainObj.containsKey('looking_jobs')) {
        arrLookingJob.clear();
        arrLookingJob.addAll(mainObj['looking_jobs']);
      }

      if (mainObj.containsKey('promotion')) {
        arrPromotion.clear();
        arrPromotion.addAll(mainObj['promotion']);
      }

      if (mainObj.containsKey('news')) {
        arrNews.clear();
        arrNews.addAll(mainObj['news']);
      }
    }
  }
}
