import '/pages/widget/role_widget.dart';
import '/component/image_path.dart';
import '/theme/bohiba_theme.dart';
import '/dist/component_exports.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeImageSliderSection extends StatefulWidget {
  const HomeImageSliderSection({super.key});

  @override
  State<HomeImageSliderSection> createState() => _HomeImageSliderSectionState();
}

class _HomeImageSliderSectionState extends State<HomeImageSliderSection> {
  List<String> imageOwnerData = [
    ImagePath.bannerOwnerFour,
    ImagePath.bannerOwnerFive,
    ImagePath.bannerOwnerOne,
    ImagePath.bannerOwnerTwo,
    ImagePath.bannerOwnerThree,
  ];

  List<String> imageDriverData = [
    ImagePath.bannerDriverOne,
    ImagePath.bannerDriverTwo,
    ImagePath.bannerDriverThree,
    ImagePath.bannerDriverFour
  ];
  int ownerActiveIndex = 0;
  int truckActiveIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          bottom: ScreenUtils.height30, top: ScreenUtils.height10),
      child: Column(
        children: [
          SizedBox(
            width: ScreenUtils.width,
            height: 50.h,
            child: RoleWidget(
              truckOwnerWidget: CarouselSlider(
                items: imageOwnerData.map((image) {
                  return Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: ScreenUtils.width15),
                    width: ScreenUtils.width,
                    decoration: BoxDecoration(
                      color: bohibaTheme.cardColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.r),
                      ),
                      image: DecorationImage(
                          image: AssetImage(image), fit: BoxFit.fill),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() => ownerActiveIndex = index);
                  },
                ),
              ),
              driverWidget: CarouselSlider(
                items: imageDriverData.map((image) {
                  return Container(
                    height: 45.h,
                    margin:
                        EdgeInsets.symmetric(horizontal: ScreenUtils.width15),
                    width: ScreenUtils.width,
                    decoration: BoxDecoration(
                      color: bohibaTheme.cardColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.r),
                      ),
                      image: DecorationImage(
                          image: AssetImage(image), fit: BoxFit.fill),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() => truckActiveIndex = index);
                  },
                ),
              ),
            ),
          ),
          Gap(5.w),
          RoleWidget(
            truckOwnerWidget: AnimatedSmoothIndicator(
              activeIndex: ownerActiveIndex,
              count: imageOwnerData.length,
              effect: ExpandingDotsEffect(
                dotHeight: 4.h,
                dotWidth: 4.w,
                activeDotColor: bohibaTheme.primaryColor,
                dotColor: bohibaTheme.colorScheme.secondary,
              ),
            ),
            driverWidget: AnimatedSmoothIndicator(
              activeIndex: truckActiveIndex,
              count: imageDriverData.length,
              effect: ExpandingDotsEffect(
                dotHeight: 4.h,
                dotWidth: 4.w,
                activeDotColor: bohibaTheme.primaryColor,
                dotColor: bohibaTheme.colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),

      /*FutureBuilder(
        future: Future.delayed(const Duration(seconds: 3)),
        builder: (BuildContext context, s) =>
            s.connectionState == ConnectionState.done
                ? 
                : SizedBox(
                    width: ScreenUtils.width,
                    height: 45.h,
                    child: CarouselSlider(
                      items: imageData.map((image) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: ScreenUtils.width * 0.01),
                          width: ScreenUtils.width,
                          decoration: BoxDecoration(
                            color: bohibaTheme.cardColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.r),
                            ),
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        viewportFraction: 1,
                      ),
                    ),
                  ),
      ),*/
    );
  }
}
