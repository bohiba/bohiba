import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../dist/component_exports.dart';
import 'tabs/complete_status/complete_component/company_modal_bottom_sheet.dart';

class CompeleteTile extends StatelessWidget {
  final int index;
  const CompeleteTile({super.key, this.index = 0});

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
        height: ScreenUtils.height * 0.08,
        decoration: TileDecorative(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
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
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  useSafeArea: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    ),
                  ),
                  context: context,
                  builder: (context) {
                    return const CompanyModalBottomSheet();
                  },
                );
              },
              icon: const Icon(Remix.more_2_line),
            ),
          ],
        ),
      ),
    );
  }
}
