import 'dart:async';
import 'dart:io';

import '/dist/enums/enum_trip_status.dart';
import '/component/bohiba_dropdown/app_search_dropdown_button.dart';
import '/extensions/ext_trip_status.dart';
import '/controllers/image_upload_controller.dart';
import '/dist/enums/app_enums.dart';
import '/dist/enums/enum_search_state.dart';
import '/model/company_model.dart';
import '/model/trip_model.dart';
import '/model/truck_model.dart';

import '/core/network/dio_serivce.dart';
import '/services/company_service.dart';
import '/services/minerals_service.dart';
import '/services/trip_service.dart';
import '/services/truck_service.dart';
import '/services/global_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';

class TripAddController extends ImageUploadController {
  DioService dioService = DioService();
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> startDateKey =
      GlobalKey<FormFieldState<String>>();

  // ── Trip model (null = add mode, non-null = edit mode) ──────────────────
  Rxn<TripModel> tripModel = Rxn<TripModel>();

  // ── Truck ────────────────────────────────────────────────────────────────
  Rx<TruckModel> truckModel = TruckModel().obs;
  RxList<TruckModel> arrTruck = <TruckModel>[].obs;
  TextEditingController truckController = TextEditingController();

  // ── Date / basic fields ──────────────────────────────────────────────────
  TextEditingController startAtController = TextEditingController();
  TextEditingController endedAtController = TextEditingController();
  TextEditingController transporterController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController totalWeightController = TextEditingController();
  TextEditingController shortWeightController = TextEditingController();
  MoneyMaskedTextController rateController = MoneyMaskedTextController(
    initialValue: 00.00,
    precision: 2,
    leftSymbol: "₹",
    decimalSeparator: ".",
    thousandSeparator: ",",
  );

  // ── Trip status ───────────────────────────────────────────────────────────
  final List<EnumTripStatus> tripStatus =
      EnumTripStatus.values.where((e) => e != EnumTripStatus.archived).toList();
  Rx<EnumTripStatus> strStatus = EnumTripStatus.draft.obs;

  // ── Origin company search ─────────────────────────────────────────────────
  /// The currently selected origin company (shown in Origin field).
  Rxn<CompanyModel> selectedOriginCompany = Rxn<CompanyModel>();

  /// Live search results for origin.
  RxList<CompanyModel> originSearchResults = <CompanyModel>[].obs;

  /// Current overlay state for the origin search dropdown.
  Rx<EnumSearchState> originSearchState = EnumSearchState.idle.obs;

  Timer? _originSearchDebounce;

  // ── Destination company search ────────────────────────────────────────────
  /// The currently selected destination company.
  Rxn<CompanyModel> selectedDestinationCompany = Rxn<CompanyModel>();

  /// Live search results for destination.
  RxList<CompanyModel> destinationSearchResults = <CompanyModel>[].obs;

  /// Current overlay state for the destination search dropdown.
  Rx<EnumSearchState> destinationSearchState = EnumSearchState.idle.obs;

  Timer? _destinationSearchDebounce;

  // ── Mineral (material type) ───────────────────────────────────────────────
  /// Minerals available for selection — loaded from the selected origin
  /// company's [mineralId] via MineralsService.getMineralsByIds.
  RxList<MineralModel> availableMinerals = <MineralModel>[].obs;

  /// The mineral selected as the trip's material type.
  Rxn<MineralModel> selectedMineral = Rxn<MineralModel>();

  DateTime pickedDate = DateTime.now();
  RxInt countUpdate = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tripModel.value = Get.arguments;

    Future.delayed(Duration.zero, () async {
      await getTruckList();
      if (tripModel.value != null) {
        await editTripController();
      }
    });
  }

  // ═════════════════════════════════════════════════════════════════════════
  // Company search — origin
  // ═════════════════════════════════════════════════════════════════════════

  /// Called by the Origin [AppDropdownSearch] on every keystroke.
  /// Debounces 500 ms then fires the API search.
  void onOriginQueryChanged(String query) {
    if (query.length < 3) return;

    _originSearchDebounce?.cancel();

    if (query.trim().isEmpty) {
      originSearchState.value = EnumSearchState.idle;
      originSearchResults.clear();
      return;
    }

    originSearchState.value = EnumSearchState.searching;
    _originSearchDebounce = Timer(const Duration(milliseconds: 500), () async {
      await _fetchCompanies(query.trim(), isOrigin: true);
    });
  }

  /// Called when the user selects an origin company from the dropdown.
  /// Immediately loads the associated minerals from the local DB.
  Future<void> onOriginSelected(CompanyModel? company) async {
    selectedOriginCompany.value = company;
    selectedMineral.value = null;
    availableMinerals.clear();

    if (company?.mineralId != null &&
        (company?.mineralId?.isNotEmpty ?? false)) {
      await _loadMineralsForCompany(company?.mineralId?.toString() ?? '');
    }
  }

  void onDestinationQueryChanged(String query) {
    if (query.length < 3) return;
    _destinationSearchDebounce?.cancel();

    if (query.trim().isEmpty) {
      destinationSearchState.value = EnumSearchState.idle;
      destinationSearchResults.clear();
      return;
    }

    destinationSearchState.value = EnumSearchState.searching;
    _destinationSearchDebounce =
        Timer(const Duration(milliseconds: 500), () async {
      await _fetchCompanies(query.trim(), isOrigin: false);
    });
  }

  void onDestinationSelected(CompanyModel? company) {
    selectedDestinationCompany.value = company;
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  Future<void> _fetchCompanies(String query, {required bool isOrigin}) async {
    try {
      final results = await CompanyService.searchCompanies(query);

      if (isOrigin) {
        originSearchResults.assignAll(results);
        originSearchState.value = results.isEmpty
            ? EnumSearchState.noDataFound
            : EnumSearchState.success;
      } else {
        destinationSearchResults.assignAll(results);
        destinationSearchState.value = results.isEmpty
            ? EnumSearchState.noDataFound
            : EnumSearchState.success;
      }
    } catch (e) {
      GlobalService.printHandler('Company search error: $e');
      if (isOrigin) {
        originSearchState.value = EnumSearchState.error;
      } else {
        destinationSearchState.value = EnumSearchState.error;
      }
    }
  }

  Future<void> _loadMineralsForCompany(String mineralIds) async {
    final minerals = await MineralsService.getMineralsByIds(mineralIds);
    availableMinerals.assignAll(minerals ?? []);
  }

  // ═════════════════════════════════════════════════════════════════════════
  // Add / update trip
  // ═════════════════════════════════════════════════════════════════════════

  Future<int> addUpdateTrip() async {
    if (!globalKey.currentState!.validate()) return 0;

    final String tripCode1 = truckController.text
        .trim()
        .substring(2, truckController.text.length - 4);
    final String tripCode2 = startAtController.text.trim().replaceAll('-', '');
    final String rateTrip =
        rateController.text.replaceAll(RegExp(r'[₹,]'), '').trim();
    final String statusTrip =
        statusController.text.trim().toLowerCase().replaceAll(' ', '_');

    final Map<String, dynamic> bodyObj = {
      'trip_code': tripCode1 + tripCode2,
      'started_at': startAtController.text.trim(),
      'ended_at': endedAtController.text.trim(),
      'transporter':
          transporterController.text.trim().replaceAll(' ', '_').toLowerCase(),
      'regd_number': truckController.text.trim(),
      'driver_uuid': truckModel.value.driverUuid,
      // Send company IDs (integers) instead of free-text strings.
      'origin_id': selectedOriginCompany.value?.id,
      'destination_id': selectedDestinationCompany.value?.id,
      // Material type as snake_case mineral name.
      'material_type':
          selectedMineral.value?.name?.toLowerCase().replaceAll(' ', '_'),
      'trip_status': statusTrip,
      'load_weight': totalWeightController.text.trim(),
      'short_weight': shortWeightController.text.trim(),
      'rate': rateTrip,
    };

    // return 0;

    int addOrUpdateSuccess = 0;
    if (tripModel.value == null) {
      addOrUpdateSuccess = await TripService.addTrip(
          bodyMap: bodyObj, truckModel: truckModel.value);
      if (addOrUpdateSuccess > 0) {
        countUpdate++;
        clearController();
      }
    } else {
      addOrUpdateSuccess = await TripService.updateTrip(
        bodyMap: bodyObj,
        trip: tripModel.value!,
      );
      if (addOrUpdateSuccess > 0) {
        countUpdate++;
        clearController();
      }
    }
    return addOrUpdateSuccess;
  }

  // ═════════════════════════════════════════════════════════════════════════
  // Truck list
  // ═════════════════════════════════════════════════════════════════════════

  Future<void> getTruckList() async {
    List<TruckModel>? truckList = await TruckService.getTruckList();
    if (truckList != null) {
      arrTruck.clear();
      arrTruck.addAll(truckList);
    }
  }

  // ═════════════════════════════════════════════════════════════════════════
  // Clear / reset
  // ═════════════════════════════════════════════════════════════════════════

  void clearController() {
    startAtController.clear();
    endedAtController.clear();
    transporterController.clear();
    truckController.clear();
    statusController.clear();
    totalWeightController.clear();
    shortWeightController.clear();
    rateController.updateValue(0.0);

    // Reset company / mineral selections.
    selectedOriginCompany.value = null;
    selectedDestinationCompany.value = null;
    selectedMineral.value = null;
    availableMinerals.clear();
    originSearchResults.clear();
    destinationSearchResults.clear();
    originSearchState.value = EnumSearchState.idle;
    destinationSearchState.value = EnumSearchState.idle;
  }

  // ═════════════════════════════════════════════════════════════════════════
  // Edit-mode pre-population
  // ═════════════════════════════════════════════════════════════════════════

  Future<void> editTripController() async {
    final trip = tripModel.value!;

    // ── Basic fields ───────────────────────────────────────────────────────
    startAtController.text = trip.startDate ?? '';
    endedAtController.text = trip.endedDate ?? '';
    statusController.text = trip.tripStatus?.tripStatusName.toString() ?? '';
    totalWeightController.text = trip.loadDetail?.loadWeight.toString() ?? '';
    shortWeightController.text = trip.loadDetail?.shortWeight.toString() ?? '';
    rateController = MoneyMaskedTextController(
      initialValue: trip.loadDetail?.rate ?? 0.0,
      precision: 2,
      leftSymbol: "₹",
      decimalSeparator: ".",
      thousandSeparator: ",",
    );

    try {
      truckModel.value = arrTruck
          .firstWhere((truck) => truck.regdNumber == trip.truck?.regdNumber);
      strStatus.value =
          tripStatus.firstWhere((s) => s == trip.tripStatus?.toString());
    } catch (e) {
      GlobalService.printHandler('Edit trip status/truck error: $e');
    }

    // ── Origin company ─────────────────────────────────────────────────────
    // Fetch the full company record from the local DB (includes mineralId)
    // so we can pre-load the minerals and pre-select the material type.
    if (trip.origin?.id != null) {
      try {
        final company = await CompanyService.getCompany(trip.origin!.id!);
        if (company != null) {
          selectedOriginCompany.value = company;
          if (company.mineralId != null && company.mineralId!.isNotEmpty) {
            await _loadMineralsForCompany(company.mineralId!);
            // Try to match the saved material_type to a mineral in the list.
            final materialType = trip.loadDetail?.materialType;
            if (materialType != null) {
              selectedMineral.value = availableMinerals.firstWhereOrNull(
                (m) {
                  final name = m.name?.toLowerCase() ?? '';
                  return name == materialType.toLowerCase() ||
                      name.replaceAll(' ', '_') == materialType.toLowerCase();
                },
              );
            }
          }
        } else {
          // Company not in local DB — create a minimal stub for display only.
          selectedOriginCompany.value = CompanyModel(
            id: trip.origin?.id,
            name: trip.origin?.name,
            nameCode: trip.origin?.nameCode,
          );
        }
      } catch (e) {
        GlobalService.printHandler('Edit trip origin error: $e');
      }
    }

    // ── Destination company ────────────────────────────────────────────────
    if (trip.destination?.id != null) {
      try {
        final company = await CompanyService.getCompany(trip.destination!.id!);
        selectedDestinationCompany.value = company ??
            CompanyModel(
              id: trip.destination?.id,
              name: trip.destination?.name,
              nameCode: trip.destination?.nameCode,
            );
      } catch (e) {
        GlobalService.printHandler('Edit trip destination error: $e');
      }
    }
  }

  @override
  void onClose() {
    // Cancel any in-flight debounce timers.
    _originSearchDebounce?.cancel();
    _destinationSearchDebounce?.cancel();

    // Dispose all TextEditingControllers.
    startAtController.dispose();
    endedAtController.dispose();
    truckController.dispose();
    transporterController.dispose();
    statusController.dispose();
    totalWeightController.dispose();
    shortWeightController.dispose();

    super.onClose();
  }

  // ═════════════════════════════════════════════════════════════════════════
  // ImageUploadController stubs
  // ═════════════════════════════════════════════════════════════════════════

  @override
  void deleteImageFile(File file) {}

  @override
  Future<void> pickImage({required PickerType pickertype}) async {}
}
