import '/dist/app_enums.dart';
import '/model/profile_model.dart';
import '/services/profile_service.dart';
import '/services/trip_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/user_model.dart';
import '/model/mines_model.dart';
import '/model/news_model.dart';
import '/model/trip_model.dart';
import '/model/truck_model.dart';
import '/services/main_service.dart';
import '/services/driver_service.dart';
import '/services/truck_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // RxList arrFav = [].obs;
  // final RxList<Map<String, dynamic>> emptySteps = <Map<String, dynamic>>[].obs;
  ScrollController scrollController = ScrollController();
  RxBool isScrolled = false.obs;

  final RxList<dynamic> arrFavList = <dynamic>[].obs;
  final Rxn<List<TripModel>> arrTrip = Rxn<List<TripModel>>();
  final Rxn<List<TruckModel>> arrTruck = Rxn<List<TruckModel>>();
  final Rxn<List<MinesModel>> arrMines = Rxn<List<MinesModel>>();
  final Rxn<List<UserModel>> arrDriver = Rxn<List<UserModel>>();
  final RxList arrOwnerExpense = [].obs;
  final RxList arrLookingJob = [].obs;
  final RxList arrPromotion = [].obs;
  final RxList<NewsModel> arrNews = <NewsModel>[].obs;
  final Rxn<ProfileModel> profile = Rxn<ProfileModel>();

  RxInt currentStep = 0.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await mainApi(showLoading: false);
      getProfile();
    });

    scrollController.addListener(() {
      bool scroll = scrollController.offset > 90.h;
      if (scroll != isScrolled.value) {
        isScrolled.value = scroll;
      }
    });
  }

  Future<void> onRefreshPage() async {
    await mainApi(methodType: MethodType.api, showLoading: true);
  }

  Future<void> getProfile() async {
    ProfileModel? profileModel = await ProfileService.getProfile(showProgress: false);
    if (profileModel != null) {
      profile.value = profileModel;
    }
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

  bool isStepEnabled(int stepIndex) {
    switch (stepIndex) {
      case 0:
        return arrDriver.value?.isEmpty ?? true;
      case 1:
        return arrTruck.value?.isEmpty ?? true;
      case 2:
        return arrTrip.value?.isEmpty ?? true;
      default:
        return false;
    }
  }

  Future<List<UserModel>> getDriverList() async {
    List<UserModel> arrTucks = await DriverService.getAllDriver() ?? [];
    arrDriver.value?.clear();
    arrDriver.value?.addAll(arrTucks);
    return arrTucks;
  }

  Future<void> getTruckList() async {
    arrTruck.value = null;
    List<TruckModel>? truckList = await TruckService.getTruckList();
    if (truckList != null) {
      arrTruck.value = List<TruckModel>.from(truckList);
    } else {
      arrTruck.value = [];
    }
  }

  Future<void> getTripList() async {
    List<TripModel>? tripList = await TripService.getAllTrip();
    if (tripList != null) {
      arrTrip.value?.clear();
      arrTrip.value?.addAll(tripList);
    }
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

  /*Future<List<NewsModel>?> _getNewsList() async {
    List<NewsModel>? newsList = await NewsService.getAllNews();
    if (newsList != null) {
      arrNews.clear();
      arrNews.addAll(newsList);
    }
    return newsList;
  }*/

  Future<void> mainApi({
    MethodType methodType = MethodType.local,
    bool refreshPage = false,
    bool showLoading = true,
  }) async {
    Map<String, dynamic>? mainObj = await MainService.mainApi(type: methodType, showProgress: showLoading);
    if (mainObj != null) {
      if (mainObj.containsKey('drivers')) {
        arrDriver.value?.clear();
        arrDriver.value = List.from(mainObj['drivers']);
      }

      if (mainObj.containsKey('trucks')) {
        arrTruck.value?.clear();
        arrTruck.value = List.from(mainObj['trucks']);
      }

      if (mainObj.containsKey('trips')) {
        arrTrip.value?.clear();
        arrTrip.value = List.from(mainObj['trips']);
      }

      if (mainObj.containsKey('mines')) {
        arrMines.value?.clear();
        arrMines.value = List.from(mainObj['mines']);
      }

      if (mainObj.containsKey('owner_expense')) {
        arrOwnerExpense.clear();
        arrOwnerExpense.value = List.from(mainObj['owner_expense']);
      }

      if (mainObj.containsKey('looking_jobs')) {
        arrLookingJob.clear();
        arrLookingJob.value = List.from(mainObj['looking_jobs']);
      }

      if (mainObj.containsKey('promotion')) {
        arrPromotion.clear();
        arrPromotion.value = List.from(mainObj['promotion']);
      }

      if (mainObj.containsKey('news')) {
        arrNews.clear();
        arrNews.value = List.from(mainObj['news']);
      }
    }
  }
}
