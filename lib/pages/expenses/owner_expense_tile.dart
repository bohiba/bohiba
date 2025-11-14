import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/controllers/all_owner_expense_controller.dart';

import '/dist/app_enums.dart';
import '/theme/bohiba_theme.dart';
import '/dist/component_exports.dart';
import '/model/owner_expenses_model.dart';
import '/extensions/bohiba_extension.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';

class OwnerExpenseTile extends GetView<AllOwnerExpenseController> {
  final VoidCallback? onClick;
  final OwnerExpense expenseInfo;
  final List<ActionType> allowedActions;
  final Map<ActionType, FutureOr<void> Function(dynamic value)?>?
      onActionComplete;
  const OwnerExpenseTile({
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
                      color: controller
                          .expenseColor(expenseInfo.severity ?? '')
                          ?.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.miscellaneous_services_outlined,
                      color:
                          controller.expenseColor(expenseInfo.severity ?? ''),
                    ),
                  ),
                  Gap(ScreenUtils.height15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expenseInfo.expenseType?.toCapitalizedLabel() ?? '',
                        maxLines: 1,
                        style: bohibaTheme.textTheme.bodyMedium,
                      ),
                      Row(
                        children: [
                          Text(
                            expenseInfo.expenseDate ?? '',
                            maxLines: 1,
                            style: TextStyle(
                              fontSize:
                                  bohibaTheme.textTheme.titleMedium!.fontSize,
                              fontWeight:
                                  bohibaTheme.textTheme.bodySmall!.fontWeight,
                              color: bohibaTheme.textTheme.titleMedium!.color,
                            ),
                          ),
                          Gap(10.w),
                          Text(
                            expenseInfo.severity?.toCapitalizedLabel() ?? '',
                            maxLines: 1,
                            style: TextStyle(
                              fontSize:
                                  bohibaTheme.textTheme.titleMedium!.fontSize,
                              fontWeight:
                                  bohibaTheme.textTheme.bodyMedium!.fontWeight,
                              color: controller
                                  .expenseColor(expenseInfo.severity ?? ''),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          /*TruckMenu(
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
