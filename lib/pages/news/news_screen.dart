import '/component/bohiba_appbar/title_appbar.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '/component/ui/tile_decorative.dart';
import '/controllers/news_controller.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/component/screen_utils.dart';
import 'package:flutter/material.dart';

class NewsScreen extends GetView<NewsController> {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(
        title: 'News',
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: ScreenUtils.height20,
          right: ScreenUtils.width15,
          left: ScreenUtils.width15,
        ),
        child: Obx(() {
          return SmartRefresher(
            controller: controller.newsRefresher,
            onRefresh: () async {
              await controller.onRefreshNewsPage();
            },
            child: Column(
              children: [
                Container(
                  width: ScreenUtils.width,
                  height: 160.h,
                  padding: EdgeInsets.all(ScreenUtils.height10.h),
                  decoration: TileDecorative(),
                  alignment: Alignment.bottomLeft,
                ),
                Gap(5.h),
                Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: Text(
                    controller.newsDetail.value.updatedAt ?? '',
                    style: bohibaTheme.textTheme.titleSmall,
                  ),
                ),
                Gap(10.h),
                Text(
                  controller.newsDetail.value.title ?? '',
                  style: bohibaTheme.textTheme.headlineMedium,
                ),
                Text(
                  controller.newsDetail.value.description ?? '',
                  style: bohibaTheme.textTheme.titleMedium,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
