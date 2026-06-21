import 'package:remixicon/remixicon.dart';

import 'company_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '/dist/component_exports.dart';
import '/theme/bohiba_theme.dart';

class CompanyTile extends StatelessWidget {
  final Map minesInfo;
  const CompanyTile({
    super.key,
    this.minesInfo = const {},
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CompanyPage(),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.only(left: ScreenUtils.width15),
        width: ScreenUtils.width,
        height: ScreenUtils.height * 0.075,
        margin: EdgeInsets.only(bottom: ScreenUtils.width5),
        decoration: TileDecorative(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const StackCompanyAvatar(),
            CircleAvatar(
              radius: 25,
              backgroundColor: bohibaTheme.dividerColor,
              // backgroundImage: NetworkImage(
              //   GlobalService.getAvatarUrl(minesInfo['mine_name']),
              // ),
            ),
            Gap(ScreenUtils.height15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  minesInfo['mine_name'],
                  maxLines: 1,
                  style: bohibaTheme.textTheme.bodyMedium,
                ),
                Text(
                  minesInfo['location'],
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
                    color: bohibaTheme.textTheme.titleLarge!.color,
                  ),
                ),
              ],
            ),

            const Spacer(),
            InkWell(
              onTap: () {},
              child: GestureDetector(
                onPanDown: (details) => showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                  ),
                  shape: AppMenuShape(),
                  items: [
                    PopupMenuItem(
                      child: Text(
                        'Share',
                        style: bohibaTheme.textTheme.titleMedium,
                      ),
                    ),
                    PopupMenuItem(
                      child: Text(
                        'Feedback',
                        style: bohibaTheme.textTheme.titleMedium,
                      ),
                    ),
                    PopupMenuItem(
                      child: Text(
                        'Report',
                        style: TextStyle(
                          color: bohibaTheme.colorScheme.tertiary,
                          fontStyle:
                              bohibaTheme.textTheme.titleMedium!.fontStyle,
                          fontWeight:
                              bohibaTheme.textTheme.titleMedium!.fontWeight,
                        ),
                      ),
                    ),
                  ],
                ).then(
                  (value) {
                    switch (value) {
                      case 0:
                        break;
                      case 1:
                        break;
                      case 2:
                      case 3:
                      default:
                    }
                  },
                ),
                child: Container(
                  height: ScreenUtils.height * 0.075,
                  width: ScreenUtils.width50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12.0),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Icon(Remix.menu_3_fill),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
