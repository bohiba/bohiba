import '/dist/app_enums.dart';
import '/extensions/bohiba_extension.dart';
import '/services/device_info_service.dart';

import '/services/trip_service.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '/model/trip_model.dart';
import '/model/truck_model.dart';
import '/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllTripController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RefreshController refreshController = RefreshController();
  late TabController tabController;
  final ScrollController scrollController = ScrollController();

  DBService dBService = DBService();
  Rx<TripModel> tripModel = TripModel().obs;
  RxList<TripModel> arrTrip = <TripModel>[].obs;

  final List<String> tabs = [
    'All',
    'In Transit',
    'Completed',
    'Unloading',
    'Delayed',
    'Cancelled',
    'On Hold',
    'Reassigned',
    'Other',
  ];

  List<String> get statuses => convertToSnakeCase(tabs);
  bool noInternet = false;

  RxBool isLoading = false.obs;
  RxBool hasMore = true.obs;
  int page = 1;

  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabs.length, vsync: this);
    TruckModel? vehicle = Get.arguments;
    Future.delayed(Duration.zero, () async {
      if (vehicle != null) {
        await filteredTrips(truckNo: vehicle.regdNumber);
      } else {
        await fetchTrips();
      }
    });

    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent &&
          !isLoading.value &&
          hasMore.value) {
        await fetchTrips();
      }
    });
  }

  Future<void> refreshPage() async {
    await fetchTrips(refresh: true);
    refreshController.refreshCompleted();
    return;
  }

  Future<void> fetchTrips({bool refresh = false}) async {
    if (isLoading.value) {
      return;
    }

    if (!hasMore.value) {
      return;
    }

    if (refresh == true) {
      page = 1;
      hasMore.value = true;
      arrTrip.clear();
    }

    try {
      isLoading.value = true;
      MethodType methodType;
      if (page == 1) {
        methodType = MethodType.local;
      } else if (page == 2) {
        noInternet = await DeviceInfoService.hasInternet();
        if (noInternet) {
          methodType = MethodType.local;
          arrTrip.clear();
        } else {
          methodType = MethodType.api;
        }
      } else {
        methodType = MethodType.api;
      }

      final List<TripModel> newTrips = await TripService.getAllTrip(
        methodType: methodType,
        reset: refresh,
      );

      if (newTrips.isNotEmpty) {
        arrTrip.addAll(newTrips);
        arrTrip.sort((a, b) =>
            (b.startDate!.toDateTime()).compareTo((a.startDate!.toDateTime())));
        page++;
      } else {
        hasMore.value = false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<TripModel>> filteredTrips({String? truckNo}) async {
    arrTrip.value = await TripService.filterTripWithTruckNo(truckNo: truckNo);
    return arrTrip;
  }

  List<TripModel> getTripsByStatus(String status) {
    if (status == 'all') {
      return arrTrip;
    }
    return arrTrip.where((trip) {
      return (trip.tripStatus! == status);
    }).toList();
  }

  List<String> convertToSnakeCase(List<String> inputList) {
    return inputList
        .map((item) => item.toLowerCase().replaceAll(' ', '_'))
        .toList();
  }

  @override
  void onClose() {
    tabController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
