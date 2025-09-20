import '/routes/app_route.dart';
import '/controllers/dashboard_controller.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '/component/screen_utils.dart';
import '/component/bohiba_appbar/dashboard_appbar.dart';
import '/pages/dashboard/dashboard_component/bluebox_component.dart';
import '/pages/dashboard/dashboard_component/single_tile_tab_component.dart';
import '/pages/dashboard/dashboard_component/small_tab_component.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Scaffold(
      appBar: const DashAppBar(),
      body: SingleChildScrollView(
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
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Row(
                        children: [
                          SmallTabComponent(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         const UserProfilePage(),
                              //   ),
                              // );
                              navigator.pushNamed(AppRoute.userProfile);
                            },
                            label: "Profile",
                            icon: EvaIcons.personOutline,
                          ),

                          SmallTabComponent(
                            onTap: () {
                              navigator.pushNamed(AppRoute.allDriver);
                            },
                            label: "Drivers",
                            icon: Icons.person_add_alt_1_outlined,
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
                            label: "Vehicle",
                            icon: EvaIcons.carOutline,
                          ),

                          // TODO: On 2nd version
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

              /*SingleTileTabComponent(
                onTap: () {
                  controller.isSwitchedA.value = !controller.isSwitchedA.value;
                  Future.delayed(Duration.zero, () {
                    controller.themeChanger.toggleTheme();
                  });
                  controller.update();
                  GlobalService.printHandler(
                    controller.isSwitchedA.toString(),
                  );
                },
                icon: controller.isSwitchedA.value == true
                    ? Remix.sun_line
                    : EvaIcons.moonOutline,
                title: 'Dark Mode',
                trailing: Switch(
                  value: controller.isSwitchedA.value,
                  onChanged: (value) {
                    controller.isSwitchedA.value = value;
                    Future.delayed(Duration.zero, () {
                      controller.themeChanger.toggleTheme();
                    });
                    GlobalService.printHandler(
                      controller.isSwitchedA.toString(),
                    );
                  },
                ),
              ),*/
              SingleTileTabComponent(
                onTap: () {
                  navigator.pushNamed(AppRoute.setting);
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
                title: 'Share & Earn',
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
                  navigator.pushNamed(AppRoute.reportIssue);
                },
                icon: RemixIcons.bug_2_line,
                title: 'Report an Issue',
              ),
              SingleTileTabComponent(
                onTap: () {},
                icon: EvaIcons.awardOutline,
                title: 'About Us',
              ),
              /*SingleTileTabComponent(
                onTap: () async {
                  await controller.logout();
                },
                icon: EvaIcons.logOutOutline,
                iconColor: BohibaColors.warningColor,
                title: 'Logout',
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
