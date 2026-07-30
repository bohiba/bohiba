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
import 'package:intl/intl.dart';

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

  // ── Date / basic fields
  TextEditingController startAtController = TextEditingController();
  TextEditingController endedAtController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController totalWeightController = TextEditingController();
  TextEditingController tpNoController = TextEditingController();
  TextEditingController shortWeightController = TextEditingController();
  MoneyMaskedTextController rateController = MoneyMaskedTextController(
    initialValue: 00.00,
    precision: 2,
    leftSymbol: "₹",
    decimalSeparator: ".",
    thousandSeparator: ",",
  );

  final List<EnumTripStatus> tripStatus =
      EnumTripStatus.values.where((e) => e != EnumTripStatus.archived).toList();
  Rx<EnumTripStatus?> strStatus = Rxn<EnumTripStatus>();

  /// The currently selected origin company (shown in Origin field).
  Rxn<CompanyModel> selectedOriginCompany = Rxn<CompanyModel>();
  TextEditingController originController = TextEditingController();

  /// Live search results for origin.
  RxList<CompanyModel> originSearchResults = <CompanyModel>[].obs;

  /// Current overlay state for the origin search dropdown.
  Rx<EnumSearchState> originSearchState = EnumSearchState.idle.obs;

  Timer? _originSearchDebounce;

  // ── Destination company search ────────────────────────────────────────────
  Rxn<CompanyModel> selectedDestinationCompany = Rxn<CompanyModel>();
  RxList<CompanyModel> destinationSearchResults = <CompanyModel>[].obs;
  Rx<EnumSearchState> destinationSearchState = EnumSearchState.idle.obs;
  TextEditingController destinationController = TextEditingController();
  Timer? _destinationSearchDebounce;

  // ── Transporter search ────────────────────────────────────────────────────
  Rxn<CompanyModel> selectedTransporter = Rxn<CompanyModel>();
  RxList<CompanyModel> transporterSearchResults = <CompanyModel>[].obs;
  Rx<EnumSearchState> transporterSearchState = EnumSearchState.idle.obs;
  TextEditingController transporterController = TextEditingController();
  Timer? _transporterSearchDebounce;

  /// Minerals available for selection — loaded from the selected origin
  /// company's [mineralId] via MineralsService.getMineralsByIds.
  /// The [selectedMineral] mineral selected as the trip's material type.
  RxList<MineralModel> availableMinerals = <MineralModel>[].obs;
  Rxn<MineralModel> selectedMineral = Rxn<MineralModel>();
  TextEditingController mineralController = TextEditingController();

  DateTime pickedDate = DateTime.now();

  RxInt countUpdate = 0.obs;

  static final _displayFmt = DateFormat('dd-MM-yyyy');
  static final _apiFmt = DateFormat('yyyy-MM-dd');

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
    _originSearchDebounce?.cancel();
    if (query.trim().isEmpty || query.length < 3) {
      originSearchState.value = EnumSearchState.idle;
      originSearchResults.clear();
      return;
    }
    originSearchState.value = EnumSearchState.searching;
    _originSearchDebounce = Timer(const Duration(milliseconds: 500), () async {
      await _fetchMines(query.trim());
    });
  }

  /// Called when the user selects an origin company from the dropdown.
  /// Immediately loads the associated minerals from the local DB.
  Future<void> onOriginSelected(CompanyModel? company) async {
    selectedOriginCompany.value = company;
    originController.text = company?.name ?? '';
    selectedMineral.value = null;
    mineralController.clear();
    availableMinerals.clear();

    if (company?.mineralId != null &&
        (company?.mineralId?.isNotEmpty ?? false)) {
      await _loadMineralsForCompany(company?.mineralId?.toString() ?? '');
    }
  }

  void onDestinationQueryChanged(String query) {
    _destinationSearchDebounce?.cancel();
    if (query.trim().isEmpty || query.length < 3) {
      destinationSearchState.value = EnumSearchState.idle;
      destinationSearchResults.clear();
      return;
    }
    destinationSearchState.value = EnumSearchState.searching;
    _destinationSearchDebounce =
        Timer(const Duration(milliseconds: 500), () async {
      await _fetchPlants(query.trim());
    });
  }

  void onDestinationSelected(CompanyModel? company) {
    selectedDestinationCompany.value = company;
    destinationController.text = company?.name ?? '';
  }

  void onTransporterQueryChanged(String query) {
    _transporterSearchDebounce?.cancel();
    if (query.trim().isEmpty || query.length < 2) {
      transporterSearchState.value = EnumSearchState.idle;
      transporterSearchResults.clear();
      return;
    }
    transporterSearchState.value = EnumSearchState.searching;
    _transporterSearchDebounce =
        Timer(const Duration(milliseconds: 500), () async {
      await _fetchTransporters(query.trim());
    });
  }

  void onTransporterSelected(CompanyModel? company) {
    selectedTransporter.value = company;
    transporterController.text = company?.name ?? '';
  }

  Future<void> _fetchMines(String query) async {
    try {
      final results = await CompanyService.searchMines(query);
      originSearchResults.assignAll(results);
      originSearchState.value = results.isEmpty
          ? EnumSearchState.noDataFound
          : EnumSearchState.success;
    } catch (e) {
      GlobalService.printHandler('Mine search error: $e');
      originSearchState.value = EnumSearchState.error;
    }
  }

  Future<void> _fetchPlants(String query) async {
    try {
      final results = await CompanyService.searchPlants(query);
      destinationSearchResults.assignAll(results);
      destinationSearchState.value = results.isEmpty
          ? EnumSearchState.noDataFound
          : EnumSearchState.success;
    } catch (e) {
      GlobalService.printHandler('Plant search error: $e');
      destinationSearchState.value = EnumSearchState.error;
    }
  }

  Future<void> _fetchTransporters(String query) async {
    try {
      final results = await CompanyService.searchTransporters(query);
      transporterSearchResults.assignAll(results);
      transporterSearchState.value = results.isEmpty
          ? EnumSearchState.noDataFound
          : EnumSearchState.success;
    } catch (e) {
      GlobalService.printHandler('Transporter search error: $e');
      transporterSearchState.value = EnumSearchState.error;
    }
  }

  Future<void> _loadMineralsForCompany(String mineralIds) async {
    final minerals = await MineralsService.getMineralsByIds(mineralIds);
    availableMinerals.assignAll(minerals ?? []);
  }

  Future<int> addUpdateTrip() async {
    if (!globalKey.currentState!.validate()) return 0;
    final String rateTrip =
        rateController.text.replaceAll(RegExp(r'[₹,]'), '').trim();
    final int statusTrip = strStatus.value?.value ?? EnumTripStatus.draft.value;
    final String? startedAt = _toApiDate(startAtController.text);
    final String? endedAt = _toApiDate(endedAtController.text);
    final Map<String, dynamic> bodyObj = {
      'started_at': startedAt,
      'ended_at': endedAt,
      'transporter_id': selectedTransporter.value?.id,
      'regd_number': truckController.text.trim(),
      'driver_uuid': truckModel.value.driverUuid,
      'origin_id': selectedOriginCompany.value?.id,
      'destination_id': selectedDestinationCompany.value?.id,
      'tp_no': int.tryParse(tpNoController.text.trim()),
      'material_id': selectedMineral.value?.id,
      'trip_status': statusTrip,
      'load_weight': totalWeightController.text.trim(),
      'short_weight': shortWeightController.text.trim(),
      'rate': rateTrip,
    };
    int addOrUpdateSuccess = 0;
    if (tripModel.value == null) {
      addOrUpdateSuccess = await TripService.addTrip(
          bodyMap: bodyObj, truckModel: truckModel.value);
      if (addOrUpdateSuccess > 0) {
        countUpdate++;
        strStatus.value = EnumTripStatus.draft;
        truckModel.value = TruckModel();
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
    truckController.clear();
    originController.clear();
    destinationController.clear();
    transporterController.clear();
    mineralController.clear();
    tpNoController.clear();
    statusController.clear();
    totalWeightController.clear();
    shortWeightController.clear();
    rateController.updateValue(0.0);

    selectedOriginCompany.value = null;
    selectedDestinationCompany.value = null;
    selectedTransporter.value = null;
    selectedMineral.value = null;
    strStatus.value = null;
    availableMinerals.clear();

    originSearchResults.clear();
    destinationSearchResults.clear();
    transporterSearchResults.clear();
    originSearchState.value = EnumSearchState.idle;
    destinationSearchState.value = EnumSearchState.idle;
    transporterSearchState.value = EnumSearchState.idle;
  }

  // ═════════════════════════════════════════════════════════════════════════
  // Edit-mode pre-population
  // ═════════════════════════════════════════════════════════════════════════

  Future<void> editTripController() async {
    final trip = tripModel.value!;

    // ── Basic fields ───────────────────────────────────────────────────────
    // trip.startDate comes from _parseDate() → DateTime.toString() →
    // "2026-07-25 00:00:00.000". Convert to display format so the date
    // picker parses it correctly and the user sees dd-MM-yyyy.
    startAtController.text = _toDisplayDate(trip.startDate) ?? '';
    endedAtController.text = _toDisplayDate(trip.endedDate) ?? '';
    statusController.text = trip.tripStatus?.tripStatusName.toString() ?? '';
    totalWeightController.text = trip.loadDetail?.loadWeight.toString() ?? '';
    shortWeightController.text = trip.loadDetail?.shortWeight.toString() ?? '';
    tpNoController.text = trip.loadDetail?.tpNo.toString() ?? '';
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
          tripStatus.firstWhere((s) => s.index == trip.tripStatus);
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

    // ── Transporter company ────────────────────────────────────────────────
    if (trip.transporter?.id != null) {
      try {
        selectedTransporter.value = CompanyModel(
          id: trip.transporter?.id,
          name: trip.transporter?.name,
          nameCode: trip.transporter?.nameCode,
        );
      } catch (e) {
        GlobalService.printHandler('Edit trip transporter error: $e');
      }
    }
  }

  /// UI display format (dd-MM-yyyy) → API format (yyyy-MM-dd).
  /// Returns null when the input is blank or unparseable.
  static String? _toApiDate(String raw) {
    final s = raw.trim();
    if (s.isEmpty) return null;
    try {
      return _apiFmt.format(_displayFmt.parseStrict(s));
    } catch (_) {}
    try {
      // Fallback: DateTime.toString() e.g. "2026-07-25 00:00:00.000"
      return _apiFmt.format(DateTime.parse(s));
    } catch (_) {}
    return null;
  }

  /// Any raw date string → display format (dd-MM-yyyy) for the UI.
  /// Returns null when the input is blank or unparseable.
  static String? _toDisplayDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      return _displayFmt.format(DateTime.parse(raw.trim()));
    } catch (_) {}
    try {
      return _displayFmt.format(_displayFmt.parseStrict(raw.trim()));
    } catch (_) {}
    return null;
  }

  @override
  void onClose() {
    _originSearchDebounce?.cancel();
    _destinationSearchDebounce?.cancel();
    _transporterSearchDebounce?.cancel();

    startAtController.dispose();
    endedAtController.dispose();
    truckController.dispose();
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
