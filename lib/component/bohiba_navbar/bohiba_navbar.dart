import '/dist/component_exports.dart';
import 'package:bohiba/theme/light_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import '/pages/home/screen/home_screen.dart';
import '/pages/dashboard/dash_screen/dashboard_screen.dart';
import '/pages/market/market_screen/market_screen.dart';

class BohibaNavBar extends StatefulWidget {
  const BohibaNavBar({
    super.key,
  });

  @override
  State<BohibaNavBar> createState() => _BohibaNavBarState();
}

class _BohibaNavBarState extends State<BohibaNavBar> {
  get items => [
        const BottomNavigationBarItem(
            icon: Icon(Remix.home_line),
            activeIcon: Icon(Remix.home_fill),
            label: "Home",
            tooltip: "Home"),
        const BottomNavigationBarItem(
            icon: Icon(EvaIcons.activityOutline),
            activeIcon: Icon(Remix.pulse_fill),
            label: "Market",
            tooltip: "Market"),
        /*const BottomNavigationBarItem(
            icon: Icon(EvaIcons.barChart2Outline),
            activeIcon: Icon(EvaIcons.barChart),
            label: "Status",
            tooltip: "Status"),*/
        BottomNavigationBarItem(
          icon: CircleAvatar(
            radius: 15,
            backgroundColor: bohibaColors.primaryColor,
          ),
          label: "Dashboard",
          tooltip: "Dashboard",
        )
      ];

  void _onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  int currentIndex = Get.arguments[HelperNavBar.currentIndex] ?? 0;
  int marketScreenIndex = Get.arguments[HelperNavBar.marketScreenIndex] ?? 0;
  int statusScreenIndex = Get.arguments[HelperNavBar.statusScreenIndex] ?? 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        body: [
          const HomeScreen(),
          MarketPage(moveToTab: marketScreenIndex),
          // StatusPage(moveToTab: statusScreenIndex),
          const DashboardScreen(),
        ].elementAt(currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: items,
          elevation: 10,
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: bohibaTheme.primaryColor,
          unselectedItemColor: bohibaColors.secoundaryColor,
          onTap: _onTap,
        ),
      ),
    );
  }
}
