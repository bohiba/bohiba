import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '/component/bohiba_colors.dart';
import '/component/screen_utils.dart';
import '/component/ui/tile_decorative.dart';
import '/routes/app_route.dart';
import '/theme/bohiba_theme.dart';

class AllManagerPage extends StatelessWidget {
  const AllManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoute.driver);
      },
      child: Container(
        margin: EdgeInsets.only(
          left: ScreenUtils.width15,
          right: ScreenUtils.width15,
          bottom: ScreenUtils.height5,
        ),
        padding: EdgeInsets.only(
          left: ScreenUtils.width15,
        ),
        width: ScreenUtils.width,
        height: ScreenUtils.height * 0.075,
        decoration: TileDecorative(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              // backgroundImage: AssetImage(),
            ),
            Gap(ScreenUtils.height15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name",
                  maxLines: 1,
                  style: bohibaTheme.textTheme.bodyMedium,
                ),
                Text(
                  "Role",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: bohibaTheme.textTheme.labelMedium!.fontSize,
                    color: bohibaTheme.textTheme.titleLarge!.color,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Visibility(
              child: Row(
                children: [
                  Text(""),
                  Gap(ScreenUtils.width5),
                  Icon(
                    Icons.star_rate_rounded,
                    color: BohibaColors.errorColor,
                    size: 20,
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {},
              child: GestureDetector(
                onTapDown: (details) {},

                /* showMenu(
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
                        value: 0,
                        child: Text(
                          'View',
                          style: bohibaTheme.textTheme.titleMedium,
                        ),
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: Text(
                          'Edit',
                          style: bohibaTheme.textTheme.titleMedium,
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text(
                          'Share',
                          style: bohibaTheme.textTheme.titleMedium,
                        ),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            color: BohibaColors.warningColor,
                            fontStyle:
                                bohibaTheme.textTheme.titleMedium!.fontStyle,
                            fontWeight:
                                bohibaTheme.textTheme.titleMedium!.fontWeight,
                          ),
                        ),
                      ),
                    ]).then((value) {
                  if (!context.mounted) return;
                  switch (value) {
                    case 0:
                      showModalBottomSheet(
                        isScrollControlled: true,
                        isDismissible: false,
                        shape: BottomModalShape(),
                        context: context,
                        builder: (context) {
                          return DriverDetialsModalSheet(
                            index: widget.index,
                            name: widget.name,
                            mobileNumber: widget.mobileNumber,
                            dob: widget.dob,
                            licenseNumber: widget.licenseNumber,
                            vechileNumber: widget.vechileNumber,
                            rating: widget.rating,
                            cov: widget.cov,
                            validTill: widget.validUpto,
                            type: widget.type,
                            isFav: widget.isFav,
                          );
                        },
                      );
                      break;
                    case 1:
                      showModalBottomSheet(
                        isScrollControlled: true,
                        isDismissible: false,
                        shape: BottomModalShape(),
                        context: context,
                        builder: (context) {
                          return DriverEditModel(
                            index: widget.index,
                            name: widget.name,
                            isFav: widget.isFav,
                            rating: widget.rating,
                          );
                        },
                      );
                    case 2:
                      ShareDriverDetails(
                        id: widget.index,
                        name: widget.name,
                        dLNumber: widget.licenseNumber,
                        vehicle: widget.vechileNumber,
                        mobileNo: widget.mobileNumber,
                        dob: widget.dob,
                        validUpto: widget.validUpto,
                        type: widget.type,
                      ).share();
                      break;
                    case 3:
                      showModalBottomSheet(
                        isScrollControlled: true,
                        isDismissible: false,
                        shape: BottomModalShape(),
                        context: context,
                        builder: (context) {
                          return DeleteModal(
                            title: "Delete Driver",
                            subTitle:
                                "Driver will be unassigned from truck but records will stay.",
                            description:
                                "Are you sure you want to delete?\n${widget.name}",
                          );
                        },
                      );

                    default:
                  }
                }),*/
                child: Container(
                  height: ScreenUtils.height * 0.075,
                  width: ScreenUtils.width50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12.0),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Icon(EvaIcons.moreVertical),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
