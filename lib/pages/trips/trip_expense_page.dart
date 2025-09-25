import '/routes/app_route.dart';

import '/component/screen_utils.dart';
import '/extensions/bohiba_extension.dart';
import '/pages/widget/linear_box_widget.dart';

import '/component/bohiba_appbar/appbar_icon.dart';
import '/component/bohiba_appbar/title_appbar.dart';
import '/controllers/trip_expense_controller.dart';
import '/dist/app_enums.dart';
import '/services/global_service.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripExpensePage extends GetView<TripExpenseController> {
  const TripExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(
        title: 'Expense',
        actions: [
          AppBarIconBox(
            onTapDown: (tapDownDetails) {
              showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    tapDownDetails.globalPosition.dx,
                    tapDownDetails.globalPosition.dy + 15,
                    0,
                    0,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  items: [
                    PopupMenuItem(
                      value: ActionType.edit,
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                          fontWeight:
                              bohibaTheme.textTheme.titleSmall!.fontWeight,
                          color: bohibaTheme.textTheme.bodyMedium!.color,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: ActionType.delete,
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          color: bohibaTheme.colorScheme.error,
                          fontStyle:
                              bohibaTheme.textTheme.titleMedium!.fontStyle,
                          fontWeight:
                              bohibaTheme.textTheme.titleMedium!.fontWeight,
                        ),
                      ),
                    ),
                  ]).then((onValue) {
                switch (onValue) {
                  case ActionType.edit:
                    Get.toNamed(
                      AppRoute.addExpense,
                      arguments: controller.tripExpense.value,
                    )?.then((onValue) {
                      if (onValue != null && onValue != false) {
                        controller.getExpense();
                      }
                    });
                    break;
                  case ActionType.delete:
                    GlobalService.showAlertDialog(
                      status: AlertStatus.warning,
                      title: 'DELETE EXPENSE',
                      description:
                          'Payment details will be removed permanently! Are you sure you want to delete this driver?',
                      discardBtnTxt: 'DELETE',
                      onDiscard: () async => controller.deleteExpense(
                        tripInfo: controller.tripController.tripInfo.value,
                        expenseId: controller.tripExpense.value.id!,
                      ),
                      saveBtnTxt: 'CLOSE',
                      onSave: () => Get.back(),
                    );
                    break;
                  default:
                    null;
                    break;
                }
              });
            },
            icon: Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: ScreenUtils.height10,
          left: ScreenUtils.width15,
          right: ScreenUtils.width15,
          bottom: ScreenUtils.height20,
        ),
        child: Obx(() {
          return Column(
            children: [
              LinearBoxWidget(
                header: 'Date',
                title: controller.tripExpense.value.expenseDate,
              ),
              // LinearBoxWidget(
              //   header: 'Added By',
              //   title: controller.tripExpense.value.addedByUuid,
              // ),
              LinearBoxWidget(
                header: 'Payment Mode',
                title: controller.tripExpense.value.paymentMode,
              ),
              LinearBoxWidget(
                header: 'Payment Type',
                title: controller.tripExpense.value.expenseType!
                    .toCapitalizedLabel(),
              ),
              // LinearBoxWidget(
              //   header: 'Paid To',
              //   title: controller.tripExpense.value.paidTo?.toCapitalizedLabel(),
              // ),
              LinearBoxWidget(
                header: 'Amount',
                title: "₹ ${controller.tripExpense.value.paid.toString()}",
              ),
            ],
          );
        }),
      ),
    );
  }
}
