import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

import '/dist/app_enums.dart';
import '../model/owner_expenses_model.dart';
import '/services/owner_expense_service.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class AllOwnerExpenseController extends GetxController {
  final RefreshController refreshExpenseList = RefreshController();

  // Driver Details
  RxList<OwnerExpense> arrOwnerExp = <OwnerExpense>[].obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () async {
      await getOwnerExpenseList();
    });
  }

  Future<void> getOwnerExpenseList({
    MethodType methodType = MethodType.local,
    bool resetList = false,
  }) async {
    List<OwnerExpense>? expenseList = await OwnerExpenseService.getOwnerExpenseList(type: methodType, reset: resetList);

    if (expenseList != null) {
      arrOwnerExp.clear();
      arrOwnerExp.addAll(expenseList);
    }
  }

  Color? expenseColor(String severity) {
    switch (severity) {
      case 'low':
        return bohibaTheme.colorScheme.onPrimary;
      case 'medium':
        return bohibaTheme.colorScheme.tertiary;
      case 'high':
        return bohibaTheme.colorScheme.error;
      default:
        return bohibaTheme.textTheme.titleMedium!.color;
    }
  }
}
