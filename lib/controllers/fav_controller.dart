import '/model/driver_model.dart';
import '/model/trip_model.dart';
import '/model/truck_model.dart';
import '/model/user_fav_model.dart';
import '/services/fav_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxList<UserFavouriteModel> arrFavList = <UserFavouriteModel>[].obs;

  late TabController marketTabController;

  final List<String> tabs = [
    'All',
    'Mine',
    'Driver',
    'Truck',
  ];

  @override
  void onInit() {
    super.onInit();

    Future.delayed(Duration.zero, () async {
      await getFavList();
    });
  }

  Future<void> getFavList() async {
    arrFavList.value = await FavService.localFavList();
  }

  List<dynamic> getFavListDetail({
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

  @override
  void onClose() {
    marketTabController.dispose();
    super.onClose();
  }
}
