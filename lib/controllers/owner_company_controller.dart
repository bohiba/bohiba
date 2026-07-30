import 'dart:io';

import 'package:bohiba/extensions/bohiba_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '/model/location_model.dart';
import '/model/owner_company_model.dart';
import '/services/global_service.dart';
import '/services/location_data_service.dart';
import '/services/owner_company_service.dart';
import '/dist/enums/app_enums.dart';

class OwnerCompanyController extends GetxController {
  // ── State ─────────────────────────────────────────────────────
  final Rxn<OwnerCompanyModel> company = Rxn();
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;

  // ── Create / Edit form controllers ────────────────────────────
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final websiteCtrl = TextEditingController();

  // ── Location reference data (states + districts from GET /locations) ────────
  final Rxn<LocationData> locationData = Rxn();
  final RxBool isLoadingLocations = false.obs;

  // Derived reactive lists driven by the selected state.
  List<StateModel> get states => locationData.value?.states ?? [];
  List<DistrictModel> get districtsForSelectedState => selectedStateId.value !=
          null
      ? (locationData.value?.districtsForState(selectedStateId.value!) ?? [])
      : (locationData.value?.districts ?? []);

  // ── Address form controllers ──────────────────────────────────
  final addressCtrl = TextEditingController();
  final pincodeCtrl = TextEditingController();
  final countryCtrl = TextEditingController(text: 'INDIA');
  // district/state are ID-based; store selected values reactively
  final RxnInt selectedDistrictId = RxnInt();
  final RxString selectedDistrictName = ''.obs;
  final RxnInt selectedStateId = RxnInt();
  final RxString selectedStateName = ''.obs;

  // ── Legal form controllers (BR-09: write-once; form cleared after submit) ──
  final gstCtrl = TextEditingController();
  final panCtrl = TextEditingController();
  final cinCtrl = TextEditingController();
  final regTypeCtrl = TextEditingController();
  final establishedYearCtrl = TextEditingController();
  final RxBool isSavingLegal = false.obs;

  // ── Contact form controllers ──────────────────────────────────
  final contactNameCtrl = TextEditingController();
  final contactPhoneCtrl = TextEditingController();
  final contactEmailCtrl = TextEditingController();
  final contactAddressCtrl = TextEditingController();
  final RxnInt selectedDesignation = RxnInt(0);
  // final Rxn<DateTime> contactAppointedDate = Rxn();
  final Rx<TextEditingController> contactAppointedDate =
      TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    fetchCompany();
  }

  // ── Fetch ─────────────────────────────────────────────────────
  Future<void> fetchCompany() async {
    isLoading.value = true;
    hasError.value = false;
    final result = await OwnerCompanyService.fetchCompany();
    isLoading.value = false;
    company.value = result;
    if (result?.address == null) {
      _ensureLocationsLoaded();
    }
  }

  Future<void> _ensureLocationsLoaded() async {
    if (locationData.value != null) return; // already loaded this session
    if (isLoadingLocations.value) return; // request already in-flight
    isLoadingLocations.value = true;
    final data = await LocationDataService.fetchLocations();
    isLoadingLocations.value = false;
    locationData.value = data;
  }

  // Call this before opening the address sheet so state/district dropdowns
  // are available even when the company already has an address (edit path).
  Future<void> ensureLocationsForAddressSheet() => _ensureLocationsLoaded();

  // ── Logo ──────────────────────────────────────────────────────
  Future<void> pickAndUploadLogo() async {
    final picker = ImagePicker();
    final picked =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;
    final newLogoPath = await OwnerCompanyService.uploadLogo(File(picked.path));
    if (newLogoPath != null) {
      company.value = company.value?.copyWith(logo: newLogoPath);
    }
  }

  // ── Create Company ────────────────────────────────────────────
  bool validateProfileForm() {
    if (nameCtrl.text.trim().isEmpty) {
      GlobalService.showSnackBar(
        status: AlertStatus.warning,
        title: 'Company',
        desc: 'Company name is required.',
      );
      return false;
    }
    return true;
  }

  Future<void> createCompany() async {
    if (!validateProfileForm()) return;
    Get.back();
    final result = await OwnerCompanyService.createCompany(
      name: nameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      website: websiteCtrl.text.trim(),
    );
    if (result != null) {
      company.value = result;
      Get.back();
    }
  }

  // ── Update Company ────────────────────────────────────────────
  void populateProfileForm() {
    final c = company.value;
    if (c == null) return;
    nameCtrl.text = c.name ?? '';
    emailCtrl.text = c.email ?? '';
    phoneCtrl.text = c.phone ?? '';
    websiteCtrl.text = c.website ?? '';
  }

  Future<void> updateCompany() async {
    if (!validateProfileForm()) return;
    Get.back();
    final success = await OwnerCompanyService.updateCompany(
      name: nameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      website: websiteCtrl.text.trim(),
    );

    if (success) {
      company.value = company.value?.copyWith(
        name: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        website: websiteCtrl.text.trim(),
      );
      Get.back();
    }
  }

  // ── Address ───────────────────────────────────────────────────
  void populateAddressForm() {
    final addr = company.value?.address;
    addressCtrl.text = addr?.address ?? '';
    pincodeCtrl.text = addr?.pincode ?? '';
    countryCtrl.text = addr?.country ?? 'INDIA';
    selectedStateName.value = addr?.state ?? '';
    selectedDistrictName.value = addr?.district ?? '';
  }

  void onStateSelected(StateModel? state) {
    selectedStateId.value = state?.id;
    selectedStateName.value = state?.name ?? '';
    // Clear district when state changes so stale ID is never sent.
    selectedDistrictId.value = null;
    selectedDistrictName.value = '';
  }

  void onDistrictSelected(DistrictModel? district) {
    selectedDistrictId.value = district?.id;
    selectedDistrictName.value = district?.name ?? '';
    // Auto-resolve state from district.stateId if the user picked district first.
    if (district != null && selectedStateId.value == null) {
      final st = locationData.value?.stateById(district.stateId);
      selectedStateId.value = st?.id;
      selectedStateName.value = st?.name ?? '';
    }
  }

  Future<void> saveAddress() async {
    if (addressCtrl.text.trim().isEmpty) {
      GlobalService.showSnackBar(
        status: AlertStatus.warning,
        title: 'Address',
        desc: 'Street address is required.',
      );
      return;
    }
    Get.back();
    final body = {
      "address": addressCtrl.text.trim(),
      "district": selectedDistrictId.value,
      "state": selectedStateId.value,
      "country": countryCtrl.text.trim().isNotEmpty
          ? countryCtrl.text.trim()
          : 'INDIA',
      "pincode": pincodeCtrl.text.trim(),
    };
    final result = await OwnerCompanyService.upsertAddress(body);
    if (result != null) {
      company.value = company.value?.copyWith(address: result);
      clearAddressForm();
    }
  }

  void clearAddressForm() {
    addressCtrl.clear();
    pincodeCtrl.clear();
    countryCtrl.clear();
    selectedStateName.value = '';
    selectedDistrictName.value = '';
    selectedStateId.value = null;
    selectedDistrictId.value = null;
  }

  // ── Contacts ──────────────────────────────────────────────────
  void clearContactForm() {
    contactNameCtrl.clear();
    contactPhoneCtrl.clear();
    contactEmailCtrl.clear();
    contactAddressCtrl.clear();
    selectedDesignation.value = 0;
    contactAppointedDate.value.clear();
  }

  void populateContactForm(CompanyContact c) {
    contactNameCtrl.text = c.name ?? '';
    contactPhoneCtrl.text = c.phone ?? '';
    contactEmailCtrl.text = c.email ?? '';
    contactAddressCtrl.text = c.address ?? '';
    selectedDesignation.value = c.designation ?? 0;
    contactAppointedDate.value.text = c.dateOfAppointed ?? '';
  }

  bool _validateContactForm() {
    if (contactNameCtrl.text.trim().isEmpty) {
      GlobalService.showSnackBar(
        status: AlertStatus.warning,
        title: 'Contact',
        desc: 'Contact name is required.',
      );
      return false;
    }
    if (contactPhoneCtrl.text.trim().isEmpty) {
      GlobalService.showSnackBar(
        status: AlertStatus.warning,
        title: 'Contact',
        desc: 'Phone number is required.',
      );
      return false;
    }
    return true;
  }

  Map<String, dynamic> _buildContactBody() {
    return CompanyContact(
      name: contactNameCtrl.text.trim(),
      phone: contactPhoneCtrl.text.trim(),
      email: contactEmailCtrl.text.trim(),
      address: contactAddressCtrl.text.trim(),
      designation: selectedDesignation.value ?? 0,
      dateOfAppointed: (contactAppointedDate.value.text).toYMD(),
    ).toJson();
  }

  Future<void> addContact() async {
    if (!_validateContactForm()) return;
    Get.back();
    final result = await OwnerCompanyService.addContact(_buildContactBody());
    if (result != null) {
      // The server returns the full contacts list. Merge by id so that
      // addAll(fullList) doesn't duplicate contacts already in the local model.
      final existing = company.value?.contacts ?? [];
      final existingIds = existing.map((c) => c.id).toSet();
      final merged = [
        ...existing,
        ...result.where((c) => !existingIds.contains(c.id)),
      ];
      company.value = company.value?.copyWith(contacts: merged);
      Get.back();
    }
  }

  Future<void> updateContact(int id) async {
    if (!_validateContactForm()) return;
    Get.back();
    final result =
        await OwnerCompanyService.updateContact(id, _buildContactBody());
    if (result != null) {
      final updatedContact = result.firstWhere(
        (c) => c.id == id,
        orElse: () => result.first,
      );
      final updatedContacts = (company.value?.contacts ?? [])
          .map((c) => c.id == id ? updatedContact : c)
          .toList();
      company.value = company.value?.copyWith(contacts: updatedContacts);
    }
  }

  Future<void> deleteContact(int id) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Remove contact'),
        content: const Text('Remove this contact from your company?'),
        actions: [
          TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Remove', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed != true) return;
    final success = await OwnerCompanyService.deleteContact(id);
    if (success) {
      final updated =
          (company.value?.contacts ?? []).where((c) => c.id != id).toList();
      company.value = company.value?.copyWith(contacts: updated);
    }
  }

  // ── Legal Details (BR-09 / BR-10 / BR-11) ────────────────────────

  // BR-11: at least one field non-empty before calling the API.
  bool _validateLegalForm() {
    final hasGst = gstCtrl.text.trim().isNotEmpty;
    final hasPan = panCtrl.text.trim().isNotEmpty;
    final hasCin = cinCtrl.text.trim().isNotEmpty;
    final hasRegType = regTypeCtrl.text.trim().isNotEmpty;
    final hasYear = establishedYearCtrl.text.trim().isNotEmpty;
    if (!hasGst && !hasPan && !hasCin && !hasRegType && !hasYear) {
      GlobalService.showSnackBar(
        status: AlertStatus.warning,
        title: 'Legal Details',
        desc: 'Please fill at least one field before submitting.',
      );
      return false;
    }
    if (hasGst) {
      final gst = gstCtrl.text.trim();
      if (gst.length != 15) {
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'GST',
          desc: 'GST number must be exactly 15 characters.',
        );
        return false;
      }
    }
    if (hasPan) {
      final pan = panCtrl.text.trim().toUpperCase();
      final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
      if (!panRegex.hasMatch(pan)) {
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'PAN',
          desc: 'Enter a valid 10-character PAN (e.g. ABCDE1234F).',
        );
        return false;
      }
    }
    if (hasYear) {
      final year = int.tryParse(establishedYearCtrl.text.trim());
      if (year == null || year < 1800 || year > DateTime.now().year) {
        GlobalService.showSnackBar(
          status: AlertStatus.warning,
          title: 'Established Year',
          desc: 'Enter a valid 4-digit year.',
        );
        return false;
      }
    }
    return true;
  }

  // BR-09: POST only — no edit, no delete; UI must hide this once submitted.
  Future<void> submitLegal() async {
    if (!_validateLegalForm()) return;
    Get.back();
    isSavingLegal.value = true;
    final body = CompanyLegal(
      gstNo: gstCtrl.text.trim().isNotEmpty
          ? gstCtrl.text.trim().toUpperCase()
          : null,
      panNo: panCtrl.text.trim().isNotEmpty
          ? panCtrl.text.trim().toUpperCase()
          : null,
      cinNo: cinCtrl.text.trim().isNotEmpty ? cinCtrl.text.trim() : null,
      registrationType:
          regTypeCtrl.text.trim().isNotEmpty ? regTypeCtrl.text.trim() : null,
      establishedYear: int.tryParse(establishedYearCtrl.text.trim()),
    ).toJson();
    final result = await OwnerCompanyService.submitLegal(body);
    isSavingLegal.value = false;
    if (result != null) {
      company.value = company.value?.copyWith(legal: result);
      Get.back(); // close sheet
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    websiteCtrl.dispose();
    addressCtrl.dispose();
    pincodeCtrl.dispose();
    countryCtrl.dispose();
    gstCtrl.dispose();
    panCtrl.dispose();
    cinCtrl.dispose();
    regTypeCtrl.dispose();
    establishedYearCtrl.dispose();
    contactNameCtrl.dispose();
    contactPhoneCtrl.dispose();
    contactEmailCtrl.dispose();
    contactAddressCtrl.dispose();
    super.onClose();
  }
}
