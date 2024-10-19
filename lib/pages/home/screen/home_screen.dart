import 'package:bohiba/component/screen_utils.dart';
import 'package:bohiba/pages/home/home_component/home_account/home_account_section.dart';
import 'package:bohiba/pages/home/home_component/home_tipper/home_tipper_section.dart';
import 'package:flutter/material.dart';
import 'package:bohiba/component/bohiba_appbar/home_appbar.dart';
import 'package:bohiba/component/bohiba_colors.dart';
import 'package:bohiba/pages/home/home_component/home_craousel/home_image_slider_section.dart';
import 'package:bohiba/pages/home/home_component/home_market/home_market_section.dart';
import 'package:bohiba/pages/home/home_component/home_news/home_news_section.dart';
import 'package:bohiba/pages/home/home_component/home_popular/home_popular.dart';
import 'package:bohiba/pages/home/home_component/home_wishlist/home_wishlist_section.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _Homepagestate();
}

class _Homepagestate extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bohibaColors.bgColor,
      appBar: const HomeAppBar(),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            const HomeAccountSection(),
            Gap(BohibaResponsiveScreen.height20),
            const HomeImageSliderSection(),
            Gap(BohibaResponsiveScreen.height30),
            const HomeWishListSection(),
            Gap(BohibaResponsiveScreen.height30),
            const HomeBestTipper(),
            Gap(BohibaResponsiveScreen.height30),
            const HomePopularSection(),
            Gap(BohibaResponsiveScreen.height30),
            const HomeMarketSection(),
            Gap(BohibaResponsiveScreen.height20),
            const HomeNewsSection()
          ],
        ),
      ),
    );
  }
}
