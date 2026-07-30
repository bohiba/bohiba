import 'package:auto_size_text/auto_size_text.dart';
import '/component/image_path.dart';
import '/component/bohiba_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/routes/app_route.dart';
import '/controllers/all_company_controller.dart';
import '/model/company_model.dart';
import 'package:get/get.dart';
import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:marquee_text/marquee_text.dart';

class CompanyHorizontalCard extends GetView<AllCompanyController> {
  final CompanyModel minesInfo;
  const CompanyHorizontalCard({super.key, required this.minesInfo});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ScreenUtils.height5,
        horizontal: ScreenUtils.width15,
      ),
      margin: EdgeInsets.only(bottom: 5.h),
      width: ScreenUtils.width,
      height: ScreenUtils.height * 0.075,
      decoration: TileDecorative(),
      child: InkWell(
        onTap: () {
          navigator.pushNamed(AppRoute.company, arguments: minesInfo);
        },
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  BohibaNetworkImage.circle(
                    imageUrl: '${ImagePath.companyLogo}/${minesInfo.logo}',
                    size: 40,
                    fallbackText: minesInfo.nameCode ?? minesInfo.name,
                    applyShortCode: false,
                  ),
                  Gap(ScreenUtils.width20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BohibaMarqueeText(
                        width: ScreenUtils.width * 0.5,
                        text: minesInfo.name ?? 'NA',
                        overflowText: minesInfo.nameCode ?? 'NA',
                        style: bohibaTheme.textTheme.bodyMedium,
                        marqueeTextStyle: bohibaTheme.textTheme.bodyMedium,
                      ),
                      BohibaMarqueeText(
                        width: ScreenUtils.width * 0.5,
                        text:
                            '${minesInfo.district ?? ''}, ${minesInfo.state ?? ''}',
                        overflowText:
                            '${minesInfo.district ?? ''}, ${minesInfo.state ?? ''}',
                        style: TextStyle(
                          fontSize: bohibaTheme.textTheme.titleSmall!.fontSize,
                          fontWeight:
                              bohibaTheme.textTheme.bodySmall!.fontWeight,
                          color: bohibaTheme.textTheme.titleMedium!.color,
                        ),
                        marqueeTextStyle: TextStyle(
                          fontSize: bohibaTheme.textTheme.titleSmall!.fontSize,
                          fontWeight:
                              bohibaTheme.textTheme.bodySmall!.fontWeight,
                          color: bohibaTheme.textTheme.titleMedium!.color,
                        ),
                        preserFontSize: [
                          bohibaTheme.textTheme.titleSmall!.fontSize!
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompanyVerticalCard extends StatelessWidget {
  final CompanyModel minesInfo;
  const CompanyVerticalCard({super.key, required this.minesInfo});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return GestureDetector(
      onTap: () {
        navigator.pushNamed(AppRoute.company, arguments: minesInfo);
      },
      child: Container(
        width: ScreenUtils.width * 0.30,
        margin: EdgeInsets.only(right: ScreenUtils.width10),
        decoration: TileDecorative(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 3,
              child: BohibaNetworkImage(
                imageUrl: "${ImagePath.companyLogo}/${minesInfo.logo}",
                height: ScreenUtils.width,
                width: ScreenUtils.width,
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtils.width5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      minesInfo.name ?? "",
                      style: bohibaTheme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflowReplacement: MarqueeText(
                        text: TextSpan(
                          style: bohibaTheme.textTheme.titleMedium,
                          text: minesInfo.nameCode ?? "",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
