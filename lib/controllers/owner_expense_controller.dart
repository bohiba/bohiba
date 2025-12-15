import '/dist/app_enums.dart';
import '/model/owner_expenses_model.dart';
import '/services/owner_expense_service.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class OwnerExpenseController extends GetxController {
  RefreshController refreshController = RefreshController();
  Rxn<OwnerExpense> ownerExpense = Rxn<OwnerExpense>();

  @override
  void onInit() {
    ownerExpense.value = Get.arguments;
    super.onInit();

    if (ownerExpense.value != null) {
      Future.delayed(Duration.zero, () async {
        await getExpense();
      });
    }
  }

  Future<int> deleteExpense() async {
    int result = await OwnerExpenseService.delete(id: ownerExpense.value!.id!);
    return result;
  }

  Future<void> getExpense({
    MethodType methodType = MethodType.local,
    bool refreshPage = false,
  }) async {
    OwnerExpense? model = await OwnerExpenseService.getExpense(id: ownerExpense.value!.id!);
    if (model != null) {
      ownerExpense.value = model;
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
