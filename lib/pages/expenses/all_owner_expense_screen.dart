import 'package:bohiba/component/bohiba_appbar/appbar_icon.dart';
import 'package:bohiba/component/bohiba_appbar/title_appbar.dart';
import 'package:bohiba/component/screen_utils.dart';
import 'package:bohiba/controllers/all_owner_expense_controller.dart';
import 'package:bohiba/controllers/truck_all_controller.dart';
import 'package:bohiba/dist/app_enums.dart';
import 'package:bohiba/pages/expenses/expense_tile.dart';
import 'package:bohiba/pages/truck/truck_tile.dart';
import 'package:bohiba/pages/widget/permission_widget.dart';
import 'package:bohiba/routes/app_route.dart';
import 'package:bohiba/services/role_permission_service.dart';
import 'package:bohiba/theme/bohiba_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class AllOwnerExpenseScreen extends GetView<AllOwnerExpenseController> {
  final bool showLeading;
  const AllOwnerExpenseScreen({super.key, this.showLeading = true});

  @override
  Widget build(BuildContext context) {
    final NavigatorState navState = Navigator.of(context);
    return Scaffold(
      appBar: TitleAppbar(
        title: "All Owner Expenses",
        showLeading: showLeading,
        actions: [
          PermissionWidget(
            permission: RolePermissionService.addTrucks,
            child: AppBarIconBox(
              icon: const Icon(EvaIcons.plus),
              onTap: () {
                navState.pushNamed(AppRoute.addTruck).then(
                  (value) async {
                    if (value != null) {
                      await controller.getOwnerExpenseList();
                    }
                  },
                );
              },
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Obx(
          () {
            return SmartRefresher(
              controller: controller.refreshTruckList,
              onRefresh: () async => {
                await controller.getOwnerExpenseList(
                    methodType: MethodType.api, resetList: true),
                controller.refreshTruckList.refreshCompleted(),
              },
              child: controller.arrOwnerExp.isEmpty
                  ? Center(
                      child: SizedBox(
                        width: ScreenUtils.width * 0.65,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No Expense Found',
                              style: bohibaTheme.textTheme.displaySmall,
                            ),
                            Text(
                              'Add Your first expense to get started.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    bohibaTheme.textTheme.bodySmall!.fontSize,
                                fontWeight:
                                    bohibaTheme.textTheme.bodySmall!.fontWeight,
                                color: bohibaTheme.textTheme.titleSmall!.color,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                navState
                                    .pushNamed(AppRoute.addTruck)
                                    .then((onValue) async {
                                  if (onValue != null) {
                                    await controller.getOwnerExpenseList();
                                  }
                                });
                              },
                              child: Text('Add Expense'),
                            )
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(
                        top: ScreenUtils.height10,
                        bottom: ScreenUtils.height5,
                        left: ScreenUtils.width15,
                        right: ScreenUtils.width15,
                      ),
                      itemCount: controller.arrOwnerExp.length,
                      itemBuilder: (context, index) {
                        return ExpenseTile(
                        expenseInfo: controller.arrOwnerExp[index],
                          allowedActions: [
                            ActionType.view,
                            ActionType.add,
                            ActionType.edit,
                            ActionType.other,
                            ActionType.sync,
                          ],
                          onActionComplete: {
                            ActionType.view: (onValue) {},
                            ActionType.add: (onValue) {},
                            ActionType.edit: (onValue) async {
                              if (onValue != null) {
                                await controller.getOwnerExpenseList();
                              }
                            },
                            ActionType.other: (onValue) {
                              // Maintainance
                            },
                          },
                          onClick: () {
                            Get.toNamed(AppRoute.truck,
                                    arguments: controller.arrOwnerExp[index].id)
                                ?.then(
                              (onValue) async {
                                if (onValue != null) {
                                  await controller.getOwnerExpenseList();
                                  controller.arrOwnerExp.refresh();
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
            );
          },
        ),
      ),
    );
  }
}
