import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remixicon/remixicon.dart';

import '../../dist/component_exports.dart';

class TopVehicleTile extends StatelessWidget {
  const TopVehicleTile({super.key});

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
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: BohibaResponsiveScreen.width * 0.095,
                    height: BohibaResponsiveScreen.width * 0.095,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: bohibaColors.primaryVariantColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Remix.truck_line),
                  ),
                  Gap(BohibaResponsiveScreen.width10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BohibaMarqueeText(
                        width: BohibaResponsiveScreen.width * 0.170,
                        text: 'OD 14X 7224',
                        overflowText: 'OD 14X 7224',
                        style: TextStyle(
                          fontSize: 14.adaptSize,
                          fontWeight: FontWeight.w500,
                          color: bohibaColors.greyColor,
                        ),
                        marqueeTextStyle: TextStyle(
                          fontSize: 14.adaptSize,
                          fontWeight: FontWeight.w500,
                          color: bohibaColors.greyColor,
                        ),
                      ),
                      const Gap(2),
                      BohibaMarqueeText(
                        width: BohibaResponsiveScreen.width * 0.170,
                        text: '20 trips',
                        overflowText: '20 trips',
                        style: TextStyle(
                          fontSize: 12.adaptSize,
                          fontWeight: FontWeight.w500,
                          color: bohibaColors.black,
                        ),
                        marqueeTextStyle: TextStyle(
                          fontSize: 12.adaptSize,
                          fontWeight: FontWeight.w500,
                          color: bohibaColors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTapDown: (tapDownDetails) {
                showMenu(
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
                  items: const [
                    PopupMenuItem(
                      value: 'add_driver',
                      child: Text('Add Load'),
                    ),
                    PopupMenuItem(
                      value: 'add_load',
                      child: Text('Edit Tipper'),
                    ),
                    PopupMenuItem(
                      value: 'add_driver',
                      child: Text('Edit Driver'),
                    ),
                  ],
                );
              },
              child: const Icon(EvaIcons.moreVertical),
            )
          ],
        ),
      ),
    );
  }
}
