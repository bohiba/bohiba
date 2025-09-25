import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/routes/app_route.dart';
import '../../services/global_service.dart';
import '/controllers/mines_controller.dart';
import '/extensions/bohiba_extension.dart';
import '/model/mines_model.dart';
import 'package:get/get.dart';
import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:marquee_text/marquee_text.dart';

class MinesHorizontalCard extends GetView<MinesController> {
  final MinesModel minesInfo;
  const MinesHorizontalCard({super.key, required this.minesInfo});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return InkWell(
      onTap: () {
        navigator.pushNamed(AppRoute.mines, arguments: minesInfo);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ScreenUtils.height5,
          horizontal: ScreenUtils.width15,
        ),
        margin: EdgeInsets.only(bottom: 5.h),
        width: ScreenUtils.width,
        height: ScreenUtils.height * 0.075,
        decoration: TileDecorative(),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: bohibaTheme.dividerColor,
                    backgroundImage: NetworkImage(
                        GlobalService.getAvatarUrl(minesInfo.mineName ?? 'NA')),
                  ),
                  Gap(ScreenUtils.width20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BohibaMarqueeText(
                        width: ScreenUtils.width * 0.5,
                        text: minesInfo.mineName ?? 'NA',
                        overflowText: minesInfo.mineName ?? 'NA',
                        style: bohibaTheme.textTheme.bodyMedium,
                        marqueeTextStyle: bohibaTheme.textTheme.bodyMedium,
                      ),
                      BohibaMarqueeText(
                        width: ScreenUtils.width * 0.3,
                        text: minesInfo.location ?? 'NA',
                        overflowText: minesInfo.location ?? 'NA',
                        style: TextStyle(
                          fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                          fontWeight:
                              bohibaTheme.textTheme.bodySmall!.fontWeight,
                          color: bohibaTheme.textTheme.titleMedium!.color,
                        ),
                        marqueeTextStyle: TextStyle(
                          fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                          fontWeight:
                              bohibaTheme.textTheme.bodySmall!.fontWeight,
                          color: bohibaTheme.textTheme.titleMedium!.color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTapDown: (TapDownDetails tapDownDetails) => {
                /*showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    tapDownDetails.globalPosition.dx,
                    tapDownDetails.globalPosition.dy,
                    0,
                    0,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  items: [
                    PopupMenuItem(
                      value: 'add_driver',
                      child: Text(
                        'Book',
                        style: bohibaTheme.textTheme.labelMedium,
                      ),
                    ),
                    PopupMenuItem(
                      value: 'add_load',
                      child: Text(
                        'Remove',
                        style: TextStyle(
                          fontSize:
                              bohibaTheme.textTheme.labelMedium!.fontSize,
                          fontWeight:
                              bohibaTheme.textTheme.labelMedium!.fontWeight,
                          color: BohibaColors.warningColor,
                        ),
                      ),
                    ),
                  ],
                ),*/
              },
              child: const Icon(EvaIcons.moreVertical),
            )
          ],
        ),
      ),
    );
  }
}

class MinesVerticalCard extends StatelessWidget {
  final MinesModel minesInfo;
  const MinesVerticalCard({super.key, required this.minesInfo});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return GestureDetector(
      onTap: () {
        navigator.pushNamed(AppRoute.mines, arguments: minesInfo);
      },
      child: Container(
        width: ScreenUtils.width * 0.30,
        height: ScreenUtils.height20,
        margin: EdgeInsets.only(
          right: ScreenUtils.width10,
        ),
        decoration: TileDecorative(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: bohibaTheme.dividerColor,
                backgroundImage: NetworkImage(minesInfo.logo ??
                    GlobalService.getAvatarUrl(minesInfo.mineName!)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtils.width10,
                  right: ScreenUtils.width10,
                  top: ScreenUtils.height10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AutoSizeText(
                    minesInfo.mineName ?? "NA",
                    style: bohibaTheme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflowReplacement: MarqueeText(
                      alwaysScroll: true,
                      speed: 5,
                      textDirection: TextDirection.rtl,
                      text: TextSpan(
                        style: bohibaTheme.textTheme.titleMedium,
                        text: minesInfo.mineName ?? "NA",
                      ),
                    ),
                  ),
                  Text(
                    minesInfo.location ?? "NA",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                      color: bohibaTheme.textTheme.titleMedium!.color,
                    ),
                  ),
                  Text(
                    minesInfo.waitingPeriod!.toHHMM(),
                    style: TextStyle(
                      fontSize: bohibaTheme.textTheme.bodySmall!.fontSize,
                      color: Colors.green,
                      fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
