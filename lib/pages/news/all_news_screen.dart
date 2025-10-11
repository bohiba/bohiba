import '/model/news_model.dart';
import '/routes/app_route.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '/component/screen_utils.dart';
import '/component/ui/tile_decorative.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '/component/bohiba_appbar/title_appbar.dart';
import '/controllers/all_news_controller.dart';

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
            await controller.getAllNews();
            controller.refreshNewsController.refreshCompleted();
          },
          child: ListView.builder(
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
                      Container(
                        width: ScreenUtils.width,
                        height: 160.h,
                        padding: EdgeInsets.all(ScreenUtils.height10.h),
                        decoration: TileDecorative(),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          news.title ?? 'NA',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: bohibaTheme.textTheme.headlineMedium,
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
                            fontSize:
                                bohibaTheme.textTheme.bodyMedium!.fontSize,
                            color: bohibaTheme.textTheme.titleLarge!.color,
                            fontWeight:
                                bohibaTheme.textTheme.bodySmall!.fontWeight,
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
