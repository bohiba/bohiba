import '/component/bohiba_colors.dart';
import '/pages/mines/all_mines_page.dart';
import '/pages/dashboard/dash_page/dashboard_page.dart';
import '/pages/home/home_screen.dart';
import '/pages/status/status_screen/status_screen.dart';
import 'package:remixicon/remixicon.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class NavigationBar2 extends StatefulWidget {
  final int initialIndex;

  const NavigationBar2({super.key, this.initialIndex = 0});

  @override
  State<NavigationBar2> createState() => _NavigationBar2State();
}

class _NavigationBar2State extends State<NavigationBar2> {
  PersistentTabController navController =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      const HomePage(),
      const StatusPage(moveToTab: 0),
      const AllMinesPage(),
      const DashboardPage(),
    ];

    List<PersistentBottomNavBarItem> items = [
      PersistentBottomNavBarItem(
        icon: const Icon(Remix.home_fill),
        inactiveIcon: const Icon(Remix.home_line),
        iconSize: 22,
        textStyle: Theme.of(context).textTheme.labelSmall,
        activeColorPrimary: BohibaColors.primaryColor,
        inactiveColorPrimary: Colors.grey.withValues(alpha: 0.5),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Remix.pulse_fill),
        inactiveIcon: const Icon(EvaIcons.activityOutline),
        iconSize: 22,
        textStyle: Theme.of(context).textTheme.labelSmall,
        activeColorPrimary: BohibaColors.primaryColor,
        inactiveColorPrimary: Colors.grey.withValues(alpha: 0.5),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(EvaIcons.barChart),
        inactiveIcon: const Icon(EvaIcons.barChart2Outline),
        iconSize: 22,
        textStyle: Theme.of(context).textTheme.labelSmall,
        activeColorPrimary: BohibaColors.primaryColor,
        inactiveColorPrimary: Colors.grey.withValues(alpha: 0.5),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Remix.function_fill),
        inactiveIcon: const Icon(Remix.dashboard_fill),
        iconSize: 22,
        textStyle: Theme.of(context).textTheme.labelSmall,
        activeColorPrimary: BohibaColors.primaryColor,
        inactiveColorPrimary: Colors.grey.withValues(alpha: 0.5),
      )
    ];

    return PersistentTabView(
      context,
      controller: navController,
      screens: screens,
      navBarHeight: 55,
      items: items,
      stateManagement: false,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      navBarStyle: NavBarStyle.style2,
      confineToSafeArea: true,
      onWillPop: (context) {
        return Future.value(false);
      },
    );
  }
}
