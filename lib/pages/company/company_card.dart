import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/routes/app_route.dart';
import '/services/global_service.dart';
import '../../controllers/all_company_controller.dart';
import '../../model/company_model.dart';
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
          navigator.pushNamed(AppRoute.mines, arguments: minesInfo);
        },
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: bohibaTheme.colorScheme.surface,
                    // backgroundColor: bohibaTheme.dividerColor,
                    backgroundImage: NetworkImage(
                        GlobalService.getAvatarUrl(minesInfo.nameCode ?? 'NA')),
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
        navigator.pushNamed(AppRoute.mines, arguments: minesInfo);
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
              child: Container(
                width: double.maxFinite,
                height: 70.h,
                margin: EdgeInsets.all(3.0),
                alignment: Alignment.center,
                decoration: TileDecorative(
                  color: bohibaTheme.scaffoldBackgroundColor,
                ),
                child: Text(minesInfo.nameCode ?? ""),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    minesInfo.district ?? "",
                    style: bohibaTheme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflowReplacement: MarqueeText(
                      text: TextSpan(
                        style: bohibaTheme.textTheme.titleMedium,
                        text: minesInfo.district ?? "",
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
