import 'package:flutter/material.dart';

import '../../dist/component_exports.dart';
import '/theme/bohiba_theme.dart';

class LoadTile extends StatelessWidget {
  final int index;
  const LoadTile({super.key, this.index = 0});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(bottom: ScreenUtils.height10),
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtils.width15,
          vertical: ScreenUtils.height10,
        ),
        width: ScreenUtils.width,
        height: ScreenUtils.height * 0.075,
        decoration: TileDecorative(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BohibaMarqueeText(
                  width: ScreenUtils.width * 0.25,
                  text: 'OD 14 AD 7872',
                  overflowText: 'OD 14 AD 7872',
                  style: TextStyle(
                    fontSize: 14.adaptSize,
                    fontWeight: FontWeight.w600,
                    color: BohibaColors.black,
                  ),
                  marqueeTextStyle: TextStyle(
                    fontSize: 14.adaptSize,
                    fontWeight: FontWeight.w600,
                    color: BohibaColors.black,
                  ),
                ),
                BohibaMarqueeText(
                  width: ScreenUtils.width * 0.2,
                  text: '32-36 Tonne',
                  overflowText: '32-36 Tonne',
                  style: TextStyle(
                    fontSize: 12.adaptSize,
                    fontWeight: FontWeight.w500,
                    color: BohibaColors.greyColor,
                  ),
                  marqueeTextStyle: TextStyle(
                    fontSize: 12.adaptSize,
                    fontWeight: FontWeight.w500,
                    color: BohibaColors.secoundaryColor,
                  ),
                ),
              ],
            ),
            Text(
              "OMC - JSW",
              style: TextStyle(
                fontWeight: bohibaTheme
                    .listTileTheme.leadingAndTrailingTextStyle!.fontWeight,
                fontFamily: bohibaTheme
                    .listTileTheme.leadingAndTrailingTextStyle!.fontFamily,
                fontSize: bohibaTheme
                    .listTileTheme.leadingAndTrailingTextStyle!.fontSize,
                color: index % 2 == 0
                    ? BohibaColors.successColor
                    : BohibaColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
