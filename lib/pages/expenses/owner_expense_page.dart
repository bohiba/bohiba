import '../../dist/enums/app_enums.dart';
import '/dist/component_exports.dart';
import '/extensions/bohiba_extension.dart';
import '/pages/expenses/expense_component/expense_menu.dart';
import '/pages/widget/linear_box_widget.dart';
import '/pages/widget/status_box_widget.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '/controllers/owner_expense_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OwnerExpensePage extends GetView<OwnerExpenseController> {
  const OwnerExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    NavigatorState navigatorState = Navigator.of(context);
    return Obx(() {
      return Scaffold(
        appBar: TitleAppbar(
          title: controller.ownerExpense.value?.expenseType?.toCapitalizedLabel() ?? '',
          actions: [
            OwnerExpenseMenu(
              allowedActions: [
                ActionType.edit,
                ActionType.delete,
              ],
              onActionComplete: {
                ActionType.edit: (edit) async {
                  if (edit != null) {
                    controller.getExpense();
                  }
                },
                ActionType.delete: (delete) async {
                  if (delete != null) {
                    navigatorState.pop(true);
                  }
                }
              },
            ),
          ],
        ),
        body: SmartRefresher(
          controller: controller.refreshController,
          onRefresh: () async {
            controller.getExpense(methodType: MethodType.api, refreshPage: true);
            controller.refreshController.refreshCompleted();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: ScreenUtils.height10,
                bottom: ScreenUtils.height5,
                left: ScreenUtils.width15,
                right: ScreenUtils.width15,
              ),
              child: controller.ownerExpense.value == null
                  ? SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearBoxWidget(
                          header: 'Date',
                          title: controller.ownerExpense.value?.expenseDate,
                        ),
                        LinearBoxWidget(header: 'Vehicle', title: controller.ownerExpense.value?.truckRegd),
                        StatusBoxWidget(
                          header: 'Critical Level',
                          title: controller.ownerExpense.value?.severity?.toCapitalizedLabel(),
                          statusColor: controller.expenseColor(controller.ownerExpense.value?.severity ?? ''),
                        ),
                        LinearBoxWidget(
                          header: 'Amount',
                          title: "₹ ${controller.ownerExpense.value?.amount.toString()}",
                        ),
                        LinearBoxWidget(
                          header: 'Added on',
                          title: controller.ownerExpense.value?.createdAt,
                        ),
                        Gap(10.h),
                        Text(
                          'Service Type',
                          style: TextStyle(
                            fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                            fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                            color: bohibaTheme.textTheme.titleMedium!.color,
                          ),
                        ),
                        Text(
                          controller.ownerExpense.value?.expenseType?.toCapitalizedLabel() ?? '',
                          style: TextStyle(
                            fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                            fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
                            color: bohibaTheme.textTheme.bodyLarge!.color,
                          ),
                        ),
                        Gap(20.h),
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                            fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                            color: bohibaTheme.textTheme.titleMedium!.color,
                          ),
                        ),
                        Text(
                          controller.ownerExpense.value?.description ?? '',
                          style: TextStyle(
                            fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                            fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
                            color: bohibaTheme.textTheme.bodyLarge!.color,
                          ),
                        )
                      ],
                    ),
            ),
          ),
        ),
      );
    });
  }
}
