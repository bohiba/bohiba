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

  RxBool isLoading = false.obs;
  RxBool hasMore = false.obs;
  int page = 1;

  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabs.length, vsync: this);
    TruckModel? vehicle = Get.arguments;
    Future.delayed(Duration.zero, () async {
      await getTripList(truckNo: vehicle?.regdNumber);
    });

    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 250 &&
          !isLoading.value &&
          hasMore.value) {
        await fetchTrips();
      }
    });
  }

  Future<void> refreshPage() async {
    // await Future.delayed(Duration(seconds: 4));
    await fetchTrips(refresh: true);
    refreshController.refreshCompleted();
    return;
  }

  Future<void> fetchTrips({bool refresh = false}) async {
    if (isLoading.value) {
      return;
    }

    if (refresh) {
      page = 1;
      hasMore.value = true;
      arrTrip.clear();
    }

    if (!hasMore.value) {
      return;
    }

    try {
      isLoading.value = true;
      final List<TripModel> newTrips =
          await TripService.retriveAllTrip(pageNo: page);
      if (newTrips.isNotEmpty) {
        arrTrip.addAll(newTrips);
        page++;
      } else {
        hasMore.value = false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<TripModel>> getTripList({String? truckNo}) async {
    arrTrip.value = await TripService.localAllTrip(truckNo: truckNo);
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
