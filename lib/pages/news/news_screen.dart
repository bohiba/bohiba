import '/component/bohiba_network_image.dart';

import '/component/bohiba_appbar/title_appbar.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
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
    return Obx(() {
      return Scaffold(
        appBar: TitleAppbar(
          title: 'News',
        ),
        body: SmartRefresher(
          controller: controller.newsRefresher,
          onRefresh: () async {
            await controller.onRefreshNewsPage();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: ScreenUtils.height20,
                right: ScreenUtils.width15,
                left: ScreenUtils.width15,
              ),
              child: Column(
                children: [
                  BohibaNetworkImage.rounded(
                    imageUrl: controller.newsDetail.value.image,
                    width: ScreenUtils.width,
                    height: 160.h,
                    radius: 12,
                    fallbackText: controller.newsDetail.value.title,
                  ),
                  Gap(5.h),
                  Align(
                    alignment: AlignmentGeometry.centerRight,
                    child: Text(
                      controller.newsDetail.value.updatedAt ?? '',
                      style: TextStyle(
                        fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                        color: bohibaTheme.textTheme.bodyLarge!.color,
                      ),
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
                  Gap(110.h)
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
