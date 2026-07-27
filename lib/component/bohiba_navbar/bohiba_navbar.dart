import '/dist/enums/app_enums.dart';
import '/theme/bohiba_theme.dart';
import '/dist/component_exports.dart';
import '/services/pref_utils.dart';
import '/services/global_service.dart';
import '/services/user_role_type.dart';
import '/pages/home/home_screen.dart';
import '/pages/company/all_company_page.dart';
import '/pages/favourite/all_favourite_page.dart';
import '/pages/dashboard/dash_page/dashboard_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remixicon/remixicon.dart';

class BohibaNavBar extends StatefulWidget {
  const BohibaNavBar({super.key});

  @override
  State<BohibaNavBar> createState() => _BohibaNavBarState();
}

class _BohibaNavBarState extends State<BohibaNavBar> {
  int currentIndex = 0;
  int marketScreenIndex = 0;
  int userRole = UserRoles.guest;

  final PrefUtils _prefUtils = PrefUtils();

  List<BottomNavigationBarItem> navItem = [];

  List<Widget> navWidgets = [];

  @override
  void initState() {
    userRole = _prefUtils.getInt(PrefUtils.roleKey);
    super.initState();

    _getNavItem(userRole);
  }

  @override
  void didChangeDependencies() {
    var route = ModalRoute.settingsOf(context)!.arguments;
    if (route == null) {
      currentIndex = 0;
      marketScreenIndex = 0;
    } else {
      Map<String, dynamic> arguments = route as Map<String, dynamic>;
      currentIndex = arguments[HelperNavBar.currentIndex] ?? 0;
      marketScreenIndex = arguments[HelperNavBar.marketScreenIndex] ?? 0;
    }
    ScreenUtils.getDimensions(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        GlobalService.showAlertDialog(
          status: AlertStatus.info,
          title: 'EXIT',
          description:
              'This will close the application. Do you want to continue?',
          saveBtnTxt: 'No',
          onSave: () => navigator.pop(),
          discardBtnTxt: 'Yes',
          onDiscard: () {
            navigator.pop(true);
            SystemNavigator.pop();
          },
        );
      },
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: navWidgets,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: navItem,
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: bohibaTheme.textTheme.titleSmall,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: bohibaTheme.primaryColor,
          unselectedItemColor: BohibaColors.secoundaryColor,
          onTap: _onTap,
        ),
      ),
    );
  }

  void _getNavItem(int roleId) {
    switch (roleId) {
      case UserRoles.truckOwner:
        navItem = [
          const BottomNavigationBarItem(
            icon: Icon(Remix.home_line),
            activeIcon: Icon(Remix.home_fill),
            label: "Home",
            tooltip: "Home",
          ),
          const BottomNavigationBarItem(
            icon: Icon(RemixIcons.heart_3_line),
            activeIcon: Icon(RemixIcons.heart_3_fill),
            label: "Favourites",
            tooltip: "Favourites",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Remix.compass_discover_line),
            activeIcon: Icon(Remix.compass_discover_fill),
            label: "Companies",
            tooltip: "Companies",
          ),
          BottomNavigationBarItem(
            icon: Icon(Remix.dashboard_line),
            activeIcon: Icon(Remix.dashboard_horizontal_fill),
            label: "Dashboard",
            tooltip: "Dashboard",
          )
        ];

        navWidgets = [
          const HomePage(),
          AllFavouritePage(),
          AllCompanyPage(),
          const DashboardPage(),
        ];
      case UserRoles.driver:
        navItem = [
          const BottomNavigationBarItem(
            icon: Icon(Remix.home_line),
            activeIcon: Icon(Remix.home_fill),
            label: "Home",
            tooltip: "Home",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Remix.compass_discover_line),
            activeIcon: Icon(Remix.compass_discover_fill),
            label: "Trips",
            tooltip: "Trips",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Remix.briefcase_line),
            activeIcon: Icon(Remix.briefcase_fill),
            label: "Jobs",
            tooltip: "Jobs",
          ),
          BottomNavigationBarItem(
            icon: Icon(Remix.dashboard_line),
            activeIcon: Icon(Remix.dashboard_horizontal_fill),
            label: "Dashboard",
            tooltip: "Dashboard",
          )
        ];

        navWidgets = [
          const HomePage(),
          // AllTripPage(showLeading: false),
          // AllDriverJobPage(),
          AllFavouritePage(),
          AllCompanyPage(),
          const DashboardPage(),
        ];
      default:
    }
  }

  void _onTap(int index) {
    currentIndex = index;
    setState(() {});
  }
}
