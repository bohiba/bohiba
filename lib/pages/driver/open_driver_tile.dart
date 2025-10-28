import '/dist/app_enums.dart';
import '/model/driver_model.dart';
import '/theme/bohiba_theme.dart';
import '/component/screen_utils.dart';
import '/component/ui/tile_decorative.dart';
import '/component/bohiba_text/bohiba_marquee_text.dart';

import '/pages/widget/role_widget.dart';
import '/pages/driver/driver_modals/connection_request_modal.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OpenDriverTile extends StatefulWidget {
  final UserModel openDriver;
  final Function()? onTap;
  final bool? showStatus;
  final bool showDialog;
  final Function()? onReject;
  final Function()? onAccept;

  const OpenDriverTile({
    super.key,
    required this.openDriver,
    this.onTap,
    this.showStatus = false,
    this.showDialog = false,
    this.onReject,
    this.onAccept,
  });

  @override
  State<OpenDriverTile> createState() => _OpenDriverTileState();
}

class _OpenDriverTileState extends State<OpenDriverTile> {
  UserModel user = UserModel();

  @override
  void initState() {
    super.initState();
    user = widget.openDriver;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtils.width15),
        margin: EdgeInsets.only(bottom: ScreenUtils.width5),
        width: ScreenUtils.width,
        height: ScreenUtils.height * 0.075,
        decoration: TileDecorative(),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: bohibaTheme.dividerColor,
            ),
            Gap(10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BohibaMarqueeText(
                  width: ScreenUtils.width * 0.5,
                  text: user.profile?.name ?? '',
                  overflowText: user.profile?.name ?? '',
                  style: TextStyle(
                    fontSize: bohibaTheme.textTheme.bodyLarge!.fontSize,
                    fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
                    color: bohibaTheme.textTheme.titleLarge!.color,
                  ),
                  marqueeTextStyle: TextStyle(
                    fontSize: bohibaTheme.textTheme.bodyLarge!.fontSize,
                    fontWeight: bohibaTheme.textTheme.bodyLarge!.fontWeight,
                    color: bohibaTheme.textTheme.titleLarge!.color,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${user.address?.district ?? ''} ",
                      style: TextStyle(
                        fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                        fontWeight:
                            bohibaTheme.textTheme.labelMedium!.fontWeight,
                        color: bohibaTheme.textTheme.bodyLarge!.color,
                      ),
                    ),
                    Gap(5.w),
                    Text(
                      user.address?.state ?? '',
                      style: TextStyle(
                        fontSize: bohibaTheme.textTheme.titleMedium!.fontSize,
                        fontWeight:
                            bohibaTheme.textTheme.labelMedium!.fontWeight,
                        color: bohibaTheme.textTheme.bodyLarge!.color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            RoleWidget(
              truckOwnerWidget: (widget.showStatus == true)
                  ? Text(user.profile?.connect?.capitalizeFirst ?? '')
                  : SizedBox.shrink(),
              driverWidget: user.profile?.connect == ConnectionType.accept.name
                  ? Text(user.profile?.connect?.capitalizeFirst ?? '')
                  : Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (!widget.showDialog) {
                              showGeneralDialog(
                                context: context,
                                pageBuilder: (context, p1, p2) {
                                  return ConnectionRequestModal(
                                    connectionType: ConnectionType.reject,
                                    onAction: widget.onReject,
                                  );
                                },
                              );
                            }
                          },
                          child: Container(
                            height: 30.w,
                            width: 30.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: bohibaTheme.colorScheme.error
                                  .withValues(alpha: 0.25),
                            ),
                            child: Icon(
                              Icons.close,
                              size: 16.w,
                              color: bohibaTheme.colorScheme.error,
                            ),
                          ),
                        ),
                        Gap(10.w),
                        GestureDetector(
                          onTap: () {
                            if (!widget.showDialog) {
                              showGeneralDialog(
                                context: context,
                                pageBuilder: (context, p1, p2) {
                                  return ConnectionRequestModal(
                                    connectionType: ConnectionType.accept,
                                    onAction: widget.onAccept,
                                  );
                                },
                              );
                            }
                          },
                          child: Container(
                            height: 30.w,
                            width: 30.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: bohibaTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.25),
                            ),
                            child: Icon(
                              EvaIcons.checkmark,
                              size: 22.w,
                              color: bohibaTheme.colorScheme.onSurface,
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
