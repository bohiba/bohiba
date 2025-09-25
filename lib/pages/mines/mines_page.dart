import '/controllers/mines_controller.dart';
import '/model/mines_model.dart';
import '/pages/widget/linear_box_widget.dart';
import '/theme/bohiba_theme.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/component/screen_utils.dart';
import '/services/global_service.dart';
import 'package:flutter/material.dart';
import '/component/bohiba_appbar/company_appbar.dart';

class MinesPage extends GetView<MinesController> {
  const MinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.minesModel.value = Get.arguments as MinesModel;
    return Scaffold(
      appBar:
          CompanyAppBar(title: controller.minesModel.value.mineName ?? 'NA'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: ScreenUtils.height20,
              right: ScreenUtils.width15,
              left: ScreenUtils.width15,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: ScreenUtils.width15),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: ScreenUtils.width25,
                        backgroundColor: bohibaTheme.dividerColor,
                        backgroundImage: NetworkImage(
                          GlobalService.getAvatarUrl(
                              controller.minesModel.value.mineName ?? 'UN'),
                        ),
                      ),
                      Gap(ScreenUtils.width10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.minesModel.value.materialType ?? '',
                              style: bohibaTheme.textTheme.titleLarge,
                            ),
                            Text(
                              controller.minesModel.value.location ?? 'NA',
                              style: TextStyle(
                                fontSize:
                                    bohibaTheme.textTheme.bodySmall!.fontSize,
                                color: bohibaTheme.textTheme.titleMedium!.color,
                                fontWeight:
                                    bohibaTheme.textTheme.bodySmall!.fontWeight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: ScreenUtils.height10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Company Info",
                        style: bohibaTheme.textTheme.headlineMedium,
                      ),
                      LinearBoxWidget(
                        header: 'Started',
                        title: 'NA',
                      ),
                      LinearBoxWidget(
                        header: 'Lease Expiry',
                        title: 'NA',
                      ),
                      LinearBoxWidget(
                        header: 'Mine Code',
                        title: 'NA',
                      ),
                      LinearBoxWidget(
                        header: 'Lease Code',
                        title: 'NA',
                      ),
                      LinearBoxWidget(
                        header: 'Ownership Type',
                        title: controller.minesModel.value.ownershipType
                            ?.toUpperCase(),
                      ),
                      LinearBoxWidget(
                        header: 'Parent Company',
                        title: "NA",
                      ),
                      LinearBoxWidget(
                        header: 'Material Type',
                        title: controller.minesModel.value.materialType
                            ?.toUpperCase(),
                      ),
                      LinearBoxWidget(
                        header: 'Mine Area',
                        title: 'NA',
                      ),
                      LinearBoxWidget(
                        header: 'Material Grade',
                        title: controller.minesModel.value.materialGrade,
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: ScreenUtils.height10),
                        child: Text(
                          "Basic Info",
                          style: bohibaTheme.textTheme.headlineMedium,
                        ),
                      ),
                      LinearBoxWidget(
                        header: 'Penalty Risk',
                        title: controller.minesModel.value.penaltyRisk
                            ?.toUpperCase(),
                      ),
                      LinearBoxWidget(
                        header: 'Waiting Period',
                        title: controller.minesModel.value.waitingPeriod
                            .toString(),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: ScreenUtils.height10),
                        child: Text(
                          "Road Condition",
                          style: bohibaTheme.textTheme.headlineMedium,
                        ),
                      ),

                      Text(
                        controller.minesModel.value.roadConditions
                                ?.toUpperCase() ??
                            'NA',
                        style: TextStyle(
                          fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                          fontWeight:
                              bohibaTheme.textTheme.bodySmall!.fontWeight,
                          color: bohibaTheme.textTheme.titleMedium!.color,
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: ScreenUtils.height10),
                        child: Text(
                          "Mandate Safety Gear",
                          style: bohibaTheme.textTheme.headlineMedium,
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(minHeight: 10),
                        child: Column(
                          children: List.generate(
                            3,
                            (index) {
                              return Padding(
                                padding:
                                    EdgeInsets.only(bottom: ScreenUtils.width5),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "NA",
                                    style: TextStyle(
                                      fontSize: bohibaTheme
                                          .textTheme.bodyMedium!.fontSize,
                                      fontWeight: bohibaTheme
                                          .textTheme.bodySmall!.fontWeight,
                                      color: bohibaTheme
                                          .textTheme.titleMedium!.color,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // LinearBox(
                      //   header: 'Road Condition',
                      //   title: "${mineInfo['road_conditions']}",
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
