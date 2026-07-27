import '/pages/widget/in_app_webview.dart';
import '/routes/app_route.dart';
import '/component/bohiba_network_image.dart';
import 'package:gap/gap.dart';

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
                style: bohibaTheme.textTheme.headlineMedium,
              ),
              GestureDetector(
                  onTap: () {
                    navigatorState.pushNamed(AppRoute.allNewsScreen);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: ScreenUtils.height5),
                    child: Text(
                      'See All',
                      style: TextStyle(
                        fontSize: bohibaTheme.textTheme.headlineSmall!.fontSize,
                        color: bohibaTheme.primaryColor,
                      ),
                    ),
                  ))
            ],
          ),

          // Home News
          Obx(() {
            if (controller.arrNews.isEmpty) {
              return SizedBox.shrink();
            }
            return Column(
              children: List.generate(controller.arrNews.length >= 3 ? 3 : controller.arrNews.length, (index) {
                NewsModel news = controller.arrNews[index];
                return GestureDetector(
                  onTap: () {
                    // navigatorState.pushNamed(AppRoute.newsScreen, arguments: news);
                    String? website = news.redirectUrl;
                    if (website != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InAppWebViewPage(url: website),
                        ),
                      );
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: ScreenUtils.height20.h),
                    child: Container(
                      width: ScreenUtils.width,
                      // height: 160.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cached background
                          BohibaNetworkImage.rounded(
                            imageUrl: news.image,
                            width: ScreenUtils.width,
                            height: 220,
                            radius: 12,
                            fallbackText: news.title,
                          ),
                          Gap(5.h),

                          Text(
                            news.title ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: bohibaTheme.textTheme.titleMedium!.fontWeight,
                              fontSize: bohibaTheme.textTheme.titleSmall!.fontSize,
                            ),
                          ),
                          Text(
                            news.authorName ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontWeight: bohibaTheme.textTheme.labelMedium!.fontWeight,
                              fontSize: bohibaTheme.textTheme.labelSmall!.fontSize,
                              color: bohibaTheme.textTheme.titleLarge!.color,
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
