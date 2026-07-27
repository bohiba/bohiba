import '../../dist/enums/app_enums.dart';
import '/model/news_model.dart';
import '/theme/bohiba_theme.dart';
import '/component/screen_utils.dart';
import '/pages/widget/in_app_webview.dart';
import '/component/bohiba_appbar/title_appbar.dart';
import '/controllers/all_news_controller.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/component/bohiba_network_image.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class AllNewsScreen extends GetView<AllNewsController> {
  const AllNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar(
        title: "News",
      ),
      body: SafeArea(
        child: Obx(() {
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
                    },
                  ),
          );
        }),
      ),
    );
  }
}
