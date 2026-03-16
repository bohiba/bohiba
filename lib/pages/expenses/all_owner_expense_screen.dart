import 'owner_expense_tile.dart';
import '/component/screen_utils.dart';
import '/component/bohiba_appbar/appbar_icon.dart';
import '/component/bohiba_appbar/title_appbar.dart';
import '/dist/app_enums.dart';
import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';
import '/model/owner_expenses_model.dart';
import '/pages/widget/permission_widget.dart';
import '/services/role_permission_service.dart';
import '/controllers/all_owner_expense_controller.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class AllOwnerExpenseScreen extends GetView<AllOwnerExpenseController> {
  final bool showLeading;
  const AllOwnerExpenseScreen({super.key, this.showLeading = true});

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigateState = Navigator.of(context);
    return Obx(
      () {
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
                    navigateState.pushNamed(AppRoute.addOwnerExpense).then(
                      (value) async {
                        if (value != null && value != false) {
                          await controller.getOwnerExpenseList(methodType: MethodType.api);
                        }
                      },
                    );
                  },
                ),
              )
            ],
          ),
          body: SmartRefresher(
            controller: controller.refreshExpenseList,
            onRefresh: () async => {
              await controller.getOwnerExpenseList(methodType: MethodType.api, resetList: true),
              controller.refreshExpenseList.refreshCompleted(),
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
                              fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                              fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                              color: bohibaTheme.textTheme.titleSmall!.color,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              navigateState.pushNamed(AppRoute.addOwnerExpense).then((onValue) async {
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
                      OwnerExpense model = controller.arrOwnerExp[index];
                      return OwnerExpenseTile(
                        expenseInfo: model,
                        allowedActions: [
                          ActionType.view,
                          ActionType.add,
                          ActionType.edit,
                          ActionType.other,
                        ],
                        onActionComplete: {},
                        onClick: () {
                          navigateState.pushNamed(AppRoute.ownerExpense, arguments: model).then((onValue) async {
                            if (onValue != null) {
                              await controller.getOwnerExpenseList();
                            }
                          });
                        },
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
