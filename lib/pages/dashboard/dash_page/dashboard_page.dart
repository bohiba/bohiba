import '/dist/app_enums.dart';
import '/routes/app_route.dart';
import '/services/global_service.dart';
import '/extensions/bohiba_extension.dart';
import '/services/role_permission_service.dart';
import '/controllers/dashboard_controller.dart';

import '/component/screen_utils.dart';
import '/component/bohiba_appbar/dashboard_appbar.dart';

import '/pages/widget/role_widget.dart';
import '/pages/about/about_page.dart';
import '/pages/widget/permission_widget.dart';
import '/pages/dashboard/dashboard_component/bluebox_component.dart';
import '/pages/dashboard/dashboard_component/small_tab_component.dart';
import '/pages/dashboard/dashboard_component/single_tile_tab_component.dart';

import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Scaffold(
      appBar: const DashAppBar(),
      body: SmartRefresher(
        controller: controller.refreshDashboard,
        onRefresh: () async {
          await controller.onRefreshDashPage();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: ScreenUtils.height20,
              left: ScreenUtils.width15,
              right: ScreenUtils.width15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Dashboard
                Obx(() {
                  return BlueBoxComponent(
                    label1: controller.profileModel.value?.name ?? '',
                    label2: controller.profileModel.value?.uuid,
                    label3: controller.profileModel.value?.roleId?.roleName(),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Row(
                          children: [
                            SmallTabComponent(
                              onTap: () {
                                navigator.pushNamed(AppRoute.userProfile);
                              },
                              label: "Profile",
                              icon: EvaIcons.personOutline,
                            ),

                            RoleWidget(
                              truckOwnerWidget: SmallTabComponent(
                                onTap: () {
                                  navigator.pushNamed(AppRoute.allOwnerExpense);
                                },
                                label: "Expense",
                                icon: EvaIcons.fileTextOutline,
                              ),
                            ),

                            PermissionWidget(
                              permission: RolePermissionService.viewDriver,
                              child: SmallTabComponent(
                                onTap: () {
                                  navigator.pushNamed(AppRoute.allDriver);
                                },
                                label: "Drivers",
                                icon: Icons.person_add_alt_1_outlined,
                              ),
                            ),

                            SmallTabComponent(
                              onTap: () {
                                navigator.pushNamed(AppRoute.allTrip);
                              },
                              label: "Trips",
                              icon: Icons.landscape_outlined,
                            ),

                            SmallTabComponent(
                              onTap: () {
                                navigator.pushNamed(AppRoute.allTruck);
                              },
                              label: "Trucks",
                              icon: EvaIcons.carOutline,
                            ),

                            RoleWidget(
                              truckOwnerWidget: SmallTabComponent(
                                onTap: () {
                                  navigator.pushNamed(AppRoute.allJobs);
                                },
                                label: "Jobs",
                                icon: EvaIcons.briefcaseOutline,
                              ),
                            ),

                            /*SmallTabComponent(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const WalletScreen(),
                                  ),
                                );
                              },
                              label: "Wallet",
                              icon: EvaIcons.briefcaseOutline,
                            ),*/

                            // KYC
                            SmallTabComponent(
                              onTap: () {
                                navigator.pushNamed(AppRoute.kyc);
                              },
                              label: "KYC",
                              icon: Icons.verified_outlined,
                            ),

                            /*SmallTabComponent(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const BankAccountsScreen(),
                                      ),
                                    );
                                  },
                                  label: "Bank Accounts",
                                  icon: EvaIcons.creditCardOutline,
                                ),*/
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                Gap(ScreenUtils.height10),

                /*
                SingleTileTabComponent(
                  onTap: () {
                    navigator.pushNamed(AppRoute.manageAccount);
                  },
                  icon: Icons.account_circle_outlined,
                  title: 'Manage Account',
                ),*/
                SingleTileTabComponent(
                  onTap: () {
                    navigator.pushNamed(AppRoute.setting).then((onValue) async {
                      if (onValue != null) {
                        // await controller.getProfileModel();
                      }
                    });
                  },
                  icon: EvaIcons.settingsOutline,
                  title: 'Settings',
                ),
                SingleTileTabComponent(
                  onTap: () {
                    navigator.pushNamed(AppRoute.security);
                  },
                  icon: Icons.fingerprint_outlined,
                  title: 'Security',
                ),
                SingleTileTabComponent(
                  onTap: () {
                    navigator.pushNamed(AppRoute.shareEarn);
                  },
                  icon: EvaIcons.shareOutline,
                  title: 'Share App',
                ),

                SingleTileTabComponent(
                  onTap: () {
                    navigator.pushNamed(AppRoute.policy);
                  },
                  icon: EvaIcons.lock,
                  title: 'Privacy & Policy',
                ),
                SingleTileTabComponent(
                  onTap: () {
                    navigator.pushNamed(AppRoute.contact);
                  },
                  icon: EvaIcons.questionMarkCircleOutline,
                  title: 'Contact & Support',
                ),
                SingleTileTabComponent(
                  onTap: () {
                    // navigator.pushNamed(AppRoute.reportIssue);
                    GlobalService.showDialog(
                      status: AlertStatus.info,
                      title: 'Under Developement',
                      description: 'This feature is currently under development and will be available in a future release. Stay tuned for updates!',
                      onExit: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                  icon: RemixIcons.bug_2_line,
                  title: 'Report an Issue',
                ),
                SingleTileTabComponent(
                  onTap: () {
                    navigator.push(MaterialPageRoute(builder: (context) => AboutPage()));
                  },
                  icon: EvaIcons.awardOutline,
                  title: 'About App',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
