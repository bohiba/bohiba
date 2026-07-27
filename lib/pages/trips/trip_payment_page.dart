import '/dist/enums/enum_trip_payment.dart';
import '/extensions/bohiba_extension.dart';
import '/routes/app_route.dart';
import '/services/global_service.dart';
import '../../dist/enums/app_enums.dart';
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
    final navigateState = Navigator.of(context);
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
                    tapDownDetails.globalPosition.dy + 10,
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
                          color: bohibaTheme.colorScheme.tertiary,
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
                    navigateState
                        .pushNamed(
                      AppRoute.addPayment,
                      arguments: controller.tripPayment.value,
                    )
                        .then((onValue) async {
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
                      onDiscard: () async {
                        navigateState.pop();
                        int deleteSuccess = await controller.deletePayment(
                          paymentId: controller.tripPayment.value.id!,
                        );
                        if (deleteSuccess > 0) {
                          navigateState.pop(true);
                        }
                      },
                      saveBtnTxt: 'CLOSE',
                      onSave: () => navigateState.pop(),
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
                title: controller.tripPayment.value.paidBy?.toDisplayLabel(),
              ),
              LinearBoxWidget(
                header: 'Payment Mode',
                title: EnumTripPaymentModeExt.fromIndex(
                        controller.tripPayment.value.paymentMode)
                    ?.displayName,
              ),
              LinearBoxWidget(
                header: 'Recivied By',
                title: EnumTripPaymentReceiverExt.fromIndex(
                        controller.tripPayment.value.receivedBy)
                    ?.displayName,
              ),
              LinearBoxWidget(
                header: 'Payment Type',
                title: EnumTripPaymentTypeExt.fromIndex(
                        controller.tripPayment.value.paymentType)
                    ?.displayName,
                // titleColor: bohibaTheme.colorScheme.onPrimary,
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
