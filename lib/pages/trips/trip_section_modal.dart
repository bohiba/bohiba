import '/component/bohiba_colors.dart';
import '/component/screen_utils.dart';
import '/component/ui/tile_decorative.dart';
import '/services/global_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:remixicon/remixicon.dart';

class TripDataBottomSheet extends StatelessWidget {
  final List<Map> dataList;
  final String title;
  final String subtitle;
  final Function(int) onDelete;
  final ThemeData theme;

  const TripDataBottomSheet({
    super.key,
    required this.dataList,
    required this.title,
    required this.subtitle,
    required this.onDelete,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: ScreenUtils.height * 0.65,
        decoration: BoxDecoration(
          color: BohibaColors.bgColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r),
            topRight: Radius.circular(12.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: ScreenUtils.width15,
                right: ScreenUtils.width15,
                top: ScreenUtils.height15,
                bottom: ScreenUtils.height15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.headlineLarge,
                  ),
                  Gap(ScreenUtils.height5),
                  Text(
                    subtitle,
                    style: theme.textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            ...List.generate(
              dataList.length,
              (index) {
                Map driverObj = dataList[index];
                return Container(
                  margin: EdgeInsets.only(
                    left: ScreenUtils.width15,
                    right: ScreenUtils.width15,
                    bottom: ScreenUtils.height5,
                  ),
                  padding: EdgeInsets.only(left: ScreenUtils.width15),
                  width: ScreenUtils.width,
                  height: ScreenUtils.height * 0.075,
                  decoration: TileDecorative(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          GlobalService.getAvatarUrl(driverObj['expense_type']),
                        ),
                      ),
                      Gap(ScreenUtils.height15),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driverObj['expense_date'] ?? '',
                            maxLines: 1,
                            style: theme.textTheme.bodyMedium,
                          ),
                          Text(
                            driverObj['expense_type'] ?? '',
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: theme.textTheme.labelMedium!.fontSize,
                              color: theme.textTheme.titleLarge!.color,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () => onDelete(index),
                        child: Container(
                          height: ScreenUtils.height * 0.075,
                          width: ScreenUtils.width50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12.0),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Icon(
                            Remix.delete_bin_6_fill,
                            color: BohibaColors.warningColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
