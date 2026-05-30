import 'package:cached_network_image/cached_network_image.dart';

import '/pages/widget/role_widget.dart';
import '/component/image_path.dart';
import '/services/role_permission_service.dart';
import '/controllers/role_controller.dart';
import '/controllers/home_controller.dart';
import '/dist/component_exports.dart';
import '/dist/enums/app_enums.dart';
import '/theme/bohiba_theme.dart';
import '/routes/app_route.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeAppBar extends GetView<HomeController>
    implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigatState = Navigator.of(context);
    return Obx(
      () {
        return SliverAppBar(
          pinned: true,
          stretch: true,
          expandedHeight: 160.h,
          automaticallyImplyLeading: false,
          flexibleSpace: FlexibleSpaceBar(
            background: RoleWidget(
              truckOwnerWidget: Image.asset(
                ImagePath.truckOwnerBanner,
                fit: BoxFit.cover,
              ),
              driverWidget: Image.asset(
                ImagePath.driverBanner,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: GestureDetector(
            onTap: () {
              navigatState.pushNamed(AppRoute.userProfile);
            },
            child: Card(
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Container(
                height: 25.h,
                width: 25.h,
                decoration: BoxDecoration(
                  color: bohibaTheme.cardColor,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: controller.profile.value?.image == null ||
                        (controller.profile.value?.image?.isEmpty ?? true)
                    ? SizedBox.shrink()
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(6.r),
                        child: CachedNetworkImage(
                          imageUrl:
                              "${ImagePath.profileImage}/${controller.profile.value!.image}",
                          fit: BoxFit.cover,
                          placeholder: (context, child) {
                            return SizedBox.shrink();
                          },
                          errorWidget: (context, child, obj) {
                            return SizedBox.shrink();
                          },
                        ),
                      ),
              ),
            ),
          ),
          onStretchTrigger: () async {
            Future.delayed(Duration.zero, () async {
              await controller.onRefreshPage();
            });
          },
          actions: [
            AppBarIconBox(
              onTapDown: (TapDownDetails tapDownDetails) {
                final items = <PopupMenuEntry<ServiceType>>[];

                if (RoleService.hasPermission(
                    RolePermissionService.viewTrucks)) {
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

                if (RoleService.hasPermission(
                    RolePermissionService.viewDriver)) {
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

                if (RoleService.hasPermission(
                    RolePermissionService.viewTrips)) {
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
                    RolePermissionService.viewOwnerExpense)) {
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
                    tapDownDetails.globalPosition.dy,
                    0,
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
                      return navigatState
                          .pushNamed(AppRoute.allTruck)
                          .then((onValue) async {
                        if (onValue != null) {
                          await controller.getTruckList();
                        }
                      });
                    case ServiceType.expenses:
                      return navigatState.pushNamed(AppRoute.allOwnerExpense);
                    case ServiceType.manager:
                      break;

                    default:
                    // None
                  }
                });
              },
              icon: Icon(
                EvaIcons.plus,
                color: controller.isScrolled.value
                    ? bohibaTheme.iconTheme.color
                    : bohibaTheme.colorScheme.surface,
              ),
            ),

            //Notification
            /*AppBarIconBox(
                onTap: () {
                  navigatState.pushNamed(AppRoute.notifyScreen);
                },
                icon: const Icon(
                  EvaIcons.bellOutline,
                ),
              ),
        
              AppBarIconBox(
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoute.favList);
                },
                icon: Icon(Remix.heart_3_line),
              )*/
          ],
        );
      },
    );
  }
}
