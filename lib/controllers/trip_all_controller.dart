import '/dist/app_enums.dart';
import '/extensions/bohiba_extension.dart';
import '/model/trip_model.dart';
import '/model/truck_model.dart';
import '/services/db_service.dart';
import '/services/trip_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

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
  RxBool hasMore = true.obs;

  int currentPage = 1;

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
              scrollController.position.maxScrollExtent - 250 &&
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
    if (isLoading.isTrue) return;
    if (!hasMore.value && !refresh) return;

    if (refresh == true) {
      currentPage = 1;
      hasMore.value = true;
      arrTrip.clear();
    }

    try {
      if (currentPage == 1) {
        hasMore.value = false;
        arrTrip.clear();
        List<TripModel> localTrips =
            await TripService.getAllTrip(methodType: MethodType.local);
        arrTrip.assignAll(localTrips);
        arrTrip.sort((a, b) =>
            b.startDate!.toDateTime().compareTo(a.startDate!.toDateTime()));
        isLoading.value = false;
        currentPage++;
        return;
      }
      isLoading.value = true;
      List<TripModel> newTrips = await TripService.getAllTrip(
        methodType: MethodType.api,
        reset: refresh,
      );
      if (newTrips.isNotEmpty) {
        for (TripModel trip in newTrips) {
          if (!arrTrip.any((t) => t.id == trip.id)) {
            arrTrip.add(trip);
          }
        }
        arrTrip.sort((a, b) =>
            (b.startDate!.toDateTime()).compareTo((a.startDate!.toDateTime())));
        currentPage++;
        return;
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
