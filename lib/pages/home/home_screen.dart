import 'home_data_stepper.dart';
import 'home_fav_section.dart';
import 'home_trip_section.dart';
import 'home_news_section.dart';
import 'home_mines_section.dart';
import 'home_driver_section.dart';
import 'home_account_section.dart';
import 'home_top_truck_section.dart';
import 'home_image_slider_section.dart';
import '/controllers/home_controller.dart';
import '/component/bohiba_appbar/home_appbar.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: HomeAppBar(),
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        // shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        slivers: [
          HomeAppBar(),
          SliverList(
            delegate: SliverChildListDelegate([
              HomeAccountSection(),
              HomeFavListSection(),
              HomeDataStepper(),
              HomeTripSection(),
              HomeImageSliderSection(),
              HomeTopTruck(),
              HomeDriverSection(),
              HomeMinesSection(),
              HomeNewsSection()
            ]),
          )
        ],
      ),
    );
  }
}
