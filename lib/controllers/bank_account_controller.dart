import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/model/bank_account_model.dart';
import '/services/bank_account_service.dart';

class BankAccountController extends GetxController {
  static const int maxAccounts = 2;

  RxList<BankAccountModel> accounts = <BankAccountModel>[].obs;
  RxBool isLoading = false.obs;

  // Add / edit form controllers
  final TextEditingController accountNumberCtrl = TextEditingController();
  final TextEditingController confirmAccountCtrl = TextEditingController();
  final TextEditingController bankNameCtrl = TextEditingController();
  final TextEditingController ifscCtrl = TextEditingController();
  final TextEditingController holderNameCtrl = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, loadAccounts);
  }

  Future<void> loadAccounts() async {
    isLoading.value = true;
    final result = await BankAccountService.getAllAccounts();
    if (result != null) accounts.value = result;
    isLoading.value = false;
  }

  bool get canAddMore => accounts.length < maxAccounts;

  // Returns true if any account is still within the 30-day edit lock.
  // The "Add" button is also locked when the user last edited an account
  // within 30 days — server enforces the same rule, this is just UI feedback.
  bool get canAddOrEdit {
    if (accounts.isEmpty) return true;
    return accounts.every((a) => a.canEdit);
  }

  BankAccountModel? get primaryAccount =>
      accounts.firstWhereOrNull((a) => a.isPrimary);

  void populateFormForEdit(BankAccountModel account) {
    accountNumberCtrl.text = account.accountNumber ?? '';
    confirmAccountCtrl.text = account.accountNumber ?? '';
    bankNameCtrl.text = account.bankName ?? '';
    ifscCtrl.text = account.ifscCode ?? '';
    holderNameCtrl.text = account.holderName ?? '';
  }

  void clearForm() {
    accountNumberCtrl.clear();
    confirmAccountCtrl.clear();
    bankNameCtrl.clear();
    ifscCtrl.clear();
    holderNameCtrl.clear();
  }

  Future<void> submitAdd() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    Get.close(1);
    final body = {
      'ac_number': accountNumberCtrl.text.trim(),
      'bank_name': bankNameCtrl.text.trim(),
      'ifsc_code': ifscCtrl.text.trim().toUpperCase(),
      'holder_name': holderNameCtrl.text.trim(),
    };
    final added = await BankAccountService.addAccount(body);
    if (added != null) {
      accounts.add(added);
      clearForm();
      Get.back();
    }
  }

  Future<void> submitEdit(int id) async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    final body = {
      'ac_number': accountNumberCtrl.text.trim(),
      'bank_name': bankNameCtrl.text.trim(),
      'ifsc_code': ifscCtrl.text.trim().toUpperCase(),
      'holder_name': holderNameCtrl.text.trim(),
    };
    final updated = await BankAccountService.editAccount(id, body);
    if (updated != null) {
      final idx = accounts.indexWhere((a) => a.id == id);
      if (idx != -1) accounts[idx] = updated;
      clearForm();
      Get.back();
    }
  }

  Future<void> setPrimary(BankAccountModel account) async {
    if (account.id == null) return;
    final success = await BankAccountService.setPrimary(account.id!);
    if (success) {
      accounts.value = accounts.map((a) {
        return BankAccountModel(
          id: a.id,
          accountNumber: a.accountNumber,
          bankName: a.bankName,
          ifscCode: a.ifscCode,
          holderName: a.holderName,
          isPrimary: a.id == account.id,
          lastEditedAt: a.lastEditedAt,
        );
      }).toList();
    }
  }

  Future<void> deleteAccount(BankAccountModel account) async {
    if (account.id == null) return;
    final success = await BankAccountService.deleteAccount(account.id!);
    if (success) {
      accounts.removeWhere((a) => a.id == account.id);
    }
  }

  @override
  void onClose() {
    accountNumberCtrl.dispose();
    confirmAccountCtrl.dispose();
    bankNameCtrl.dispose();
    ifscCtrl.dispose();
    holderNameCtrl.dispose();
    super.onClose();
  }
}
