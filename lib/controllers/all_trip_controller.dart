import 'package:intl/intl.dart';

import '../dist/enums/app_enums.dart';
import '/extensions/ext_trip_status.dart';
import '/model/trip_model.dart';
import '/model/truck_model.dart';
import '/services/trip_service.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class AllTripController extends GetxController {
  RefreshController refreshController = RefreshController();
  final ScrollController scrollController = ScrollController();

  Rx<TripModel> tripModel = TripModel().obs;
  Rxn<List<TripModel>> arrTrip = Rxn<List<TripModel>>();

  RxBool isLoading = false.obs;
  RxBool hasMore = true.obs;
  int currentPage = 1;

  // --- Filter state (all client-side) ---
  Rxn<int> selectedStatus = Rxn<int>();
  Rxn<DateTime> filterFromDate = Rxn<DateTime>();
  Rxn<DateTime> filterToDate = Rxn<DateTime>();
  RxString selectedDateLabel = ''.obs;

  // Derived list shown in the UI — recomputed whenever source or any filter changes.
  RxList<TripModel> displayedTrips = <TripModel>[].obs;

  // All int status codes that have a display name (0-13 from ext_trip_status.dart).
  static const List<int> allStatusCodes = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13];

  @override
  void onInit() {
    super.onInit();

    // Recompute displayedTrips whenever the source list or any filter changes.
    ever(arrTrip, (_) => _applyFilters());
    ever(selectedStatus, (_) => _applyFilters());
    ever(filterFromDate, (_) => _applyFilters());
    ever(filterToDate, (_) => _applyFilters());

    TruckModel? vehicle = Get.arguments;
    Future.delayed(Duration.zero, () async {
      if (vehicle != null) {
        await filteredByTruck(truckNo: vehicle.regdNumber);
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

  // --- Filter logic ---

  void _applyFilters() {
    final source = arrTrip.value;
    if (source == null) {
      displayedTrips.clear();
      return;
    }
    var result = source.toList();

    if (selectedStatus.value != null) {
      result = result
          .where((t) => t.tripStatus == selectedStatus.value)
          .toList();
    }

    if (filterFromDate.value != null) {
      result = result.where((t) {
        final d = DateTime.tryParse(t.startDate ?? '');
        return d != null && !d.isBefore(filterFromDate.value!);
      }).toList();
    }

    if (filterToDate.value != null) {
      // Include the full end day by comparing against midnight of the next day.
      final endExclusive =
          filterToDate.value!.add(const Duration(days: 1));
      result = result.where((t) {
        final d = DateTime.tryParse(t.startDate ?? '');
        return d != null && d.isBefore(endExclusive);
      }).toList();
    }

    displayedTrips.assignAll(result);
  }

  void setStatusFilter(int? status) => selectedStatus.value = status;

  void setDatePreset(String label) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (label) {
      case 'Today':
        filterFromDate.value = today;
        filterToDate.value = today;
      case 'This Week':
        filterFromDate.value =
            today.subtract(Duration(days: today.weekday - 1));
        filterToDate.value = today;
      case 'This Month':
        filterFromDate.value = DateTime(now.year, now.month, 1);
        filterToDate.value = today;
    }
    selectedDateLabel.value = label;
  }

  void setCustomDateRange(DateTimeRange range) {
    filterFromDate.value = range.start;
    filterToDate.value = range.end;
    selectedDateLabel.value = 'Custom';
  }

  /// Called by FilterMenu's onApply callback.
  /// Dates arrive as `dd-MM-yyyy` strings (FilterMenu's DateInputField format).
  void applyFilterMenu(
      String? statusName, String? fromDate, String? toDate) {
    if (statusName != null && statusName.isNotEmpty) {
      final code = statusName.tripStatusCode;
      selectedStatus.value = code >= 0 ? code : null;
    } else {
      selectedStatus.value = null;
    }
    final fmt = DateFormat('dd-MM-yyyy');
    try {
      filterFromDate.value =
          fromDate != null && fromDate.isNotEmpty ? fmt.parse(fromDate) : null;
    } catch (_) {
      filterFromDate.value = null;
    }
    try {
      filterToDate.value =
          toDate != null && toDate.isNotEmpty ? fmt.parse(toDate) : null;
    } catch (_) {
      filterToDate.value = null;
    }
    selectedDateLabel.value =
        filterFromDate.value != null || filterToDate.value != null
            ? 'Custom'
            : '';
  }

  void clearFilters() {
    selectedStatus.value = null;
    filterFromDate.value = null;
    filterToDate.value = null;
    selectedDateLabel.value = '';
  }

  bool get hasActiveFilter =>
      selectedStatus.value != null || filterFromDate.value != null;

  // --- Data loading ---

  Future<void> getAllTrip({
    MethodType type = MethodType.local,
    bool showLoading = false,
    bool refreshTrip = false,
  }) async {
    arrTrip.value = null;
    List<TripModel>? newTrips = await TripService.getAllTrip(
        methodType: type, showProgress: showLoading, reset: refreshTrip);
    if (newTrips != null) {
      arrTrip.value = List<TripModel>.from(newTrips);
    }
  }

  Future<void> fetchTrips({bool refresh = false}) async {
    if (isLoading.isTrue) return;
    if (!hasMore.value && !refresh) return;

    isLoading.value = true;

    if (refresh) {
      currentPage = 1;
      hasMore.value = true;
      arrTrip.value = [];
    }

    try {
      if (currentPage == 1) {
        arrTrip.value = [];
        List<TripModel>? localTrips =
            await TripService.getAllTrip(methodType: MethodType.local);
        if (localTrips != null && localTrips.isNotEmpty) {
          arrTrip.value = List<TripModel>.from(localTrips);
        }
        currentPage++;
        hasMore.value = true;
        return;
      }

      // Page 1 already synced by the main API — always load-more from page 2.
      TripService.startFromPage2();
      List<TripModel>? newTrips = await TripService.getAllTrip(
        methodType: MethodType.api,
      );
      if (newTrips != null && newTrips.isNotEmpty) {
        final existing = List<TripModel>.from(arrTrip.value ?? []);
        for (final trip in newTrips) {
          if (!existing.any((t) => t.id == trip.id)) {
            existing.add(trip);
          }
        }
        arrTrip.value = existing;
        currentPage++;
      } else {
        hasMore.value = false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<TripModel>> filteredByTruck({String? truckNo}) async {
    List<TripModel>? arrTripModel =
        await TripService.filterTripWithTruckNo(truckNo: truckNo);
    if (arrTripModel != null) {
      arrTrip.value?.clear();
      arrTrip.value = List<TripModel>.from(arrTripModel);
    }
    return arrTripModel ?? [];
  }

  List<String> convertToSnakeCase(List<String> inputList) {
    return inputList
        .map((item) => item.toLowerCase().replaceAll(' ', '_'))
        .toList();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
