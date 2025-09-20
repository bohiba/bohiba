import 'dart:async';

import '/component/bohiba_colors.dart';
import '/component/screen_utils.dart';
import '/component/ui/tile_decorative.dart';
import '/controllers/driver_all_controller.dart';
import '/dist/app_enums.dart';
import '/extensions/bohiba_extension.dart';
import '/model/driver_model.dart';
import '/pages/driver/driver_modals/driver_detail_modal.dart';
import '/pages/driver/driver_modals/edit_driver_model.dart';
import '/routes/app_route.dart';
import '/services/global_service.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverMenu extends GetView<DriverAllController> {
  final Icon? icon;
  final DriverModel driver;
  final List<ActionType> allowedActions;
  final Map<ActionType, FutureOr<void> Function(dynamic value)?>?
      onActionComplete;
  const DriverMenu({
    super.key,
    this.icon,
    required this.driver,
    required this.allowedActions,
    this.onActionComplete,
  });

  @override
  Widget build(BuildContext context) {
    final NavigatorState navState = Navigator.of(context);

    return GestureDetector(
      onPanDown: (details) {
        final menuItems = <PopupMenuEntry<ActionType>>[];
        if (allowedActions.contains(ActionType.view)) {
          menuItems.add(
            const PopupMenuItem(
              value: ActionType.view,
              child: Text('View'),
            ),
          );
        }

        if (allowedActions.contains(ActionType.add)) {
          // menuItems.add(
          //   const PopupMenuItem(
          //     value: ActionType.add,
          //     child: Text('Add'),
          //   ),
          // );
        }

        if (allowedActions.contains(ActionType.edit)) {
          menuItems.add(
            const PopupMenuItem(
              value: ActionType.edit,
              child: Text('Edit'),
            ),
          );
        }

        /*if (allowedActions.contains(ActionType.route)) {
          menuItems.add(
            const PopupMenuItem(
              value: ActionType.route,
              child: Text('Calendar'),
            ),
          );
        }*/

        if (allowedActions.contains(ActionType.other)) {
          menuItems.add(
            const PopupMenuItem(
              value: ActionType.other,
              child: Text('Share'),
            ),
          );
        }

        if (allowedActions.contains(ActionType.delete)) {
          menuItems.add(
            PopupMenuItem(
              value: ActionType.delete,
              child: Text(
                'Delete',
                style: TextStyle(
                  color: BohibaColors.warningColor,
                  fontStyle: bohibaTheme.textTheme.titleMedium!.fontStyle,
                  fontWeight: bohibaTheme.textTheme.titleMedium!.fontWeight,
                ),
              ),
            ),
          );
        }

        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
            details.globalPosition.dx,
            details.globalPosition.dy,
            0,
            0,
          ),
          shape: AppMenuShape(),
          items: menuItems,
        ).then((actionType) {
          if (!context.mounted) return;

          switch (actionType) {
            case ActionType.view:
              showModalBottomSheet(
                isScrollControlled: true,
                isDismissible: false,
                shape: BottomModalShape(),
                context: context,
                builder: (context) {
                  return DriverDetialsModalSheet(driver: driver);
                },
              );
            case ActionType.add:
              break;
            case ActionType.route:
              navState.pushNamed(AppRoute.workCalender);
              break;

            case ActionType.edit:
              showModalBottomSheet(
                isScrollControlled: true,
                isDismissible: false,
                shape: BottomModalShape(),
                context: context,
                builder: (context) {
                  return DriverEditModel(
                    index: driver.id ?? 0,
                    name: driver.profile?.name ?? 'NA',
                    isFav: true,
                    // rating: 4.5,
                  );
                },
              );
              break;
            case ActionType.other:
              ShareDriverDetails(
                id: driver.id ?? 0,
                name: driver.profile?.name ?? '',
                dLNumber: driver.licenseDetail?.licenseNumber ?? '',
                vehicle: driver.licenseDetail?.status ?? '',
                mobileNo: driver.profile?.mobileNumber ?? '',
                dob: driver.profile?.dob ?? '',
                validUpto: driver.licenseDetail?.licenseNumber ?? '',
                type: driver.licenseDetail?.status ?? '',
              ).share();
              break;
            case ActionType.delete:
              GlobalService.showAlertDialog(
                  status: AlertStatus.warning,
                  title: 'DELETE',
                  description:
                      'Driver will remove from truck. Are you sure you want to delete this driver?',
                  discardBtnTxt: 'DELETE',
                  onDiscard: () async => controller.deleteDriver(
                        id: driver.id!.toString(),
                      ),
                  saveBtnTxt: 'CLOSE',
                  onSave: () => Get.back());
              break;
            default:
              null;
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(
          right: ScreenUtils.width10,
        ),
        width: ScreenUtils.width40,
        child: icon ?? Icon(Icons.more_vert_rounded),
      ),
    );
  }
}
