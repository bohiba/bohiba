import 'dart:async';
import 'package:bohiba/controllers/all_owner_expense_controller.dart';
import 'package:bohiba/model/owner_expenses.dart';

import '/pages/widget/role_widget.dart';

import '/pages/truck/add_truck_component/truck_menu.dart';
import '/dist/app_enums.dart';
import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import '/controllers/truck_all_controller.dart';
import '/model/truck_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remixicon/remixicon.dart';

class ExpenseTile extends GetView<AllOwnerExpenseController> {
  final VoidCallback? onClick;
  final OwnerExpense expenseInfo;
  final List<ActionType> allowedActions;
  final Map<ActionType, FutureOr<void> Function(dynamic value)?>?
      onActionComplete;
  const ExpenseTile({
    super.key,
    this.onClick,
    required this.expenseInfo,
    required this.allowedActions,
    this.onActionComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: ScreenUtils.width15),
      width: ScreenUtils.width,
      height: ScreenUtils.height * 0.075,
      margin: EdgeInsets.only(bottom: ScreenUtils.width5),
      decoration: TileDecorative(),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onClick,
              child: Row(
                children: [
                  Container(
                    width: ScreenUtils.width * 0.095,
                    height: ScreenUtils.width * 0.095,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: BohibaColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Remix.truck_line,
                      color: BohibaColors.white,
                    ),
                  ),
                  Gap(ScreenUtils.height15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expenseInfo.truckRegd ?? '',
                        maxLines: 1,
                        style: bohibaTheme.textTheme.bodyMedium,
                      ),
                      RoleWidget(
                        truckOwnerWidget: Text(
                          expenseInfo.expenseType ?? 'Not Assigned',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize:
                                bohibaTheme.textTheme.titleMedium!.fontSize,
                            fontWeight:
                                bohibaTheme.textTheme.bodySmall!.fontWeight,
                            color: bohibaTheme.textTheme.titleMedium!.color,
                          ),
                        ),
                        driverWidget: expenseInfo.expenseDate != null
                            ? Text(
                                expenseInfo.expenseDate ?? '',
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: bohibaTheme
                                      .textTheme.titleMedium!.fontSize,
                                  fontWeight: bohibaTheme
                                      .textTheme.bodySmall!.fontWeight,
                                  color:
                                      bohibaTheme.textTheme.titleMedium!.color,
                                ),
                              )
                            : SizedBox.shrink(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
         /* TruckMenu(
            truck: expenseInfo,
            allowedActions: allowedActions,
            onActionComplete: onActionComplete,
            icon: Icon(Icons.more_vert_rounded),
          )*/
        ],
      ),
    );
  }
}
