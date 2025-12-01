import 'package:cached_network_image/cached_network_image.dart';

import '/component/image_path.dart';
import '/dist/app_enums.dart';

import '/model/news_model.dart';
import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';
import '/component/screen_utils.dart';
import '/component/bohiba_appbar/title_appbar.dart';
import '/controllers/all_news_controller.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllNewsScreen extends GetView<AllNewsController> {
  const AllNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigateState = Navigator.of(context);
    return Scaffold(
      appBar: TitleAppbar(
        title: "News",
      ),
      body: Obx(() {
        return SmartRefresher(
          controller: controller.refreshNewsController,
          onRefresh: () async {
            await controller.getAllNews(
              methodType: MethodType.api,
              showLoading: false,
            );
            controller.refreshNewsController.refreshCompleted();
          },
          child: controller.arrNews.isEmpty
              ? Padding(
                  padding: EdgeInsets.only(
                    right: ScreenUtils.width15,
                    left: ScreenUtils.width15,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No News',
                        style: bohibaTheme.textTheme.displayMedium,
                      ),
                      Text(
                        'We are sorry currently we don\'t have any news for you, We will notify you once we have anything for you.',
                        textAlign: TextAlign.center,
                        style: bohibaTheme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.only(
                    top: ScreenUtils.height20,
                    right: ScreenUtils.width15,
                    left: ScreenUtils.width15,
                  ),
                  itemCount: controller.arrNews.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    NewsModel news = controller.arrNews[index];
                    return GestureDetector(
                      onTap: () {
                        navigateState.pushNamed(AppRoute.newsScreen, arguments: news);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(bottom: ScreenUtils.height20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: ScreenUtils.width,
                              height: 160.h,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.r),
                                      child: CachedNetworkImage(
                                        imageUrl: '${ImagePath.newsImage}/${news.image}',
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(
                                          color: bohibaTheme.cardColor,
                                        ),
                                        errorWidget: (context, url, error) => Container(
                                          color: bohibaTheme.cardColor,
                                          child: Icon(Icons.broken_image, size: 50, color: bohibaTheme.dividerColor),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Content overlay
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      height: 40.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(12.r),
                                          bottomRight: Radius.circular(12.r),
                                        ),
                                        color: bohibaTheme.colorScheme.onTertiary.withValues(alpha: 0.5),
                                      ),
                                      padding: EdgeInsets.only(
                                        top: ScreenUtils.height5,
                                        left: ScreenUtils.height10,
                                        right: ScreenUtils.height10,
                                        bottom: ScreenUtils.height5,
                                      ),
                                      child: Text(
                                        news.title ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: bohibaTheme.textTheme.displayLarge!.color, fontSize: bohibaTheme.textTheme.titleMedium!.fontSize),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.r, right: 10.r),
                              child: Text(
                                news.description ?? 'NA',
                                maxLines: 3,
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: bohibaTheme.textTheme.bodyMedium!.fontSize,
                                  color: bohibaTheme.textTheme.titleLarge!.color,
                                  fontWeight: bohibaTheme.textTheme.bodySmall!.fontWeight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      }),
    );
  }
}
