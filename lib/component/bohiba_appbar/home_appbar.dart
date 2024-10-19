import 'package:bohiba/services/add_type_service.dart';
import 'package:bohiba/pages/widget/app_theme/app_theme.dart';
import 'package:bohiba/routes/bohiba_route.dart';
import 'package:bohiba/component/screen_utils.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../bohiba_icon.dart';
import '../bohiba_search_delegate.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(BohibaResponsiveScreen.height55),
      child: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Image.asset(
          BohibaIcons.bohibaIcon,
          width: 55,
        ),
        actions: [
          // Add Vehicle
          HomeAppBarIconBox(
            onTapDown: (TapDownDetails tapDownDetails) {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  tapDownDetails.globalPosition.dx,
                  tapDownDetails.globalPosition.dy,
                  0,
                  0,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                items: [
                  /*PopupMenuItem(
                    value: AddType.addLoad,
                    child: Text(
                      'Add Load',
                      style: TextStyle(
                        fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                        fontWeight:
                            bohibaTheme.textTheme.titleSmall!.fontWeight,
                      ),
                    ),
                  ),*/
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
                    return Navigator.of(context)
                        .pushNamed(BohibaRoute.driverList);

                  case AddTypeService.addLoad:
                    // Add Load Page
                    break;
                  case AddTypeService.addVehicle:
                    return Navigator.of(context)
                        .pushNamed(BohibaRoute.addVehicle);

                  default:
                }
              });
            },
            icon: const Icon(
              EvaIcons.plus,
            ),
          ),

          // Search
          HomeAppBarIconBox(
            onTap: () => showSearch(
              context: context,
              delegate: BohibaCompanySearchDelegate(),
            ),
            icon: const Icon(
              EvaIcons.searchOutline,
            ),
          ),

          //Notification
          HomeAppBarIconBox(
            onTap: () => Get.toNamed(BohibaRoute.notifyScreen),
            icon: const Icon(
              EvaIcons.bellOutline,
            ),
          )
        ],
      ),
    );
  }
}

class HomeAppBarIconBox extends StatelessWidget {
  const HomeAppBarIconBox({super.key, this.onTap, this.onTapDown, this.icon});

  final VoidCallback? onTap;
  final Function(TapDownDetails)? onTapDown;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onTapDown: onTapDown,
      child: SizedBox(height: 40, width: 40, child: icon),
    );
  }
}
