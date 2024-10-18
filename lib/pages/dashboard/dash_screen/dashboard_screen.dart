import 'package:bohiba/pages/load/screen/all_load_screen.dart';
import 'package:bohiba/pages/vehicle/all_vechile_screen/all_vehicle_screen.dart';
import 'package:bohiba/pages/vehicle/map.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:bohiba/utils/bohiba_appbar/dashboard_appbar.dart';
import 'package:bohiba/utils/bohiba_colors.dart';
import 'package:bohiba/pages/dashboard/dashboard_component/bluebox_component.dart';
import 'package:bohiba/pages/dashboard/dashboard_component/single_tile_tab_component.dart';
import 'package:bohiba/pages/user/user_kyc/kyc_screen.dart';
import 'package:bohiba/pages/user/user_profile/user_profile_screen/user_profile.dart';
import 'package:bohiba/pages/load_history/load_history_screen/load_history_screen.dart';
import 'package:remixicon/remixicon.dart';
import '../../wallet/bank_account_screen/bank_accounts_screen.dart';
import '../../wallet/wallet_screen/wallet_screen.dart';
import '../dashboard_component/small_tab_component.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _Dashboardpagestate();
}

class _Dashboardpagestate extends State<DashboardScreen> {
  bool isSwitchedA = false;
  bool isSwitchedB = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const DashAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Dashboard
                BlueBoxComponent(
                  label1: "My Dashboard",
                  label2: "6ZX096CT",
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Row(
                        children: [
                          SmallTabComponent(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const UserProfileScreen(),
                                ),
                              );
                            },
                            label: "Profile",
                            icon: EvaIcons.personOutline,
                          ),

                          SmallTabComponent(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AllLoadScreen(),
                                ),
                              );
                            },
                            label: "Load",
                            icon: Icons.landscape_outlined,
                          ),

                          SmallTabComponent(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WalletScreen(),
                                ),
                              );
                            },
                            label: "Add Trip",
                            icon: EvaIcons.plus,
                          ),

                          SmallTabComponent(
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
                          ),

                          // KYC
                          SmallTabComponent(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const KYCScreen(),
                                ),
                              );
                            },
                            label: "KYC",
                            icon: Icons.verified_outlined,
                          ),

                          SmallTabComponent(
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
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                // Vehicle Dashboard
                BlueBoxComponent(
                  label1: "Vehicle Dashboard",
                  label2: "Total Vehicle: 10",
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Row(children: [
                        SmallTabComponent(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MapScreen(),
                              ),
                            );
                          },
                          label: "Add Driver",
                          icon: Icons.person_add_alt_1_rounded,
                        ),
                        SmallTabComponent(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AllVehicleScreen(),
                              ),
                            );
                          },
                          label: "Add Vehicle",
                          icon: EvaIcons.carOutline,
                        ),
                        SmallTabComponent(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MapScreen(),
                              ),
                            );
                          },
                          label: "Map",
                          icon: EvaIcons.navigation2Outline,
                        ),
                        SmallTabComponent(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoadHistoryScreen(),
                              ),
                            );
                          },
                          label: "Load History",
                          icon: Icons.verified_outlined,
                        ),
                        /*SmallTabComponent(
                            onTap: () => Get.to(const DocumentScreen()),
                            label: "Vehicle\nDoc",
                            icon: EvaIcons.fileTextOutline,
                          ),
                          SmallTabComponent(
                            onTap: () => Get.to(const RoadTaxScreen()),
                            label: "Tax",
                            icon: EvaIcons.creditCardOutline,
                          ),*/
                      ]),
                    ],
                  ),
                ),

                SingleTileTabComponent(
                  onTap: () {},
                  icon: isSwitchedA == true
                      ? Remix.sun_line
                      : EvaIcons.moonOutline,
                  iconColor: bohibaColors.primaryColor,
                  title: 'Dark Mode',
                  trailing: Switch(
                    value: isSwitchedA,
                    onChanged: (value) {
                      setState(() {
                        isSwitchedA = value;
                        debugPrint(isSwitchedA.toString());
                      });
                    },
                    activeTrackColor: const Color(0xFF047BFC),
                    activeColor: Colors.white,
                  ),
                ),
                SingleTileTabComponent(
                  onTap: () {},
                  icon: Icons.fingerprint_outlined,
                  iconColor: bohibaColors.primaryColor,
                  title: 'Security',
                ),
                SingleTileTabComponent(
                  onTap: () {},
                  icon: EvaIcons.shareOutline,
                  iconColor: bohibaColors.primaryColor,
                  title: 'Share and Earn',
                ),
                SingleTileTabComponent(
                  onTap: () {},
                  icon: EvaIcons.questionMarkCircleOutline,
                  iconColor: bohibaColors.primaryColor,
                  title: 'Help & Support',
                ),
                SingleTileTabComponent(
                  onTap: () {},
                  icon: EvaIcons.awardOutline,
                  iconColor: bohibaColors.primaryColor,
                  title: 'About Us',
                ),
                SingleTileTabComponent(
                  onTap: () {},
                  icon: EvaIcons.logOutOutline,
                  iconColor: bohibaColors.warningColor,
                  title: 'Logout',
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ));
  }
}
