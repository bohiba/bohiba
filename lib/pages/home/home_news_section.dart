import 'package:cached_network_image/cached_network_image.dart';

import '/component/image_path.dart';
import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';
import '/controllers/home_controller.dart';
import '/dist/component_exports.dart';
import '/model/news_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeNewsSection extends GetView<HomeController> {
  const HomeNewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigatorState = Navigator.of(context);
    return Padding(
      padding: EdgeInsets.only(
        right: ScreenUtils.width15,
        left: ScreenUtils.width15,
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'News',
                style: bohibaTheme.textTheme.headlineLarge,
              ),
              GestureDetector(
                  onTap: () {
                    navigatorState.pushNamed(AppRoute.allNewsScreen);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: ScreenUtils.height5),
                    child: Text(
                      'See All',
                      style: TextStyle(fontSize: bohibaTheme.textTheme.headlineMedium!.fontSize, color: bohibaTheme.primaryColor),
                    ),
                  ))
            ],
          ),

          // Home News
          Obx(() {
            return Column(
              children: List.generate(controller.arrNews.length >= 3 ? 3 : controller.arrNews.length, (index) {
                NewsModel news = controller.arrNews[index];
                return GestureDetector(
                  onTap: () {
                    navigatorState.pushNamed(AppRoute.newsScreen, arguments: news);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: ScreenUtils.height20.h),
                    child: Container(
                      width: ScreenUtils.width,
                      height: 160.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          // Cached background
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
                  ),
                );
              }),
            );
          })
        ],
      ),
    );
  }
}
