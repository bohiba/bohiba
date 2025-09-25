import '/dist/app_enums.dart';
import '/routes/app_route.dart';
import '/services/global_service.dart';

import '/theme/bohiba_theme.dart';
import '/controllers/reassignment_controller.dart';
import '/dist/component_exports.dart';
import '/pages/widget/linear_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReassignmentPage extends GetView<ReassignmentController> {
  const ReassignmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigatorState = Navigator.of(context);
    return Scaffold(
      appBar: TitleAppbar(
        title: 'Reassignment',
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
                    navigatorState
                        .pushNamed(
                      AppRoute.addReassignment,
                      arguments: controller.reassignment.value,
                    )
                        .then((onValue) async {
                      if (onValue != null && onValue != false) {
                        await controller.getReassign();
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
                      onDiscard: () async => controller.deleteReassign(
                        tripInfo: controller.tripController.tripInfo.value,
                        expenseId: controller.reassignment.value.id!,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearBoxWidget(
                header: 'Date',
                title: controller.reassignment.value.date,
              ),
              LinearBoxWidget(
                header: 'Vechile Number',
                title: controller.reassignment.value.regdNumber,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: ScreenUtils.height10),
                child: Text(
                  'Reason',
                  style: TextStyle(
                    fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                    fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                    color: bohibaTheme.textTheme.titleMedium!.color,
                  ),
                ),
              ),
              Text(
                controller.reassignment.value.reason ?? '',
                style: TextStyle(
                  fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                  fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
                  color: bohibaTheme.textTheme.bodyLarge!.color,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
