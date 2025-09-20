import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/dist/component_exports.dart';
import '/model/news_model.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '/pages/news/news_screen.dart';
import '/theme/bohiba_theme.dart';
import '/controllers/home_controller.dart';
import 'package:flutter/material.dart';

class HomeNewsSection extends GetView<HomeController> {
  const HomeNewsSection({super.key});

  @override
  Widget build(BuildContext context) {
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
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const NewsScreen();
                        },
                      ),
                    );
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: ScreenUtils.height5),
                    child: Text(
                      'See All',
                      style: TextStyle(
                          fontSize:
                              bohibaTheme.textTheme.headlineMedium!.fontSize,
                          color: Theme.of(context).primaryColor),
                    ),
                  ))
            ],
          ),
          Gap(ScreenUtils.height10),

          // Home News
          Obx(() {
            return Column(
              children: List.generate(
                  controller.arrNews.length >= 3
                      ? 3
                      : controller.arrNews.length, (index) {
                NewsModel news = controller.arrNews[index];
                return Padding(
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
                );
              }),
            );
          })
        ],
      ),
    );
  }
}
