import 'package:bohiba/component/bohiba_network_image.dart';
import 'package:bohiba/component/image_path.dart';
import 'package:bohiba/model/company_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '/dist/component_exports.dart';
import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';

class CompanyTile extends StatelessWidget {
  final CompanyModel minesInfo;
  const CompanyTile({
    super.key,
    required this.minesInfo,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(AppRoute.company, arguments: minesInfo),
      child: Container(
        padding: EdgeInsets.only(left: ScreenUtils.width15),
        width: ScreenUtils.width,
        height: ScreenUtils.height * 0.075,
        margin: EdgeInsets.only(bottom: ScreenUtils.width5),
        decoration: TileDecorative(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BohibaNetworkImage.circle(
              imageUrl: "${ImagePath.companyLogo}/${minesInfo.logo}",
              size: 32.h,
            ),
            Gap(ScreenUtils.height15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  minesInfo.name ?? '',
                  maxLines: 1,
                  style: bohibaTheme.textTheme.bodyMedium,
                ),
              ],
            ),

            const Spacer(),
            // InkWell(
            //   onTap: () {},
            //   child: GestureDetector(
            //     onPanDown: (details) => showMenu(
            //       context: context,
            //       position: RelativeRect.fromLTRB(
            //         details.globalPosition.dx,
            //         details.globalPosition.dy,
            //         details.globalPosition.dx,
            //         details.globalPosition.dy,
            //       ),
            //       shape: AppMenuShape(),
            //       items: [
            //         PopupMenuItem(
            //           child: Text(
            //             'Share',
            //             style: bohibaTheme.textTheme.titleMedium,
            //           ),
            //         ),
            //         PopupMenuItem(
            //           child: Text(
            //             'Feedback',
            //             style: bohibaTheme.textTheme.titleMedium,
            //           ),
            //         ),
            //         PopupMenuItem(
            //           child: Text(
            //             'Report',
            //             style: TextStyle(
            //               color: bohibaTheme.colorScheme.tertiary,
            //               fontStyle:
            //                   bohibaTheme.textTheme.titleMedium!.fontStyle,
            //               fontWeight:
            //                   bohibaTheme.textTheme.titleMedium!.fontWeight,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ).then(
            //       (value) {
            //         switch (value) {
            //           case 0:
            //             break;
            //           case 1:
            //             break;
            //           case 2:
            //           case 3:
            //           default:
            //         }
            //       },
            //     ),
            //     child: Container(
            //       height: ScreenUtils.height * 0.075,
            //       width: ScreenUtils.width50,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.only(
            //           topRight: Radius.circular(12.0),
            //           bottomRight: Radius.circular(12),
            //         ),
            //       ),
            //       child: Icon(Icons.more_vert_rounded),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
