import 'dart:async';

import '/routes/app_route.dart';

import '/component/bohiba_colors.dart';
import '/component/screen_utils.dart';
import '/component/ui/tile_decorative.dart';
import '/controllers/trip_controller.dart';
import '/dist/app_enums.dart';
import '/model/trip_model.dart';
import '/services/global_service.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripMenu extends GetView<TripController> {
  final Icon? icon;
  final TripModel trip;
  final List<TripActionType> allowedActions;
  final Map<TripActionType, FutureOr<void> Function(dynamic value)?>?
      onActionComplete;
  const TripMenu({
    super.key,
    this.icon,
    required this.trip,
    required this.allowedActions,
    this.onActionComplete,
  });

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigatorState = Navigator.of(context);

    return GestureDetector(
      onPanDown: (details) {
        final menuItems = <PopupMenuEntry<TripActionType>>[];

        if (allowedActions.contains(TripActionType.edit)) {
          menuItems.add(
            const PopupMenuItem(
              value: TripActionType.edit,
              child: Text('Edit'),
            ),
          );
        }

        if (allowedActions.contains(TripActionType.expense)) {
          menuItems.add(
            const PopupMenuItem(
              value: TripActionType.expense,
              child: Text('Expense'),
            ),
          );
        }

        if (allowedActions.contains(TripActionType.payment)) {
          menuItems.add(
            const PopupMenuItem(
              value: TripActionType.payment,
              child: Text('Payment'),
            ),
          );
        }

        if (allowedActions.contains(TripActionType.reassignment)) {
          menuItems.add(
            const PopupMenuItem(
              value: TripActionType.reassignment,
              child: Text('Reassignment'),
            ),
          );
        }

        if (allowedActions.contains(TripActionType.document)) {
          menuItems.add(
            const PopupMenuItem(
              value: TripActionType.document,
              child: Text('Document'),
            ),
          );
        }

        if (allowedActions.contains(TripActionType.share)) {
          menuItems.add(
            const PopupMenuItem(
              value: TripActionType.share,
              child: Text('Share'),
            ),
          );
        }

        if (allowedActions.contains(TripActionType.delete)) {
          menuItems.add(
            PopupMenuItem(
              value: TripActionType.delete,
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

        /* if (allowedActions.contains(TripActionType.more)) {
          menuItems.add(
            const PopupMenuItem(
              value: TripActionType.more,
              child: Text('More Option'),
            ),
          );
        }*/

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
            case TripActionType.edit:
              navigatorState
                  .pushNamed(AppRoute.addTrip, arguments: trip)
                  .then((result) {
                if (onActionComplete?[TripActionType.edit] != null) {
                  onActionComplete![TripActionType.edit]!(result);
                }
              });
              break;

            case TripActionType.expense:
              navigatorState
                  .pushNamed(AppRoute.addExpense, arguments: trip)
                  .then((result) {
                if (onActionComplete?[TripActionType.expense] != null) {
                  onActionComplete![TripActionType.expense]!(result);
                }
              });
              break;

            case TripActionType.payment:
              navigatorState
                  .pushNamed(AppRoute.addPayment, arguments: trip)
                  .then((result) {
                if (onActionComplete?[TripActionType.payment] != null) {
                  onActionComplete![TripActionType.payment]!(result);
                }
              });

            case TripActionType.reassignment:
              navigatorState
                  .pushNamed(AppRoute.addReassignment, arguments: trip)
                  .then((result) {
                if (onActionComplete?[TripActionType.reassignment] != null) {
                  onActionComplete![TripActionType.reassignment]!(result);
                }
              });

              break;
            case TripActionType.share:
              break;
            case TripActionType.delete:
              GlobalService.showAlertDialog(
                status: AlertStatus.warning,
                title: 'DELETE',
                description:
                    'Trip and related data will be deleted permanently? Are you sure',
                discardBtnTxt: 'DELETE',
                onDiscard: () async {
                  controller.deleteTrip(
                    tripId: trip.id!,
                  );
                },
                saveBtnTxt: 'CLOSE',
                onSave: () => Get.back(),
              ).then((result) {
                if (onActionComplete?[TripActionType.payment] != null) {
                  onActionComplete![TripActionType.payment]!(result);
                }
              });
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

/*

 */

class TripMenuMoreOption extends StatelessWidget {
  const TripMenuMoreOption({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: ScreenUtils.width10,
      ),
      width: ScreenUtils.width40,
      child: Icon(Icons.more_vert_rounded),
    );
  }
}
