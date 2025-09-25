import 'dart:async';
import 'package:bohiba/controllers/role_controller.dart';
import 'package:bohiba/services/role_permission_service.dart';

import '/component/bohiba_colors.dart';
import '/component/screen_utils.dart';
import '/component/ui/tile_decorative.dart';
import '/controllers/truck_all_controller.dart';
import '/dist/app_enums.dart';
import '/model/truck_model.dart';
import '/pages/truck/vehicle_detail_modal.dart';
import '/routes/app_route.dart';
import '/services/global_service.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TruckMenu extends GetView<TruckAllController> {
  final Icon? icon;
  final TruckModel truck;
  final List<ActionType> allowedActions;
  final Map<ActionType, FutureOr<void> Function(dynamic value)?>?
      onActionComplete;

  const TruckMenu({
    super.key,
    this.icon,
    required this.truck,
    required this.allowedActions,
    this.onActionComplete,
  });

  @override
  Widget build(BuildContext context) {
    final navigate = Navigator.of(context);
    return GestureDetector(
      onTapDown: (tapDownDetails) {
        final menuItems = <PopupMenuEntry<ActionType>>[];

        if (allowedActions.contains(ActionType.view)) {
          menuItems.add(
            const PopupMenuItem(
              value: ActionType.view,
              child: Text('View'),
            ),
          );
        }
        if (allowedActions.contains(ActionType.edit) &&
            RoleService.hasPermission(RolePermissionService.editTrucks)) {
          menuItems.add(
            const PopupMenuItem(
              value: ActionType.edit,
              child: Text('Edit'),
            ),
          );
        }
        if (allowedActions.contains(ActionType.add) &&
            RoleService.hasPermission(RolePermissionService.viewTrips)) {
          menuItems.add(
            const PopupMenuItem(
              value: ActionType.add,
              child: Text('Trips'),
            ),
          );
        }

        if (allowedActions.contains(ActionType.other) &&
            RoleService.hasPermission(RolePermissionService.viewMaintainance)) {
          menuItems.add(
            const PopupMenuItem(
              value: ActionType.other,
              child: Text('Maintainance'),
            ),
          );
        }

        if (allowedActions.contains(ActionType.delete) &&
            RoleService.hasPermission(RolePermissionService.deleteTrucks)) {
          menuItems.add(PopupMenuItem(
            value: ActionType.delete,
            child: Text(
              'Delete',
              style: TextStyle(
                color: BohibaColors.warningColor,
                fontStyle: bohibaTheme.textTheme.titleMedium!.fontStyle,
                fontWeight: bohibaTheme.textTheme.titleMedium!.fontWeight,
              ),
            ),
          ));
        }

        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
            tapDownDetails.globalPosition.dx,
            tapDownDetails.globalPosition.dy,
            0,
            0,
          ),
          shape: AppMenuShape(),
          items: menuItems,
        ).then((value) {
          if (!context.mounted) return;
          switch (value) {
            case ActionType.view:
              showModalBottomSheet(
                isScrollControlled: true,
                isDismissible: false,
                shape: BottomModalShape(),
                context: context,
                builder: (context) {
                  return VehicleDetailModal(
                    vehicleDetails: truck,
                  );
                },
              ).then((result) {
                if (onActionComplete?[ActionType.view] != null) {
                  onActionComplete![ActionType.view]!(result);
                }
              });

              break;
            case ActionType.add:
              navigate
                  .pushNamed(
                AppRoute.allTrip,
                arguments: truck,
              )
                  .then((result) {
                if (onActionComplete?[ActionType.add] != null) {
                  onActionComplete![ActionType.add]!(result);
                }
              });
              break;
            case ActionType.edit:
              navigate
                  .pushNamed(
                AppRoute.editTruck,
                arguments: truck,
              )
                  .then((result) {
                if (onActionComplete?[ActionType.edit] != null) {
                  onActionComplete![ActionType.edit]!(result);
                }
              });

              break;
            case ActionType.delete:
              GlobalService.showAlertDialog(
                status: AlertStatus.warning,
                title: 'DELETE',
                description:
                    'Driver will be unlinked, but data will remain. Are you sure you want to delete this truck?',
                saveBtnTxt: 'Close',
                onSave: () {
                  navigate.pop();
                },
                discardBtnTxt: 'Delete',
                onDiscard: () async {
                  await controller.deleteTruck(truckId: truck.id!);
                },
              ).then((result) async {
                if (onActionComplete?[ActionType.delete] != null) {
                  onActionComplete![ActionType.delete]!(result);
                }
              });
              break;
            case ActionType.other:
              GlobalService.showAppToast(message: '#Maintainance');
              if (onActionComplete?[ActionType.other] != null) {
                onActionComplete![ActionType.other]!(null);
              }
              break;
            default:
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
