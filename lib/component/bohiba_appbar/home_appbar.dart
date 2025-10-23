import '/component/image_path.dart';
import '/services/role_permission_service.dart';
import '/controllers/role_controller.dart';
import '/controllers/home_controller.dart';
import '/dist/component_exports.dart';
import '/dist/app_enums.dart';
import '/theme/bohiba_theme.dart';
import '/routes/app_route.dart';
import 'package:get/get.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends GetView<HomeController>
    implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigatState = Navigator.of(context);
    return PreferredSize(
      preferredSize: Size.fromHeight(ScreenUtils.height55),
      child: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 16,
        title: Image.asset(
          ImagePath.bohibaIcon,
          width: 80,
          alignment: Alignment.centerLeft,
        ),
        actions: [
          // Add Vehicle
          AppBarIconBox(
            onTapDown: (TapDownDetails tapDownDetails) {
              final items = <PopupMenuEntry<ServiceType>>[];

              if (RoleService.hasPermission(RolePermissionService.viewTrucks)) {
                items.add(
                  PopupMenuItem(
                    value: ServiceType.truck,
                    child: Text(
                      'Truck',
                      style: TextStyle(
                        fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                        fontWeight:
                            bohibaTheme.textTheme.titleSmall!.fontWeight,
                        color: bohibaTheme.textTheme.bodyMedium!.color,
                      ),
                    ),
                  ),
                );
              }

              if (RoleService.hasPermission(RolePermissionService.viewDriver)) {
                items.add(
                  PopupMenuItem(
                    value: ServiceType.driver,
                    textStyle: TextStyle(),
                    child: Text(
                      'Driver',
                      style: TextStyle(
                        fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                        fontWeight:
                            bohibaTheme.textTheme.titleSmall!.fontWeight,
                        color: bohibaTheme.textTheme.bodyMedium!.color,
                      ),
                    ),
                  ),
                );
              }

              if (RoleService.hasPermission(RolePermissionService.viewTrips)) {
                items.add(
                  PopupMenuItem(
                    value: ServiceType.trip,
                    child: Text(
                      'Trips',
                      style: TextStyle(
                        fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                        fontWeight:
                            bohibaTheme.textTheme.titleSmall!.fontWeight,
                        color: bohibaTheme.textTheme.bodyMedium!.color,
                      ),
                    ),
                  ),
                );
              }
              //Expenses Menu
              if (RoleService.hasPermission(
                  RolePermissionService.viewExpenses)) {
                items.add(
                  PopupMenuItem(
                    value: ServiceType.expenses,
                    textStyle: TextStyle(),
                    child: Text(
                      'Expenses',
                      style: TextStyle(
                        fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                        fontWeight:
                            bohibaTheme.textTheme.titleSmall!.fontWeight,
                        color: bohibaTheme.textTheme.bodyMedium!.color,
                      ),
                    ),
                  ),
                );
              }
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  tapDownDetails.globalPosition.dx,
                  tapDownDetails.globalPosition.dy + 25,
                  ScreenUtils.width50,
                  0,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                items: items,
              ).then((value) async {
                if (!context.mounted) return value;
                switch (value) {
                  case ServiceType.driver:
                    return await navigatState
                        .pushNamed(AppRoute.allDriver)
                        .then((onValue) async {
                      if (onValue != null) {
                        await controller.getDriverList();
                        controller.arrDriver.refresh();
                      }
                    });
                  case ServiceType.trip:
                    return navigatState.pushNamed(AppRoute.allTrip);
                  case ServiceType.truck:
                    return navigatState.pushNamed(AppRoute.allTruck).then(
                      (onValue) async {
                        if (onValue != null) {
                          await controller.getTruckList();
                          controller.arrTruck.refresh();
                        }
                      },
                    );
                  case ServiceType.expenses:
                    return navigatState.pushNamed(AppRoute.addOwnerExpense);
                  case ServiceType.manager:
                    break;

                  default:
                  // Manager
                }
              });
            },
            icon: const Icon(EvaIcons.plus),
          ),

          //Notification
          AppBarIconBox(
            onTap: () {
              navigatState.pushNamed(AppRoute.notifyScreen);
            },
            icon: const Icon(
              EvaIcons.bellOutline,
            ),
          ),

          /*AppBarIconBox(
            onTap: () {
              Navigator.of(context).pushNamed(AppRoute.favList);
            },
            icon: Icon(Remix.heart_3_line),
          )*/
        ],
      ),
    );
  }
}
