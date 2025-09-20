import '/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '/pages/home/home_trip_section.dart';
import 'package:flutter/material.dart';
import 'home_top_truck_section.dart';
import '/component/bohiba_appbar/home_appbar.dart';
import 'home_image_slider_section.dart';
import 'home_news_section.dart';
import 'home_fav_section.dart';
import 'home_account_section.dart';
import 'home_mines_section.dart';
import '/dist/component_exports.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: SmartRefresher(
        controller: controller.refreshController,
        onRefresh: () async {
          await controller.onRefreshPage();
        },
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.only(top: ScreenUtils.height20),
            child: Column(
              children: [
                const HomeImageSliderSection(),
                const HomeAccountSection(),
                HomeFavListSection(),
                const HomeTripSection(),
                // const HomePopularSection(),
                const HomeTopTruck(),
                const HomeMinesSection(),
                const HomeNewsSection()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
