import '/pages/mines/mines_card.dart';

import '/controllers/home_controller.dart';
import 'package:get/get.dart';

import '/routes/app_route.dart';
import '/component/screen_utils.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

class HomeMinesSection extends GetView<HomeController> {
  const HomeMinesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            right: ScreenUtils.width15,
            left: ScreenUtils.width15,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mines',
                style: bohibaTheme.textTheme.headlineLarge,
              ),
              Visibility(
                visible: controller.arrMines.isNotEmpty,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoute.navBar,
                      arguments: {
                        "current_index": 1,
                        "market_screen_index": 0,
                      },
                      (route) => true),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: ScreenUtils.height5),
                    child: Text(
                      'See All',
                      style: TextStyle(
                        fontSize:
                            bohibaTheme.textTheme.headlineMedium!.fontSize,
                        color: bohibaTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),

        // Home Market Section
        Container(
          height: ScreenUtils.height * 0.195,
          margin: EdgeInsets.only(
              bottom: ScreenUtils.height25, left: ScreenUtils.width15),
          constraints: BoxConstraints(minHeight: 0.05 * ScreenUtils.width50),
          child: Obx(
            () {
              return controller.arrMines.isEmpty
                  ? const Center(
                      child: Text('No Mines Available'),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.arrMines.length >= 10
                          ? 10
                          : controller.arrMines.length,
                      itemBuilder: (context, index) {
                        return MinesVerticalCard(
                          minesInfo: controller.arrMines[index],
                        );
                      },
                    );
            },
          ),
        ),
      ],
    );
  }
}
