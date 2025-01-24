import '/services/add_type_service.dart';
import 'package:bohiba/theme/light_theme.dart';
import 'package:bohiba/routes/bohiba_route.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../dist/component_exports.dart';
import '../bohiba_icon.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(BohibaResponsiveScreen.height55),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 16,
        title: Image.asset(
          BohibaIcons.bohibaIcon,
          width: 55,
          alignment: Alignment.centerLeft,
        ),
        actions: [
          // Add Vehicle
          AppBarIconBox(
            onTapDown: (TapDownDetails tapDownDetails) {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  tapDownDetails.globalPosition.dx,
                  BohibaResponsiveScreen.height * 0.125,
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
                    value: AddTypeService.addDriver,
                    child: Text(
                      'Add Driver',
                      style: TextStyle(
                        fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                        fontWeight:
                            bohibaTheme.textTheme.titleSmall!.fontWeight,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: AddTypeService.addVehicle,
                    child: Text(
                      'Add Vehicle',
                      style: TextStyle(
                        fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                        fontWeight:
                            bohibaTheme.textTheme.titleSmall!.fontWeight,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: AddTypeService.addTrip,
                    child: Text(
                      'Add Trip',
                      style: TextStyle(
                        fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                        fontWeight:
                            bohibaTheme.textTheme.titleSmall!.fontWeight,
                      ),
                    ),
                  ),
                ],
              ).then((value) {
                switch (value) {
                  case AddTypeService.addDriver:
                    // Add Driver Page
                    return Navigator.of(context).pushNamed(AppRoute.driverList);

                  case AddTypeService.addLoad:
                    // Add Load Page
                    break;
                  case AddTypeService.addVehicle:
                    return Navigator.of(context).pushNamed(
                      AppRoute.addVehicle,
                    );

                  default:
                }
              });
            },
            icon: const Icon(EvaIcons.plus),
          ),

          // Search
          AppBarIconBox(
            onTap: () => showSearch(
              context: context,
              delegate: BohibaCompanySearchDelegate(),
            ),
            icon: const Icon(
              EvaIcons.searchOutline,
            ),
          ),

          //Notification
          AppBarIconBox(
            onTap: () => Get.toNamed(AppRoute.notifyScreen),
            icon: const Icon(
              EvaIcons.bellOutline,
            ),
          ),
        ],
      ),
    );
  }
}
