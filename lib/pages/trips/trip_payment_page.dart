import '/routes/app_route.dart';
import '/services/global_service.dart';
import '/dist/app_enums.dart';
import '/dist/component_exports.dart';
import '/pages/widget/linear_box_widget.dart';
import '/theme/bohiba_theme.dart';
import '/controllers/trip_payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripPaymentPage extends GetView<TripPaymentController> {
  const TripPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(
        title: 'Payment',
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
                          color: BohibaColors.warningColor,
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
                      AppRoute.addPayment,
                      arguments: controller.tripPayment.value,
                    )?.then((onValue) async {
                      if (onValue != null && onValue != false) {
                        await controller.getPayment();
                      }
                    });
                    break;
                  case ActionType.delete:
                    GlobalService.showAlertDialog(
                      status: AlertStatus.warning,
                      title: 'DELETE PAYMENT',
                      description:
                          'Payment details will be removed permanently! Are you sure you want to delete this driver?',
                      discardBtnTxt: 'DELETE',
                      onDiscard: () async => controller.deletePayment(
                        tripInfo: controller.tripController.tripInfo.value,
                        paymentId: controller.tripPayment.value.id!,
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
                title: controller.tripPayment.value.paymentTime,
              ),
              LinearBoxWidget(
                header: 'Recevied By',
                title: controller.tripPayment.value.paidBy,
              ),
              LinearBoxWidget(
                header: 'Payment Mode',
                title: controller.tripPayment.value.paymentMode,
              ),
              LinearBoxWidget(
                header: 'Recivied By',
                title: controller.tripPayment.value.receivedBy,
              ),
              LinearBoxWidget(
                header: 'Payment Type',
                title: controller.tripPayment.value.payerType,
                // titleColor: bohibaTheme.colorScheme.onSurface,
              ),
              LinearBoxWidget(
                header: 'Amount',
                title: "₹ ${controller.tripPayment.value.amount.toString()}",
              ),
            ],
          );
        }),
      ),
    );
  }
}
