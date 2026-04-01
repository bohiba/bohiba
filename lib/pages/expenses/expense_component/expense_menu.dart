import 'dart:async';

import '/component/ui/tile_decorative.dart';
import '/controllers/owner_expense_controller.dart';
import '/controllers/role_controller.dart';
import '../../../dist/enums/app_enums.dart';
import '/routes/app_route.dart';
import '/services/global_service.dart';
import '/services/role_permission_service.dart';
import '/theme/bohiba_theme.dart';
import 'package:get/get.dart';

import '/component/screen_utils.dart';
import 'package:flutter/material.dart';

class OwnerExpenseMenu extends GetView<OwnerExpenseController> {
  final Icon? icon;
  final List<ActionType> allowedActions;
  final Map<ActionType, FutureOr<void> Function(dynamic value)?>? onActionComplete;
  const OwnerExpenseMenu({super.key, this.icon, required this.allowedActions, this.onActionComplete});

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigatorState = Navigator.of(context);
    return GestureDetector(
      onTapDown: (details) {
        final menuItems = <PopupMenuEntry<ActionType>>[];
        if (allowedActions.contains(ActionType.edit) && RoleService.hasPermission(RolePermissionService.editOwnerExpense)) {
          menuItems.add(
            const PopupMenuItem(
              value: ActionType.edit,
              child: Text('Edit'),
            ),
          );
        }

        if (allowedActions.contains(ActionType.delete) && RoleService.hasPermission(RolePermissionService.deleteOwnerExpense)) {
          menuItems.add(
            PopupMenuItem(
              value: ActionType.delete,
              child: Text(
                'Delete',
                style: TextStyle(
                  color: bohibaTheme.colorScheme.tertiary,
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
        ).then((value) async {
          if (!context.mounted) return;
          switch (value) {
            case ActionType.edit:
              navigatorState
                  .pushNamed(
                AppRoute.addOwnerExpense,
                arguments: controller.ownerExpense.value,
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
                description: 'Expense will be deleted permanently? Are you sure',
                discardBtnTxt: 'DELETE',
                onDiscard: () async {
                  navigatorState.pop();
                  await controller.deleteExpense().then((result) {
                    if (onActionComplete?[ActionType.delete] != null) {
                      onActionComplete![ActionType.delete]!(result);
                    }
                  });
                },
                saveBtnTxt: 'CLOSE',
                onSave: () => Get.back(),
              ).then((result) {
                if (onActionComplete?[ActionType.delete] != null) {
                  onActionComplete![ActionType.delete]!(result);
                }
              });
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
