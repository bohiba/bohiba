import '/dist/app_enums.dart';
import '/pages/mines/all_mines_page.dart';
import '/services/global_service.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remixicon/remixicon.dart';
import '/pages/home/home_screen.dart';
import '../../pages/dashboard/dash_page/dashboard_page.dart';
import '/pages/explore/explore_page.dart';
import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';

class BohibaNavBar extends StatefulWidget {
  const BohibaNavBar({super.key});

  @override
  State<BohibaNavBar> createState() => _BohibaNavBarState();
}

class _BohibaNavBarState extends State<BohibaNavBar> {
  int currentIndex = 0;
  int marketScreenIndex = 0;

  get items => [
        const BottomNavigationBarItem(
          icon: Icon(Remix.home_line),
          activeIcon: Icon(Remix.home_fill),
          label: "Home",
          tooltip: "Home",
        ),
        /*const BottomNavigationBarItem(
          icon: Icon(Remix.heart_3_line),
          activeIcon: Icon(Remix.heart_3_fill),
          label: "Favourite",
          tooltip: "Favourite",
        ),*/
        const BottomNavigationBarItem(
          icon: Icon(EvaIcons.activityOutline),
          activeIcon: Icon(EvaIcons.activityOutline),
          label: "Market",
          tooltip: "Market",
        ),
        /*const BottomNavigationBarItem(
            icon: Icon(EvaIcons.barChart2Outline),
            activeIcon: Icon(EvaIcons.barChart),
            label: "Status",
            tooltip: "Status",
        ),*/
        const BottomNavigationBarItem(
          icon: Icon(EvaIcons.compassOutline),
          activeIcon: Icon(EvaIcons.compass),
          label: "Explore",
          tooltip: "Explore",
        ),
        BottomNavigationBarItem(
          icon: Icon(EvaIcons.gridOutline),
          activeIcon: Icon(EvaIcons.grid),
          label: "Dashboard",
          tooltip: "Dashboard",
        )
      ];

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
          children: [
            const HomePage(),
            // FavouritePage(),
            AllMinesPage(),
            // StatusPage(moveToTab: statusScreenIndex),
            ExplorePage(),
            const DashboardPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: items,
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: bohibaTheme.primaryColor,
          unselectedItemColor: BohibaColors.secoundaryColor,
          onTap: _onTap,
        ),
      ),
    );
  }

  void _onTap(int index) {
    currentIndex = index;
    setState(() {});
  }
}
