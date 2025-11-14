import 'package:bohiba/component/image_path.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: CachedNetworkImage(
                      imageUrl:
                          '${ImagePath.newsImage}/${controller.newsDetail.value.image}',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade200,
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.broken_image, size: 50),
                      ),
                    ),
                  ),
                  Gap(5.h),
                  Align(
                    alignment: AlignmentGeometry.centerRight,
                    child: Text(
                      controller.newsDetail.value.updatedAt ?? '',
                      style: TextStyle(
                        fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
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
