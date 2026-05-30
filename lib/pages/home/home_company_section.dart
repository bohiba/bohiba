import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../company/company_card.dart';

import '/controllers/home_controller.dart';
import 'package:get/get.dart';

import '/routes/app_route.dart';
import '/component/screen_utils.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

class HomeCompanySection extends GetView<HomeController> {
  const HomeCompanySection({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigatorState = Navigator.of(context);
    return Obx(() {
      return Visibility(
        visible: controller.arrMines.value?.isNotEmpty ?? false,
        child: Column(
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
                    'Company',
                    style: bohibaTheme.textTheme.headlineMedium,
                  ),
                  GestureDetector(
                    onTap: () {
                      navigatorState.pushNamed(AppRoute.allMines);
                    },
                    // onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    //     AppRoute.navBar,
                    //     arguments: {
                    //       "current_index": 1,
                    //       "market_screen_index": 0,
                    //     },
                    //     (route) => true),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: ScreenUtils.height5),
                      child: Text(
                        'See All',
                        style: TextStyle(
                          fontSize:
                              bohibaTheme.textTheme.headlineSmall!.fontSize,
                          color: bohibaTheme.primaryColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            // Home Market Section

            Container(
              height: 130.h,
              margin: EdgeInsets.only(
                  bottom: ScreenUtils.height25, left: ScreenUtils.width15),
              constraints:
                  BoxConstraints(minHeight: 0.05 * ScreenUtils.width50),
              child: Obx(
                () {
                  return controller.arrMines.value?.isEmpty ?? true
                      ? const Center(
                          child: Text('No Mines Available'),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount:
                              (controller.arrMines.value?.length ?? 0) >= 10
                                  ? 10
                                  : controller.arrMines.value?.length,
                          itemBuilder: (context, index) {
                            return CompanyVerticalCard(
                              minesInfo: controller.arrMines.value![index],
                            );
                          },
                        );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
