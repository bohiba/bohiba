import 'package:flutter/material.dart';

import '../../dist/component_exports.dart';
import '../../theme/light_theme.dart';

class LoadTile extends StatelessWidget {
  final int index;
  const LoadTile({super.key, this.index = 0});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(bottom: BohibaResponsiveScreen.height10),
        padding: EdgeInsets.symmetric(
          horizontal: BohibaResponsiveScreen.width15,
          vertical: BohibaResponsiveScreen.height10,
        ),
        width: BohibaResponsiveScreen.width,
        height: BohibaResponsiveScreen.height * 0.075,
        decoration: TileDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BohibaMarqueeText(
                  width: BohibaResponsiveScreen.width * 0.25,
                  text: 'OD 14 AD 7872',
                  overflowText: 'OD 14 AD 7872',
                  style: TextStyle(
                    fontSize: 14.adaptSize,
                    fontWeight: FontWeight.w600,
                    color: bohibaColors.black,
                  ),
                  marqueeTextStyle: TextStyle(
                    fontSize: 14.adaptSize,
                    fontWeight: FontWeight.w600,
                    color: bohibaColors.black,
                  ),
                ),
                BohibaMarqueeText(
                  width: BohibaResponsiveScreen.width * 0.2,
                  text: '32-36 Tonne',
                  overflowText: '32-36 Tonne',
                  style: TextStyle(
                    fontSize: 12.adaptSize,
                    fontWeight: FontWeight.w500,
                    color: bohibaColors.greyColor,
                  ),
                  marqueeTextStyle: TextStyle(
                    fontSize: 12.adaptSize,
                    fontWeight: FontWeight.w500,
                    color: bohibaColors.secoundaryColor,
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
                    ? bohibaColors.successColor
                    : bohibaColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
