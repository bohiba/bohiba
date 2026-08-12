import 'package:bohiba/model/company_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../company/company_card.dart';

import '/controllers/home_controller.dart';
import '/component/bohiba_navbar/bohiba_navbar.dart';
import 'package:get/get.dart';

import '/component/screen_utils.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';

class HomeCompanySection extends GetView<HomeController> {
  const HomeCompanySection({super.key});

  @override
  Widget build(BuildContext context) {
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
                    onTap: () => context
                        .findAncestorStateOfType<BohibaNavBarState>()
                        ?.switchTab(2),
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
              height: 120.h,
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
                            CompanyModel? companyModel =
                                controller.arrMines.value?[index];
                            if (companyModel == null) {
                              return SizedBox.shrink();
                            }
                            return CompanyVerticalCard(
                              minesInfo: companyModel,
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
