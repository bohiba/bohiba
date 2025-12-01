import '/extensions/bohiba_extension.dart';

import '/dist/app_enums.dart';
import '/model/trip_model.dart';
import '/model/truck_model.dart';
import '/services/trip_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class AllTripController extends GetxController {
  RefreshController refreshController = RefreshController();
  final ScrollController scrollController = ScrollController();

  Rx<TripModel> tripModel = TripModel().obs;
  Rxn<List<TripModel>> arrTrip = Rxn<List<TripModel>>();

  RxBool isLoading = false.obs;
  RxBool hasMore = true.obs;

  int currentPage = 1;

  final List<String> tripStatus = [
    'in_transit',
    'completed',
    'unloading',
    'delayed',
    'cancelled',
    'on_hold',
    'reassigned',
    'other',
  ];

  @override
  void onInit() {
    super.onInit();
    TruckModel? vehicle = Get.arguments;
    Future.delayed(Duration.zero, () async {
      if (vehicle != null) {
        await filteredTrips(truckNo: vehicle.regdNumber);
      } else {
        await fetchTrips();
      }
    });

    scrollController.addListener(() async {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 250 && !isLoading.value && hasMore.value) {
        await getAllTrip(type: MethodType.api);
      }
    });
  }

  Future<void> getAllTrip({
    MethodType type = MethodType.local,
    bool showLoading = false,
    bool refreshTrip = false,
  }) async {
    arrTrip.value = null;
    List<TripModel>? newTrips = await TripService.getAllTrip(methodType: type, showProgress: showLoading, reset: refreshTrip);
    if (newTrips != null) {
      arrTrip.value = List<TripModel>.from(newTrips);
    }
  }

  Future<void> fetchTrips({bool refresh = false}) async {
    if (isLoading.isTrue) return;
    if (!hasMore.value && !refresh) return;

    if (refresh == true) {
      currentPage = 1;
      hasMore.value = true;
      arrTrip.value?.clear();
    }

    try {
      if (currentPage == 1) {
        hasMore.value = false;
        arrTrip.value = [];
        List<TripModel>? localTrips = await TripService.getAllTrip(methodType: MethodType.local);
        if (localTrips != null && localTrips.isNotEmpty) {
          arrTrip.value = List<TripModel>.from(localTrips);
          arrTrip.value!.sort((a, b) {
            return b.startDate!.toDateTime().compareTo(a.startDate!.toDateTime());
          });
          isLoading.value = false;
          currentPage++;
        } else {
          arrTrip.value = [];
        }
        return;
      }
      isLoading.value = true;
      List<TripModel>? newTrips = await TripService.getAllTrip(
        methodType: MethodType.api,
        reset: refresh,
      );
      if (newTrips != null && newTrips.isNotEmpty) {
        for (TripModel trip in newTrips) {
          if (!arrTrip.value!.any((t) => t.id == trip.id)) {
            arrTrip.value?.add(trip);
          }
        }
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
    List<TripModel>? arrTripModel = await TripService.filterTripWithTruckNo(truckNo: truckNo);
    if (arrTripModel != null) {
      arrTrip.value?.clear();
      arrTrip.value = List<TripModel>.from(arrTripModel);
    }
    return arrTripModel ?? [];
  }

  List<TripModel>? getTripsByStatus(String status) {
    if (status == 'all') {
      return arrTrip.value;
    }
    return arrTrip.value?.where((trip) {
      return (trip.tripStatus! == status);
    }).toList();
  }

  List<String> convertToSnakeCase(List<String> inputList) {
    return inputList.map((item) => item.toLowerCase().replaceAll(' ', '_')).toList();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
